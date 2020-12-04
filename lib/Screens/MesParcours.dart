import 'package:fete_science_app/Services/Database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    getData();
    return Container();
  }
}
