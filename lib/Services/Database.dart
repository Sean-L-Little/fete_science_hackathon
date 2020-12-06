import 'package:cloud_firestore/cloud_firestore.dart';

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

  Future changeRating(uid, nbEtoiles,nbVotes) async {
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

  Future deleteParcours(String id) {
    return parcoursCollection
        .doc(id)
        .delete()
        .then((value) => print('Parcours deleted'))
        .catchError((error) => print('Failed to delete parcours: $error'));
  }
  
  Future addEventToParcours(String eventId, String parcoursId){
    List<dynamic> list = new List<dynamic>();
    list.add(eventId);
    return parcoursCollection
        .doc(parcoursId)
        .update({
        'parcours' : FieldValue.arrayUnion(list),
    });
    
  }

  Future updatePlaces(String id, String placesRestantes) {
    return evenementsGrosseCollection
        .doc(id)
        .update({
            'places_restantes': placesRestantes,
        });
  }

  Future changeParcoursPrive(String id, bool prive) {
    return parcoursCollection
        .doc(id)
        .update({
      'prive': prive,
    });
  }

}
