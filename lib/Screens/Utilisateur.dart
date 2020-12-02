import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fete_science_app/Services/Database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fete_science_app/Services/Auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class Utilisateur extends StatefulWidget {
  Utilisateur({Key key, this.title, this.user, this.data,}) : super(key: key);
  final User user;
  final String title;
  final Map<String, dynamic> data;

  @override
  _UtilisateurState createState() => _UtilisateurState();
}

class _UtilisateurState extends State<Utilisateur> {
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
          Expanded(
            /*1*/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*2*/
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child:
                  (widget.data["displayName"] != null && widget.data["displayName"] != "") ?
                  Text(widget.data["displayName"],
                    style: TextStyle(fontSize: 25),
                  )
                      :Text("Pas de Pseudo !",
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                (widget.data["phoneNumber"] != null && widget.data["phoneNumber"] != "") ?
                Text(
                  widget.data["phoneNumber"],
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[500],
                  ),
                )
                    :Text(
                  "Pas de numéro de téléphone",
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
        title: Text('Utilisateur : '+ (widget.data["displayName"] != null && widget.data["displayName"] != "" ? widget.data["displayName"]: 'Pas de Pseudo')),
        centerTitle: true,
      ),
      body: Column(
          children: <Widget>[
            (widget.data["photoURL"] != null && widget.data["photoURL"] != "") ?
                Image.network(
                    widget.data["photoURL"],
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


//
// class BuildUser extends StatefulWidget {
//   BuildUser({Key key, this.user}) : super(key: key);
//
//   final User user;
//   @override
//   _BuildUserState createState() => _BuildUserState();
// }
//
// class _BuildUserState extends State<BuildUser> {
//   final Database _dbService = Database();
//
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//         stream:  _dbService.getEvenementsStream(),
//         builder: (context, snapshot) {
//             if(snapshot.connectionState == ConnectionState.waiting){
//             return Text('En attente de Connexion ...');
//             }else if(snapshot.data ==null){
//               return Text('Data Null !!!');
//             } else if(snapshot.data.docs.length>0){
//             return Card(
//               color: Colors.lightGreen[100],
//               child: ListTile(
//                 leading: CircleAvatar(
//                   radius: 30,
//                     backgroundImage:
//                     snapshot.data.docs[0].data()["fields"]["apercu"] != null ? NetworkImage(snapshot.data.docs[0].data()["fields"]["apercu"]) : null,
//                 ),
//                 title:
//                 snapshot.data.docs[0].data()["fields"]["titre_fr"] != null ?
//                 Text(
//                   snapshot.data.docs[0].data()["fields"]["titre_fr"],
//                   style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),) : null,
//                 subtitle:
//                 snapshot.data.docs[0].data()["fields"]["description_fr"] != null ?
//                 Text(
//                     snapshot.data.docs[0].data()["fields"]["description_fr"],
//                     style: TextStyle(fontSize: 25 )) : null,
//               ),
//             );
//             }else{
//             return Text('Une erreur s\'est produite');
//             }
//             }
//     );
//
//         }
// }
