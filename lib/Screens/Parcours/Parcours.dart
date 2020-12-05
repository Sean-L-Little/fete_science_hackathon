import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fete_science_app/Services/Database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Evenements/DetailsEvenement.dart';
import '../MenuDrawer.dart';

class Parcours extends StatefulWidget {
  Parcours({Key key, this.id, this.data, this.title, this.user}) : super(key: key);
  final User user;
  final String title;
  final Map<String, dynamic> data;
  final String id;




  @override
  _ParcoursState createState() => _ParcoursState();
}


class _ParcoursState extends State<Parcours> {

  List<Card> cardList = new List<Card>();
  Database _dbService= Database();
  List<dynamic> _eventIds=[];
  Stream dataStream;
  // _events = [];




  getData() async {

    _eventIds=widget.data["parcours"];
    dataStream = _dbService.evenementsGrosseCollection
        .where('fields.identifiant', whereIn: _eventIds != [] ? _eventIds: ["0"])
        .snapshots();

  }


  initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   //eventIds = _dbService.getEvenementsForParcours(widget.id).data().values != null ? _dbService.getEvenementsForParcours(widget.id).data().values: 5;
    print("toot"+ _eventIds.length.toString());
    return Scaffold(
        backgroundColor: Colors.lightGreen[100],
        //drawer: MenuDrawer(user: widget.user),
        appBar: AppBar(
          backgroundColor: Colors.lightGreen[400],
          title: Text('Parcours: ' + widget.data["nom"]),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              listEvents(),
              suppressionParcours(context)
            ],
          ),
        )
    );
  }

  Widget listEvents(){
    return StreamBuilder<QuerySnapshot>(
        stream: dataStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            //print("Data Length: " + snapshot.data.docs.length.toString());
            return Text('Chargement des dqssq ...');
          }
          else if(snapshot.data==null){
            return Text('Pas d\'évènements disponible');
          }else if(snapshot.data.docs.length>0){
            return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, i) {
                  return Card(
                      color: Colors.lightGreen[100],
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage:
                          snapshot.data.docs[i].data()["fields"]["apercu"] != null ? NetworkImage(snapshot.data.docs[i].data()["fields"]["apercu"]) : NetworkImage("https://blog.hubspot.com/hubfs/Shrug-Emoji.jpg"),
                        ),
                        title: snapshot.data.docs[i].data()["fields"]["titre_fr"] != null ?
                        Text(snapshot.data.docs[i].data()["fields"]["titre_fr"])
                            :Text('Pas de titre'),
                        subtitle: snapshot.data.docs[i].data()["fields"]["description_fr"] != null ?
                        Text(snapshot.data.docs[i].data()["fields"]["description_fr"])
                            :Text('Pas de description'),
                        trailing: RaisedButton(
                            color: Colors.lightGreen[600],
                            child:Text(
                              'Voir Plus',
                              style: TextStyle(color: Colors.white),), onPressed:() {
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context) => DetailsEvenement(id: snapshot.data.docs[i].id, data: snapshot.data.docs[i].data())),
                          );
                        }),
                      )
                  );
                });
          }else{
            return(Text('Un problème est survenu'));
          }
        }
    );

  }


  Widget suppressionParcours(context) {
    return Container(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.red,
          ),
          onPressed: () {
            _dbService.deleteParcours(widget.id);
            Navigator.pop(context);
          },
          child: Text('Supprimer le parcours'),
        )
    );
  }

//   Widget carousel(){
//     int _currentIndex=0;
//
//     List<T> map<T>(List list, Function handler) {
//       List<T> result = [];
//       for (var i = 0; i < list.length; i++) {
//         result.add(handler(i, list[i]));
//       }
//       return result;
//     }
//
//     //TODO: Revoir comment implementer ça
//     return CarouselSlider(
//         options: CarouselOptions(
//           height: 200.0,
//           autoPlay: false,
//           autoPlayInterval: Duration(seconds: 3),
//           autoPlayAnimationDuration: Duration(milliseconds: 800),
//           autoPlayCurve: Curves.fastOutSlowIn,
//           pauseAutoPlayOnTouch: true,
//           aspectRatio: 2.0,
//           onPageChanged: (index, reason) {
//             setState(() {
//               _currentIndex = index;
//             });
//           },
//         ),
//       items: cardList.map((card){
//         return StreamBuilder(
//             stream: dataStream,
//             builder:(BuildContext context,snapshot){
//               return Container(
//                 height: MediaQuery.of(context).size.height*0.30,
//                 width: MediaQuery.of(context).size.width,
//                 child: Card(
//                   color: Colors.blueAccent,
//                   child: Container(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         Text(
//                             "Dddata",
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 22.0,
//                                 fontWeight: FontWeight.bold
//                             )
//                         ),
//                         Text(
//                             "Data",
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 17.0,
//                                 fontWeight: FontWeight.w600
//                             )
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             }
//         );
//       }).toList(),
//     );
//   }
//
// }
// class CarouselCard extends StatelessWidget {
//   const CarouselCard({Key key, this.data}) : super(key: key);
//   final data;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Text(
//               "Dddata",
//               style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 22.0,
//                   fontWeight: FontWeight.bold
//               )
//           ),
//           Text(
//               "Data",
//               style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 17.0,
//                   fontWeight: FontWeight.w600
//               )
//           ),
//         ],
//       ),
//     );
//   }
}