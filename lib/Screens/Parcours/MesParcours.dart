import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fete_science_app/Services/Database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'NouveauParcours.dart';
import 'Parcours.dart';

class MesParcours extends StatefulWidget {
  MesParcours({Key key, this.title, this.user, this.id}) : super(key: key);
  final User user;
  final String title;
  final String id;

  @override
  _MesParcoursState createState() => _MesParcoursState();
}

class _MesParcoursState extends State<MesParcours> {

  Database _dbService= Database();
  Stream dataStream;


  getData() async {

    dataStream = _dbService.parcoursCollection
        .where('user_id', isEqualTo: widget.id)
        .snapshots();

  }

  Widget newParcours(){
    return Center(
      child: RaisedButton(
        child: Text('Nouveau Parcours', style: TextStyle(color: Colors.white),),
        color : Colors.lightGreen[600],
        onPressed:() {
          Navigator.push(context,
          MaterialPageRoute(builder: (context) => NouveauParcours(user: widget.user)));

        },
      ),
    );
  }
  
  Widget listParcours(){
    return StreamBuilder<QuerySnapshot>(
        stream:  _dbService.parcoursCollection.where("user_id",isEqualTo: widget.user.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Chargement des évènements ...');
          }
          else if(snapshot.data==null){
            return Text('Pas d\'évènements disponible');
          }else if(snapshot.data.docs.length>0){
            return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, i) {
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

                });
          }else{
            return(Text('Vous n\'avez aucun parcours !'));
          }
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
      backgroundColor: Colors.lightGreen[100],
      appBar: AppBar(
        backgroundColor: Colors.lightGreen[400],
        title: Text('Mes Parcours'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          listParcours(),
          newParcours(),
        ],
      ),
    );
  }
}

