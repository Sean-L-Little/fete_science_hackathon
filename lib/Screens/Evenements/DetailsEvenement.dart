import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fete_science_app/Services/Database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fete_science_app/Services/Auth.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:social_share_plugin/social_share_plugin.dart';

class DetailsEvenement extends StatefulWidget {
  DetailsEvenement({Key key, this.id, this.title, this.user, this.data,}) : super(key: key);
  final User user;
  final String title;
  final Map<String, dynamic> data;
  final String id;


  @override
  _DetailsEvenementState createState() => _DetailsEvenementState();
}

class _DetailsEvenementState extends State<DetailsEvenement> {
  final Auth _auth = Auth();
  final Database _dbService = Database();

  bool organisateur=false;
  final _formKey = GlobalKey<FormState>();
  String placesRestantesOrga='';
  String placesRestantes='';
  
  bool voted=false;

  double nb_etoiles=0;
  double nb_votes=0;

  List parcoursList = new List<String>();

  String parcours='';


  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
   // getParcours();
    getOrga();
    getRemplissage();
    initPlatformState();
  }

  String getTelephone(){
    var telDuLieu= widget.data["fields"]["telephone_du_lieu"];
    String lienInsc= widget.data["fields"]["lien_d_inscription"];

    String telephone='';
    var lienSplit=[];
    if(lienInsc!=null){
        lienSplit = lienInsc.split(',');
        if(lienSplit.length>1){
          for(int i=0;i<lienSplit.length;i++){
            if(lienSplit[i].toString().startsWith('0')){
              telephone=lienSplit[i];
            }
          }
        }
    }
    if(telDuLieu!=null){
      telephone=telDuLieu;
    }

    return telephone;
  }

  getRemplissage() async {
    try {
      await _dbService.evenementsGrosseCollection.doc(widget.id).get().then((
          value) =>

      value.get("places_restantes") != null ?
      placesRestantes = value.get("places_restantes") as String
          : placesRestantes = "");

      setState(() {});
    }catch(e){
      placesRestantes= 'Non Renseigné';
    }
  }


  getOrga() async {
    await _dbService.usersCollection.doc(widget.user.uid).get().then((value) =>
    organisateur = value.get("organisateur") as bool);
    setState(() {});
  }

  getParcours() async{
    var snaps =_dbService.parcoursCollection.where("user_id",isEqualTo: widget.user.uid).snapshots();
    snaps.forEach((element) {
      print(element.toString());
    });
  }


  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await SocialSharePlugin.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }



  @override
  Widget build(BuildContext context) {

    widget.data["nb_etoiles"] != null ? nb_etoiles=widget.data["nb_etoiles"]:nb_etoiles=0;
    widget.data["nb_votes"] != null ? nb_votes=widget.data["nb_votes"]:nb_votes=0;

    String telephone = getTelephone();


    Color color = Theme.of(context).primaryColor;
    Widget buttonSection = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          telephone != '' ?
          GestureDetector(
            onTap: () {_launchURL("tel://+33"+getTelephone().substring(1));},
            child: _buildButtonColumn(color, Icons.call, 'Appeler'),
          )
          : _buildButtonColumn(Colors.grey[500], Icons.call, 'Appeler'),
          GestureDetector(
              onTap: () async {
                String url = widget.data["lien_canonique"];
                final quote = widget.data["titre_fr"];
                final result = await SocialSharePlugin.shareToFeedFacebookLink(
                    url: url,
                  quote: quote,
                  onSuccess:  (_) {
                      print('Partage sur FB réussi');
                      return;
                  },
                  onError: (err) {
                    print('Partage sur FB error: ' + err);
                    return;
                  }
                );
              },
              child: _buildButtonColumn(color, FontAwesomeIcons.facebook, 'Partager')),
          GestureDetector(
              onTap:() async {
                String url = widget.data["lien_canonique"];
                final quote = widget.data["titre_fr"];
                final result = await SocialSharePlugin.shareToTwitterLink(
                    url: url,
                    text: quote,
                    onSuccess:  (_) {
                  print('Partage sur Twitter réussi');
                  return;
                  });
              },
              child: _buildButtonColumn(color, FontAwesomeIcons.twitter, 'Partager')),
        ],
      ),
    );

    Widget starSection = Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Column(
        children: [
          RatingBar.builder(
            initialRating: nb_votes != 0 ? nb_etoiles/nb_votes : 3,
            minRating: 0.5,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              size: 16.0,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              if(!voted) {
                setState(() {
                  nb_votes+=1;
                  voted = true;
                  nb_etoiles+=rating;
                });
                _dbService.changeRating(
                    widget.id, nb_etoiles, nb_votes);
              }
            },
          ),
          SizedBox(height:5.0),
          Text(nb_votes.toString().substring(0,1) + " votes",
          style: TextStyle(fontSize: 18.0),),
        ],
      ),
    );


    Widget titleSection = Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            /*1*/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (widget.data["fields"]["titre_fr"] != null) ?
                Text(widget.data["fields"]["titre_fr"],
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                )
                    :Text("Pas de titre !",
                  style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
                ),
                SizedBox(height:15.0),
                (widget.data["fields"]["nom_du_lieu"] != null) ?
                Text(
                  widget.data["fields"]["nom_du_lieu"] + (widget.data["fields"]["ville"] != null ? ", " + widget.data["fields"]["ville"]: ""),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    color: Colors.black,
                  ),
                )
                    :Text(
                  "Pas de lieu !",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height:15.0),
                (widget.data["fields"]["horaires_detailles_fr"] != null) ?
                Text(
                  widget.data["fields"]["horaires_detailles_fr"],
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                )
                    :Text(
                  "Pas de description !",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height:15.0),
                (widget.data["fields"]["description_longue_fr"] != null) ?
                Text(
                  widget.data["fields"]["description_longue_fr"],
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                )
                    :Text(
                  "Pas de description !",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          /*3*/
        ],
      ),
    );
    
    Widget voirRemplissage() {
      Color textCol = Colors.black;
      if(placesRestantes != null && placesRestantes != '' && placesRestantes != "Non Renseigné") {
        int places = int.parse(placesRestantes);
        if(places < 20) textCol = Colors.red;
      }
      return Text(
          "Places Restantes: " + placesRestantes,
        style: TextStyle(
          color: textCol,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    Widget modifierRemplissage =
    Container(
      padding: EdgeInsets.only(left:20.0),
    child: Form(
      key: _formKey,
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextFormField(
              initialValue: placesRestantes,
              validator: (val) => val.isEmpty ? "Places Restantes" : null,
              onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              onChanged: (val) {
                setState(() {
                  print("val" + val);
                  placesRestantesOrga = val;
                });
              },
              decoration: InputDecoration(
                  icon: Icon(Icons.people),
                  hintText: 'Places Restantes'

              ),
              maxLines: 1,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,

            ),
          ),
          Container(
            padding: EdgeInsets.all(20.0),
            child: RaisedButton(
              child: Text('Confirmer',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),),
              color: Theme.of(context).primaryColor,
              onPressed: () async {
                print(placesRestantesOrga);
                if(placesRestantesOrga!='') {
                  print("Widget ID: " +widget.id);
                  _dbService.updatePlaces(widget.id,placesRestantesOrga);
                }
              },
            ),
          ),
        ],
      ),
    )
    );

    Widget ajoutParcours(){

      return new StreamBuilder<QuerySnapshot>(
          stream: _dbService.parcoursCollection.where("user_id",isEqualTo: widget.user.uid).snapshots(),
          builder: (context, snapshot) {
            if(!snapshot.hasData){
              return CircularProgressIndicator();
            }if(snapshot.data.docs.length==0){
              return Text('No');
            }

            else{
              List<DropdownMenuItem> parcoursItems=[];
              for(int i=0;i<snapshot.data.docs.length;i++){
                DocumentSnapshot snap = snapshot.data.docs[i];
                parcoursItems.add(
                  DropdownMenuItem(
                    child: Text(
                      snap.get("nom"),
                    ),
                    value:"${snap.id}",
                  )
                );
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget> [
                  Icon(FontAwesomeIcons.route),
                  SizedBox(width: 20.0,),
                  DropdownButton(
                    hint: Text('Ajouter à un parcours'),
                      items: parcoursItems,
                      onChanged: (parcoursValue){
                        setState(() {
                          parcours = parcoursValue;
                        });
                        _dbService.addEventToParcours(widget.data["fields"]['identifiant'], parcoursValue);
                      }
                  )
                ]
              );
            }
          }
      );
    }

    // Widget ajoutParcours =
    // StreamBuilder<QuerySnapshot>(
    //   stream: _dbService.parcoursCollection.where("user_id",isEqualTo: widget.user.uid).snapshots(),
    //   builder: (context, snapshot) {
    //     return Row(
    //       children: <Widget>[
    //         DropdownButton <String>(
    //           value: parcours,
    //           icon: Icon(Icons.arrow_downward),
    //           iconSize: 24,
    //           elevation: 16,
    //           style: TextStyle(
    //               color: Colors.deepPurple
    //           ),
    //           underline: Container(
    //             height: 2,
    //             color: Colors.deepPurpleAccent,
    //           ),
    //           onChanged: (String newValue) {
    //             setState(() {
    //               parcours = newValue;
    //             });
    //           },
    //           items: snapshot.data.docs
    //               .map((DocumentSnapshot document) {
    //                 print(": "+document.id);
    //                 if(!parcoursList.contains(document.id)) {
    //                   parcoursList.add(document.id);
    //                   print("Code in here !!!!");
    //                   return new DropdownMenuItem<String>(
    //                     value: document.id,
    //                     child: Text(document.get("nom").toString()),
    //                   );
    //                 }
    //           }).toList(),
    //         )
    //       ],
    //
    //     );
    //   }
    // );



    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Evenement : '+ (widget.data["fields"]["identifiant"] != null ? widget.data["fields"]["identifiant"]: 'Pas d\'identifiant')),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            widget.data["fields"]["image_source"] != null ?
            Image.network(
              widget.data["fields"]["image_source"],
              width: 600,
              height: 240,
              fit: BoxFit.cover,)
                : Image.network("https://blog.hubspot.com/hubfs/Shrug-Emoji.jpg",
              width: 600,
              height: 240,
              fit: BoxFit.cover,),
            buttonSection,
            SizedBox(height:15.0),
            starSection,
            organisateur ? modifierRemplissage : voirRemplissage(),
            ajoutParcours(),
            titleSection,

            //TODO Bien implementer l'ajout des parcours

          ],
        ),
      ),
    );
  }

  Column _buildButtonColumn(Color color, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height:20.0,
        ),
        Icon(icon, color: color),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  _launchURL(url) async{
    if(await canLaunch(url)){
      await launch(url);
    }else{
      throw 'Could not launch $url';
    }
  }

}