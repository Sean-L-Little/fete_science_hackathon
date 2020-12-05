import 'package:fete_science_app/Services/Auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class EditUser extends StatefulWidget {
  EditUser({Key key, this.title, this.user}) : super(key: key);
  final User user;
  final String title;


  @override
  _EditUserState createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  final Auth _auth = Auth();
  final _formKey = GlobalKey<FormState>();
  bool loading=false;

  String url='';
  String numero='';
  String pseudo='';
  String twitter='';
  String facebook='';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[100],
      appBar: AppBar(
        backgroundColor: Colors.lightGreen[400],
        title: Text('Changez Vos Informations'),
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
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    onChanged: (val) {
                      setState(() {
                        pseudo = val;
                      });
                    },
                    decoration: InputDecoration(
                        icon: Icon(Icons.account_circle),
                        hintText: 'Entrez un Pseudo'

                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,

                  ),
                  SizedBox(height:10),
                  TextFormField(
                      onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                      onChanged: (val) {
                        setState(() {
                          url = val;
                        });
                      },
                      decoration: InputDecoration(
                          icon: Icon(Icons.image),
                          hintText: 'Entrez l\'url de votre image de profile'

                      ),
                      maxLines: 1,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,  //Counter intuitive, I know ...
                      ),
                  SizedBox(height:10),
                  TextFormField(
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    onChanged: (val) {
                      setState(() {
                        numero = val;
                      });
                    },
                    decoration: InputDecoration(
                        icon: Icon(Icons.phone),
                        hintText: 'Entrez Votre Numero de Téléphone'

                    ),
                    maxLines: 1,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height:10),
                  TextFormField(

                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    onChanged: (val) {
                      setState(() {
                        facebook = val;
                      });
                    },
                    decoration: InputDecoration(
                        icon: Icon(FontAwesomeIcons.facebook),
                        hintText: 'Entrez Votre Facebook'

                    ),
                    maxLines: 1,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height:10),
                  TextFormField(
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    onChanged: (val) {
                      setState(() {
                        twitter = val;
                      });
                    },
                    decoration: InputDecoration(
                        icon: Icon(FontAwesomeIcons.twitter),
                        hintText: 'Entrez Votre Twitter'

                    ),
                    maxLines: 1,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height:10),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: RaisedButton(
                      child: Text('Confirmer',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                      color: Colors.lightGreen[400],
                      onPressed: () async {
                        editAcc();
                        //Navigator.pop(context);
                      },
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }

  void editAcc() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        loading = true;
      });
      try {
        if(url != ""){
          await _auth.changeURL(url);
        }
        if(pseudo != ""){
          await _auth.changeDisplayName(pseudo);
        }
        if(numero != ""){
          await _auth.changePhoneNumber(numero);
        }
        if(twitter!=""){
          await _auth.changeTwitter(twitter);
        }
        if(facebook!=""){
          await _auth.changeFacebook(facebook);
        }
        setState(() {
          loading=false;
        });
      } on Exception catch(e){
        setState(() {
          print(e.toString());
          loading=false;
        });
      }
    }
  }
}
