import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fete_science_app/Services/Database.dart';

import 'Parcours.dart';

class ListeParcours extends StatefulWidget {
  ListeParcours({Key key, this.user}) : super(key: key);

  final User user;

  @override
  _ListeParcoursState createState() => _ListeParcoursState();
}

class _ListeParcoursState extends State<ListeParcours> {


  final Database _dbService = Database();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _dbService.getParcoursStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator()
            );
          }
          else if(snapshot.data==null){
            return Text('Pas d\'évènements disponible');
          }else if(snapshot.data.docs.length>0){
            return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, i) {
                  if(snapshot.data.docs[i].data()["prive"] != null && !snapshot.data.docs[i].data()["prive"]) {
                    return Card(
                        color: Colors.lightGreen[100],
                        child: ListTile(
                          title: snapshot.data.docs[i].data()["nom"] != null ?
                          Text(snapshot.data.docs[i].data()["nom"],
                          style: TextStyle(
                            fontSize: 24.0
                          ),)
                              : Text('Parcours sans nom'),
                          subtitle: snapshot.data.docs[i]
                              .data()["description"] != null ?
                          Text(snapshot.data.docs[i].data()["description"],
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 16.0
                          ),)
                              : Text('Pas de description'),
                          trailing: RaisedButton(
                              color: Colors.lightGreen[600],
                              child: Text(
                                'Voir Plus',
                                style: TextStyle(color: Colors.white),),
                              onPressed: () {
                                Navigator.push(context,
                                  MaterialPageRoute(builder: (context) =>
                                      Parcours(id: snapshot.data.docs[i].id,
                                          data: snapshot.data.docs[i].data(),user: widget.user,)),
                                );
                              }),
                        )
                    );
                  }else {
                    return null;
                  }
                });
          }else{
            return(Text('Vous n\'avez pas encore de parcours !'));
          }
        }
    );
  }
}
