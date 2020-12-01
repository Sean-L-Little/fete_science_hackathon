import 'package:fete_science_app/Services/Auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../Services/Services.dart';

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}


class _TestState extends State<Test> {
  final Services _serv = Services();
  final Auth _auth = Auth();
 // Response rep = _serv.getResponse();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('test'),
      ),
      body: Container(
        child: RaisedButton(
          child: Text('Deconnexion',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),),
          color: Colors.lightGreen[400],
          onPressed: () async {
            _auth.signOut();
          },
        ),

      ),
    );
  }
}
