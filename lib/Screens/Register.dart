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
        title: Text('Register to Twistic'),
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
                        hintText: 'Enter Email'

                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,

                  ),
                  SizedBox(height:10),
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
                          hintText: 'Enter Password'

                      ),
                      maxLines: 1,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.visiblePassword,  //Counter intuitive, I know ...
                      obscureText: true),


                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: RaisedButton(
                      child: Text('Create Account',
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
        await _auth.registerEmail(email, pword).then((value) => null);

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
