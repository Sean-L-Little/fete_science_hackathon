import 'package:firebase_auth/firebase_auth.dart';
import 'Database.dart';

class Auth {

  final FirebaseAuth _auth=FirebaseAuth.instance;
  final Database _db = Database();

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
  Future changeURL(String url) async{
    await _auth.currentUser.updateProfile(photoURL: url);
    await _db.changeURL(_auth.currentUser.uid,url);

  }

  Future changeDisplayName(String pseudo) async{
    await _auth.currentUser.updateProfile(displayName: pseudo);
    await _db.changeDisplayName(_auth.currentUser.uid,pseudo);
  }


  Future changePhoneNumber(String number) async{
    //await _auth.currentUser.updatePhoneNumber(number);
    await _db.changePhoneNumber(_auth.currentUser.uid,number);
  }

  Future changeFacebook(String fb) async{
    //await _auth.currentUser.updatePhoneNumber(number);
    await _db.changeFacebook(_auth.currentUser.uid,fb);
  }

  Future changeTwitter(String twit) async{
    //await _auth.currentUser.updatePhoneNumber(number);
    await _db.changeTwitter(_auth.currentUser.uid,twit);
  }


  Future registerEmail(String email, String pword, bool orga) async {

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: pword);

    //  await userCredential.user.updateProfile(displayName: nickname, photoURL: url);

      signInEmail(_auth.currentUser.email, pword);

      _db.addUser(_auth.currentUser.uid, orga);


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
