import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fete_science_app/Screens/Register.dart';
import 'package:fete_science_app/Services/Auth.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final Auth _auth = Auth();
  final _formKey = GlobalKey<FormState>();

  bool loading;

  String email;

// String url;
  String pword;

// String nickname;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[100],
      appBar: AppBar(
        backgroundColor: Colors.lightGreen[400],
        title: Text('Fête de la Science 2019'),
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
                    validator: (val) => val.isEmpty ? "Entrez votre Email" : null,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    onChanged: (val) {
                      setState(() {
                        email = val;
                      });
                    },
                    decoration: InputDecoration(
                      icon: Icon(Icons.email),
                      hintText: 'Entrez votre Email'

                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,

                  ),
                  SizedBox(height:10),
                  TextFormField(
                      validator: (val) => val.isEmpty ? "Entrez votre Mot De Passe" : null,
                      onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                      onChanged: (val) {
                        setState(() {
                          pword = val;
                        });
                      },
                      decoration: InputDecoration(
                        icon: Icon(Icons.lock),
                        hintText: 'Enter Password'

                      ),
                      maxLines: 1,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.visiblePassword,  //Counter intuitive, I know ...
                      obscureText: true),


                  Container(
                    padding: EdgeInsets.all(20.0),
                    child: RaisedButton(
                      child: Text('Connexion',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),),
                      color: Colors.lightGreen[400],
                      onPressed: () async {

                        connect();
                      },
                    ),
                  ),

                  SizedBox(
                    height: 30,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Register()),
                        );
                      },
                      child: Text(
                        "Créez un compte",
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    )
                  )
                ]),
          ),
        ),
      ),
    );
  }

  void connect() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        loading = true;
      });
      try {
        await _auth.signInEmail(email, pword);
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
