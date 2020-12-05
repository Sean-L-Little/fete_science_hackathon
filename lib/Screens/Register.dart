import 'package:flutter/material.dart';
import 'package:fete_science_app/Services/Auth.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final Auth _auth = Auth();
  final _formKey = GlobalKey<FormState>();
  bool loading=false;
  bool pwordGood=false;
  bool orga=false;
  String email='';
  String url='';
  String pword='';
  String nickname='';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[100],
      appBar: AppBar(
        backgroundColor: Colors.lightGreen[400],
        title: Text('Créez un compte'),
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
                    validator: (val) => val.isEmpty ? "Enter Email" : null,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    onChanged: (val) {
                      setState(() {
                        email = val;
                      });
                    },
                    decoration: InputDecoration(
                        icon: Icon(Icons.email),
                        hintText: 'Entrez votre email'

                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,

                  ),
                  SizedBox(height:20),
                  TextFormField(
                      validator: (val) => val.length < 6 ? "Mot de passe doit contenir au moins 6 charactères" : null,
                      onFieldSubmitted: (_) {
                          if(_formKey.currentState.validate()){
                              pwordGood=true;
                          }
                      },
                      onChanged: (val) {
                        setState(() {
                          pword = val;
                        });
                      },
                      decoration: InputDecoration(
                          icon: Icon(Icons.lock),
                          hintText: 'Entrez votre mot de passe'

                      ),
                      maxLines: 1,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.visiblePassword,  //Counter intuitive, I know ...
                      obscureText: true),
                  SizedBox(height:10),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: CheckboxListTile(
                        title: Text('Organisateur'),
                        onChanged: (bool val) {
                          setState(() {
                            orga = val;
                          });
                        },
                        tristate: false,
                        value: orga,
                      ),
                  ),

                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: RaisedButton(
                      child: Text('Créer Compte',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                      color: Colors.lightGreen[400],
                      onPressed: () async {
                        createAcc();
                        if(pwordGood) {
                          Navigator.pop(context);
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




  void createAcc() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        loading = true;
      });
      try {
        await _auth.registerEmail(email, pword,orga).then((value) => null);

          setState(() {
            loading=false;
            Navigator.pop(context);
          });

      } on Exception catch(e){
        setState(() {
          print(e.toString());

        });
      }
    }
  }
}
