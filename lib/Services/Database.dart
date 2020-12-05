import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fete_science_app/Screens/Carte/PinCarte.dart';
import 'package:flutter_map/flutter_map.dart';

class Database {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection("/UserCollection");
  final CollectionReference evenementsCollection =
      FirebaseFirestore.instance.collection("/EvenementsCollection");
  final CollectionReference parcoursCollection =
      FirebaseFirestore.instance.collection("/ParcoursCollection");
  final CollectionReference evenementsGrosseCollection =
      FirebaseFirestore.instance.collection("/Evenements");

  Stream<QuerySnapshot> getUsersStream() {
    return usersCollection.snapshots();
  }

  Stream<QuerySnapshot> getEvenementsStream() {
    return evenementsGrosseCollection.snapshots();
  }

  Stream<QuerySnapshot> getParcoursStream(){
    return parcoursCollection.snapshots();
  }

  Future<List<String>> getEvenementsForParcours(uid){
    return parcoursCollection.doc(uid).get().then((value) {
      return List.from(value.get("parcours"));
    });
  }

  // QuerySnapshot getEventFromID(id){
  //   evenementsGrosseCollection.doc(id).get().then((value) {
  //     return value;
  //   });
  // }

  Future changeRating(uid, nbEtoiles,nbVotes) async {
    // double nb_etoiles = 0;
    // double nb_votes = 0;
    // await usersCollection.doc(uid).get().then((docu) {
    //   docu.get("nb_etoiles") != null ? nb_etoiles=docu.get("nb_etoiles") : nb_etoiles=0;
    //   docu.get("nb_votes") != null ? nb_votes=docu.get("nb_votes") : nb_votes=0;
    // });
    print("UID pour les votes : " +uid);
    return evenementsGrosseCollection
        .doc(uid)
        .update({
      'nb_etoiles': nbEtoiles,
      'nb_votes' : nbVotes,
    })
        .then((value) => print("User Updated ;)"))
        .catchError((error) => print("Error Updating User :c " + error));
  }


  Future changeURL(uid, url) async {
    return usersCollection
        .doc(uid)
        .update({
          'photoURL': url,
        })
        .then((value) => print("User Updated ;)"))
        .catchError((error) => print("Error Updating User :c " + error));
  }

  Future changeDisplayName(uid, pseudo) async {
    return usersCollection
        .doc(uid)
        .update({
          'displayName': pseudo,
        })
        .then((value) => print("User Updated ;)"))
        .catchError((error) => print("Error Updating User :c " + error));
  }

  Future changePhoneNumber(uid, number) async {
    return usersCollection
        .doc(uid)
        .update({
          'phoneNumber': number,
        })
        .then((value) => print("User Updated ;)"))
        .catchError((error) => print("Error Updating User :c " + error));
  }

  Future changeFacebook(uid, fb) async {
    return usersCollection
        .doc(uid)
        .update({
          'facebook': fb,
        })
        .then((value) => print("User Updated ;)"))
        .catchError((error) => print("Error Updating User :c " + error));
  }

  Future changeTwitter(uid, twit) async {
    return usersCollection
        .doc(uid)
        .update({
          'twitter': twit,
        })
        .then((value) => print("User Updated ;)"))
        .catchError((error) => print("Error Updating User :c " + error));
  }

  Future addUser(uid, organisateur) async {
    return usersCollection
        .doc(uid)
        .set({
          'organisateur': organisateur,
          'displayName': 'Anonymous',
          'photoURL': 'https://thispersondoesnotexist.com/image',
          'phoneNumber': '',
          'facebook': '',
          'twitter': '',
          'parcours': []
        })
        .then((value) => print("User Created ;)"))
        .catchError((error) => print("Error Creating User :c " + error));
  }

  Future createParcours(String uid, String parcoursName, String parcoursDesc) {
    return parcoursCollection.add({
      'nom': parcoursName,
      'description': parcoursDesc,
      'user_id': uid,
      'prive': true,
      'parcours':[],
    });

  }

}
