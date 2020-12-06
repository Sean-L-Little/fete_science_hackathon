import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fete_science_app/Services/Database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Evenements/DetailsEvenement.dart';

class Parcours extends StatefulWidget {
  Parcours({Key key, this.id, this.data, this.title, this.user}) : super(key: key);
  final User user;
  final String title;
  final Map<String, dynamic> data;
  final String id;



  @override
  _ParcoursState createState() => _ParcoursState();
}


class _ParcoursState extends State<Parcours> {

  List<Card> cardList = new List<Card>();
  Database _dbService= Database();
  List<dynamic> _eventIds=[];
  Stream dataStream;
  String prive='prive';
  bool isPrive;
  // _events = [];

  bool parseBool(String boolean){
    return boolean.toLowerCase()=='prive';
  }

  getPrive(){
    widget.data['prive'] ? prive='prive' : prive= 'public';
  }

  getData() async {
    _eventIds=widget.data["parcours"];
    if(_eventIds.isNotEmpty) {
      dataStream = _dbService.evenementsGrosseCollection
          .where(
          'fields.identifiant', whereIn: _eventIds != [] ? _eventIds : ["0"])
          .snapshots();
    }
  }


  initState() {
    isPrive = !widget.data['prive'];
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text('Parcours: ' + widget.data["nom"]),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              listEvents(),
              widget.data["user_id"]==widget.user.uid ?
              Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Visiblité du parcours',
                    style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold)),
                    Row(
                      children: <Widget>[
                        Switch(
                          value: isPrive,
                          onChanged: (value){
                            setState(() {
                              isPrive = value;
                              _dbService.changeParcoursPrive(widget.id, !isPrive);
                              print(isPrive);
                            });
                          },
                          activeTrackColor: Colors.lightGreen,
                          activeColor: Colors.green
                        ),
                        Text('Privé / Public')
                      ],
                    )
                  ],
                ),
              ) : SizedBox(height:0.0,width:0.0),
              widget.data["user_id"]==widget.user.uid ? suppressionParcours(context) : SizedBox(height:0.0,width:0.0),
            ],
          ),
        )
    );
  }

  Widget listEvents(){
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
          stream: dataStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              //print("Data Length: " + snapshot.data.docs.length.toString());
              return Center(child: CircularProgressIndicator());
            }
            else if(snapshot.data==null){
              return Container(
                padding: EdgeInsets.all(20.0),
                  child: Text('Il n\'y a pas encore d\'événements sur ce parcours !',style: TextStyle(fontSize: 30.0), textAlign: TextAlign.center,));
            }else if(snapshot.data.docs.length>0){
              return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, i) {
                    return Card(
                        color: Theme.of(context).accentColor,
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage:
                            snapshot.data.docs[i].data()["fields"]["apercu"] != null ? NetworkImage(snapshot.data.docs[i].data()["fields"]["apercu"]) : NetworkImage("https://blog.hubspot.com/hubfs/Shrug-Emoji.jpg"),
                          ),
                          title: snapshot.data.docs[i].data()["fields"]["titre_fr"] != null ?
                          Text(snapshot.data.docs[i].data()["fields"]["titre_fr"])
                              :Text('Pas de titre'),
                          subtitle: snapshot.data.docs[i].data()["fields"]["description_fr"] != null ?
                          Text(snapshot.data.docs[i].data()["fields"]["description_fr"])
                              :Text('Pas de description'),
                          trailing: RaisedButton(
                              color: Theme.of(context).primaryColor,
                              child:Text(
                                'Voir Plus',
                                style: TextStyle(color: Colors.white),), onPressed:() {
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context) => DetailsEvenement(id: snapshot.data.docs[i].id, data: snapshot.data.docs[i].data(), user:widget.user)),
                            );
                          }),
                        )
                    );
                  });
            }else{
              return(Text('Un problème est survenu'));
            }
          }
      ),
    );

  }

  Widget suppressionParcours(context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.red,
          ),
          onPressed: () {
            _dbService.deleteParcours(widget.id);
            Navigator.pop(context);
          },
          child: Text('Supprimer le parcours'),
        )
    );
  }
}