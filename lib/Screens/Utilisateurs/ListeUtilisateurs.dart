import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fete_science_app/Screens/MenuDrawer.dart';
import 'package:fete_science_app/Services/Database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fete_science_app/Services/Auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'Utilisateur.dart';

// class ListeUtilisateurs extends StatefulWidget {
//   ListeUtilisateurs({Key key, this.title, this.user}) : super(key: key);
//   final User user;
//   final String title;
//
//   @override
//   _ListeUtilisateursState createState() => _ListeUtilisateursState();
// }
//
// class _ListeUtilisateursState extends State<ListeUtilisateurs> {
//   @override
//   Widget build(BuildContext context) {
//     return BuildUser();
//   }
// }


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
        stream:  _dbService.getUsersStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator()
            );
          }else if(snapshot.data ==null){
            return Text('Data Null !!!');
          } else if(snapshot.data.docs.length>0){
            return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context,i){
                return Card(
                  color: Colors.lightGreen[200],
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage:
                      snapshot.data.docs[i].data()["photoURL"] != null ? NetworkImage(snapshot.data.docs[i].data()["photoURL"]) : null,
                    ),
                    title:
                      (snapshot.data.docs[i].data()["displayName"] != null && snapshot.data.docs[i].data()["displayName"] != "") ?
                        Text(snapshot.data.docs[i].data()["displayName"],
                            style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),)
                        : Text('Pas de Pseudo !',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                    subtitle:
                      (snapshot.data.docs[i].data()["phoneNumber"] != null && snapshot.data.docs[i].data()["phoneNumber"] != "")?
                        Text(snapshot.data.docs[i].data()["phoneNumber"],
                            style: TextStyle(fontSize: 25 ))
                        : Text('Pas de Numéro !', style: TextStyle(fontSize: 25 )),
                    trailing: RaisedButton(
                        color: Colors.lightGreen[600],
                        child:Text('Voir Plus',
                          style: TextStyle(color: Colors.white),),
                        onPressed:() {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Utilisateur(data: snapshot.data.docs[i].data())));
                        }
                    ),
                  ),
                );
              },
            );
          }else{
            return Text('Une erreur s\'est produite');
          }
        }
    );

  }
}
