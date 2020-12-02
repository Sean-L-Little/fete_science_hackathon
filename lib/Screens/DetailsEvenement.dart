import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fete_science_app/Services/Database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fete_science_app/Services/Auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsEvenement extends StatefulWidget {
  DetailsEvenement({Key key, this.title, this.user, this.data,}) : super(key: key);
  final User user;
  final String title;
  final Map<String, dynamic> data;

  @override
  _DetailsEvenementState createState() => _DetailsEvenementState();
}

class _DetailsEvenementState extends State<DetailsEvenement> {
  final Auth _auth = Auth();

  @override
  Widget build(BuildContext context) {
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


    Widget titleSection = Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Flexible(
            /*1*/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*2*/
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 8),
                        child:
                        (widget.data["fields"]["titre_fr"] != null) ?
                        Text(widget.data["fields"]["titre_fr"],
                          style: TextStyle(fontSize: 25),
                        )
                            :Text("Pas de titre !",
                          style: TextStyle(fontSize: 25),
                        ),

                      ),
                    ),
                    SizedBox(width: 10.0),
                    (widget.data["organisateur"] != null && widget.data["organisateur"] != false) ?
                    Icon(FontAwesomeIcons.userShield,size: 25.0,): SizedBox(width: 10.0),
                  ],
                ),
                (widget.data["fields"]["description_longue_fr"] != null) ?
                Expanded(
                  child: Text(
                    widget.data["fields"]["description_longue_fr"],
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[500],
                    ),
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
      body: Column(
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


          titleSection,
          buttonSection,
        ],
      ),
    );
  }

  Column _buildButtonColumn(Color color, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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