import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fete_science_app/Services/Database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fete_science_app/Services/Auth.dart';

class Utilisateur extends StatefulWidget {
  Utilisateur({Key key, this.title, this.user}) : super(key: key);
  final User user;
  final String title;

  @override
  _UtilisateurState createState() => _UtilisateurState();
}

class _UtilisateurState extends State<Utilisateur> {
  final Auth _auth = Auth();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[100],
      appBar: AppBar(
        backgroundColor: Colors.lightGreen[400],
        title: Text('User : '),
        centerTitle: true,
      ),
      body: Column(
        children:<Widget> [
          BuildUser(),
        ],
      ),
    );
  }



}
class BuildUser extends StatefulWidget {
  BuildUser({Key key, this.user}) : super(key: key);

  final User user;
  @override
  _BuildUserState createState() => _BuildUserState();
}

class _BuildUserState extends State<BuildUser> {
  final Database _dbService = Database();


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream:  _dbService.getEvenementsStream(),
        builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
            return Text('En attente de Connexion ...');
            }else if(snapshot.data ==null){
              return Text('Data Null !!!');
            } else if(snapshot.data.docs.length>0){
            return Card(
              color: Colors.lightGreen[100],
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30,
                    backgroundImage:
                    snapshot.data.docs[0].data()["fields"]["apercu"] != null ? NetworkImage(snapshot.data.docs[0].data()["fields"]["apercu"]) : null,
                ),
                title:
                snapshot.data.docs[0].data()["fields"]["titre_fr"] != null ?
                Text(
                  snapshot.data.docs[0].data()["fields"]["titre_fr"],
                  style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),) : null,
                subtitle:
                snapshot.data.docs[0].data()["fields"]["description_fr"] != null ?
                Text(
                    snapshot.data.docs[0].data()["fields"]["description_fr"],
                    style: TextStyle(fontSize: 25 )) : null,
              ),
            );
            }else{
            return Text('Une erreur s\'est produite');
            }
            }
    );

        }
}
