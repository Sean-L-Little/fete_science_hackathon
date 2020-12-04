import 'package:fete_science_app/Screens/ListeEvenements.dart';
import 'package:fete_science_app/Screens/ListeUtilisateurs.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'EditUser.dart';
import 'Login.dart';
import 'Navigation.dart';
import 'Utilisateur.dart';

class Wrapper extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return user != null ? Navigation(title: "Fête de la Science", user: user) : Login();
  }
  
  
}