import 'package:fete_science_app/Services/Database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NouveauParcours extends StatefulWidget {
  NouveauParcours({Key key, this.title, this.user, this.id}) : super(key: key);
  final User user;
  final String title;
  final String id;

  @override
  _NouveauParcoursState createState() => _NouveauParcoursState();
}

class _NouveauParcoursState extends State<NouveauParcours> {
  final _formKey = GlobalKey<FormState>();
  Database _dbService = Database();
  String parcoursName='';
  String parcoursDesc='';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[100],
      appBar: AppBar(
        backgroundColor: Colors.lightGreen[400],
        title: Text('Nouveau Parcours'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    validator: (val) => val.isEmpty ? "Entrez le nom de votre nouveau parcours" : null,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    onChanged: (val) {
                      setState(() {
                        parcoursName = val;
                      });
                    },
                    decoration: InputDecoration(
                        icon: Icon(FontAwesomeIcons.route),
                        hintText: 'Entrez le nom de votre nouveau parcours'

                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,

                  ),
                  SizedBox(height:15.0),
                  TextFormField(
                    validator: (val) => val.isEmpty ? "Ajoutez une déscription" : null,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    onChanged: (val) {
                      setState(() {
                        parcoursDesc = val;
                      });
                    },
                    decoration: InputDecoration(
                        icon: Icon(FontAwesomeIcons.pen),
                        hintText: 'Ajoutez une déscription'

                    ),
                    minLines: 4,
                    maxLines: 5,
                    maxLength: 200,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,

                  ),

                  Container(
                    padding: EdgeInsets.all(20.0),
                    child: RaisedButton(
                      child: Text('Valider',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),),
                      color: Colors.lightGreen[600],
                      onPressed: () async {
                        if(parcoursName!='') {
                          _dbService.createParcours(widget.user.uid, parcoursName, parcoursDesc);
                          Navigator.pop(context);
                          //TODO ajouter faut dire que c'est bien enregistré partout dans l'appli pas qu'ici mdr

                        }else{
                          //TODO Ajouter manière de faire des toasts (SnackBar)
                        }
                      },
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
