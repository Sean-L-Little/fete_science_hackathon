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
    return  evenementsGrosseCollection.snapshots();
  }
}