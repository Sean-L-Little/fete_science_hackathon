import 'package:firebase_auth/firebase_auth.dart';

class Auth {

  final FirebaseAuth _auth=FirebaseAuth.instance;

  Stream<User> get user{
    return _auth.authStateChanges();
  }

  Future signInAnon() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      print (userCredential.user.uid);
      return userCredential.user;
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  Future signInEmail(String email, String pword) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: pword);

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print('e code: '+ e.code);
      if(e.code == 'invalid-email'){
        print('Invalid Email !');
      }else if(e.code =='user-not-found'){
        print('No user found for this email !');
      }else if(e.code=='wrong-password'){
        print('Wrong Password provided for user');
      }
    } catch (e){
      print(e.toString());
    }
  }

  Future registerEmail(String email, String pword) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: pword);

    //  await userCredential.user.updateProfile(displayName: nickname, photoURL: url);

      signInEmail(_auth.currentUser.email, pword);

      return userCredential.user;
    } catch (e){
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

}
