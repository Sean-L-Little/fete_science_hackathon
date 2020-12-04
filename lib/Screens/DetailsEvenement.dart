import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fete_science_app/Services/Database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fete_science_app/Services/Auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';


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

  bool voted=false;

  double nb_etoiles=0;
  double nb_votes=0;


  @override
  Widget build(BuildContext context) {

    widget.data["nb_etoiles"] != null ? nb_etoiles=widget.data["nb_etoiles"]:nb_etoiles=0;
    widget.data["nb_votes"] != null ? nb_votes=widget.data["nb_votes"]:nb_votes=0;

    Color color = Theme.of(context).primaryColor;
    Widget buttonSection = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          (widget.data["phoneNumber"] != null&&widget.data["phoneNumber"] != "") ?
          GestureDetector(
            onTap: () {_launchURL("tel://"+widget.data["phoneNumber"]);},
            child: _buildButtonColumn(color, Icons.call, 'Appeler'),
          )

              : _buildButtonColumn(Colors.grey[500], Icons.call, 'Appeler'),
          (widget.data["facebook"] != null && widget.data["facebook"] != "") ?
          GestureDetector(
              onTap: (){_launchURL(widget.data["facebook"]); },
              child: _buildButtonColumn(color, FontAwesomeIcons.facebook, 'Facebook'))
              : _buildButtonColumn(Colors.grey[500], FontAwesomeIcons.facebook, 'Facebook'
          ),
          (widget.data["twitter"] != null && widget.data["twitter"] != "") ?
          GestureDetector(
              onTap:() {_launchURL(widget.data["twitter"]);},
              child: _buildButtonColumn(color, FontAwesomeIcons.twitter, 'Twitter'))
              : _buildButtonColumn(Colors.grey[500], FontAwesomeIcons.twitter, 'Twitter'
          ),
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
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            /*1*/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child:
                      (widget.data["fields"]["titre_fr"] != null) ?
                      Text(widget.data["fields"]["titre_fr"],
                        style: TextStyle(fontSize: 25),
                      )
                          :Text("Pas de titre !",
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                  ],
                ),
                (widget.data["fields"]["description_longue_fr"] != null) ?
                Text(
                  widget.data["fields"]["description_longue_fr"],
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[500],
                  ),
                )
                    :Text(
                  "Pas de description !",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          /*3*/
        ],
      ),
    );


    return Scaffold(
      backgroundColor: Colors.lightGreen[100],
      appBar: AppBar(
        backgroundColor: Colors.lightGreen[400],
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
            starSection,
            titleSection,

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