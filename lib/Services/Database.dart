import 'package:cloud_firestore/cloud_firestore.dart';

class Database{

  final CollectionReference usersCollection= FirebaseFirestore.instance.collection("/UserCollection");
  final CollectionReference evenementsCollection= FirebaseFirestore.instance.collection("/EvenementsCollection");
  final CollectionReference parcoursCollection= FirebaseFirestore.instance.collection("/ParcoursCollection");
  final CollectionReference evenementsGrosseCollection= FirebaseFirestore.instance.collection("/Evenements");

  Stream<QuerySnapshot> getUsersStream(){
    return usersCollection.snapshots();
  }

  Stream<QuerySnapshot> getEvenementsStream(){
    return evenementsGrosseCollection.snapshots();
  }

  Future changeURL(uid, url) async{
    return usersCollection.doc(uid).update({
      'photoURL': url,
    }).then((value) => print("User Updated ;)")).catchError((error) => print("Error Updating User :c "+error));
  }

  Future changeDisplayName(uid, pseudo) async{
    return usersCollection.doc(uid).update({
      'displayName': pseudo,
    }).then((value) => print("User Updated ;)")).catchError((error) => print("Error Updating User :c "+error));
  }

  Future changePhoneNumber(uid, number) async{
    return usersCollection.doc(uid).update({
      'phoneNumber': number,
    }).then((value) => print("User Updated ;)")).catchError((error) => print("Error Updating User :c "+error));
  }

  Future changeFacebook(uid, fb) async{
    return usersCollection.doc(uid).update({
      'facebook': fb,
    }).then((value) => print("User Updated ;)")).catchError((error) => print("Error Updating User :c "+error));
  }

  Future changeTwitter(uid, twit) async{
    return usersCollection.doc(uid).update({
      'twitter': twit,
    }).then((value) => print("User Updated ;)")).catchError((error) => print("Error Updating User :c "+error));
  }


  Future addUser(uid,organisateur) async{
    return usersCollection.doc(uid).set({
      'organisateur':organisateur,
      'displayName':'',
      'photoURL':'',
      'phoneNumber':'',
      'facebook':'',
      'twitter': '',
      'parcours':[]
    }).then((value) => print("User Created ;)")).catchError((error) => print("Error Creating User :c "+error));
  }
}