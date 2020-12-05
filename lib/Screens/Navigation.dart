import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'Evenements/ListeEvenements.dart';
import 'Parcours/ListeParcours.dart';
import 'Utilisateurs/ListeUtilisateurs.dart';
import 'Carte/Carte.dart';
import 'MenuDrawer.dart';
import 'Parcours/Parcours.dart';

class Navigation extends StatefulWidget {
  Navigation({Key key, this.title, this.user}) : super(key: key);
  final User user;
  final String title;

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _currentIndex=0;
  var pages=[];
  var pageTitles=[];

  initPages() {
    pages = [
      ListeEvenement(user: widget.user),
      Carte(user: widget.user),
      ListeParcours(user: widget.user),
      BuildUser(user: widget.user),
    ];

    pageTitles = [
      "Evenements",
      "Carte",
      "Parcours",
      "Utilisateurs"
    ];
  }

  @override
  Widget build(BuildContext context) {
    initPages();
    return Scaffold(
      backgroundColor: Colors.lightGreen[100],
      appBar: AppBar(
        backgroundColor: Colors.lightGreen[600],
        title: Text(pageTitles[_currentIndex]),
        centerTitle: true,
      ),
      drawer: MenuDrawer(user: widget.user), //TODO: Rajouter widget.user en mode bien
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        iconSize: 30,
        selectedItemColor: Colors.lightGreen[800],
        selectedFontSize: 17.0,
        unselectedFontSize: 15.0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.calendarCheck),
            label: 'Evenements',
          ),
          BottomNavigationBarItem(

            icon: Icon(FontAwesomeIcons.mapMarkedAlt),
            label: 'Carte',
          ),
          BottomNavigationBarItem(

            icon: Icon(FontAwesomeIcons.route),
            label: 'Parcours',
          ),
          BottomNavigationBarItem(

            icon: Icon(FontAwesomeIcons.userFriends),
            label: 'Utilisateurs',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex=index;
          });
        },
      ),
    );
  }
}
