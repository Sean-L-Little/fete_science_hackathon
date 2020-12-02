import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Services/Database.dart';

class Accueil extends StatefulWidget {
  @override
  _AccueilState createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[100],
      appBar: AppBar(
        backgroundColor: Colors.lightGreen[400],
        title: Text('Liste des évènements'),
        centerTitle: true,
      ),
      body: Center(
        child: ListeEvenement(),
      )
    );
  }
}


class ListeEvenement extends StatefulWidget {
  @override
  _ListeEvenementState createState() => _ListeEvenementState();
}

class _ListeEvenementState extends State<ListeEvenement> {
  final Database dbService = Database();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: dbService.getEvenementsStream(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return Text('Chargement des évènements ...');
          }else if(snapshot.data.docs.length>0){
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, i) {
                return Card(
                  color: Colors.lightGreen[100],
                  child: ListTile(
                    leading: Text('test' + i.toString())
                  )
                );
            });
          }else{
            return(Text('Un problème est survenu'));
          }
        }
    );
  }
}