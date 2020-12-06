import 'package:fete_science_app/Screens/Parcours/MesParcours.dart';
import 'package:fete_science_app/Services/Auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Utilisateurs/EditUser.dart';

class MenuDrawer extends StatefulWidget {
  MenuDrawer({Key key, this.title, this.user}) : super(key: key);
  final User user;
  final String title;

  @override
  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  Auth _auth = Auth();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: widget.user.photoURL != null ? Image.network(widget.user.photoURL) : Image.network('https://www.labaleine.fr/sites/default/files/image-not-found.jpg'),
              accountName: widget.user.displayName != null ? Text(widget.user.displayName,
                  style: TextStyle(fontSize: 25.0)) : Text('Pas de Pseudo'),
              accountEmail: widget.user.email != null ? Text(widget.user.email,
                  style: TextStyle(fontSize: 20.0)) : Text('Chargement'),
            ),
            RaisedButton(
              child: Text('Modifier Profil'),
              onPressed: () async {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EditUser(user: widget.user)),
                );
              },
            ),
            RaisedButton(
              child: Text('Mes Parcours'),
              onPressed: () async {
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MesParcours(user: widget.user)),
                );
              },
            ),
            RaisedButton(
              child: Text('Deconnexion'),
              color: Colors.red[300],
              onPressed: () async {
                dynamic res = await _auth.signOut();
                if (res == null) print("ffs");
              },
            ),
          ]
      ),
    );
  }
}
