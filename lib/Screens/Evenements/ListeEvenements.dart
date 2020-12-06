import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../Services/Database.dart';
import 'DetailsEvenement.dart';


class ListeEvenement extends StatefulWidget {
  ListeEvenement({Key key, this.title, this.user}) : super(key: key);
  final User user;
  final String title;
  @override
  _ListeEvenementState createState() => _ListeEvenementState();
}

class _ListeEvenementState extends State<ListeEvenement> {
  final Database dbService = Database();
  final searchControl = TextEditingController();

  
  @override
  void initState() {
    searchControl.addListener(_changeControl);
    super.initState();
  }

  _changeControl(){
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: searchControl,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search_outlined),
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
              stream: dbService.getEvenementsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator()
                  );
                }
                else if(snapshot.data==null){
                  return Text('Pas d\'évènements disponible');
                }else if(snapshot.data.docs.length>0){
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, i) {
                      if((snapshot.data.docs[i]['fields']['nom_du_lieu'] != null &&
                          snapshot.data.docs[i]['fields']['nom_du_lieu'].toString().toLowerCase()
                              .contains(searchControl.text.trim().toLowerCase()))
                      || (snapshot.data.docs[i]['fields']['thematiques'] != null &&
                              snapshot.data.docs[i]['fields']['thematiques'].toString().toLowerCase()
                                  .contains(searchControl.text.trim().toLowerCase()))
                      || (snapshot.data.docs[i]['fields']['ville'] != null &&
                              snapshot.data.docs[i]['fields']['ville'].toString().toLowerCase()
                                  .contains(searchControl.text.trim().toLowerCase()))
                      || (snapshot.data.docs[i]['fields']['titre_fr'] != null &&
                              snapshot.data.docs[i]['fields']['titre_fr'].toString().toLowerCase()
                                  .contains(searchControl.text.trim().toLowerCase()))
                      || (snapshot.data.docs[i]['fields']['mots_cles_fr'] != null &&
                              snapshot.data.docs[i]['fields']['mots_cles_fr'].toString().toLowerCase()
                                  .contains(searchControl.text.trim().toLowerCase()))
                      || (snapshot.data.docs[i]['fields']['resume_dates_fr'] != null &&
                              snapshot.data.docs[i]['fields']['resume_dates_fr'].toString().toLowerCase()
                                  .contains(searchControl.text.trim().toLowerCase()))) {
                        return Card(

                            color: Theme.of(context).accentColor,
                            child: ListTile(
                              onTap: (){
                                Navigator.push(context,
                                  MaterialPageRoute(builder: (context) =>
                                      DetailsEvenement(user: widget.user,
                                          id: snapshot.data.docs[i].id,
                                          data: snapshot.data.docs[i].data())),
                                );
                              },
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundImage:
                                snapshot.data.docs[i].data()["fields"]["apercu"] !=
                                    null ? NetworkImage(snapshot.data.docs[i]
                                    .data()["fields"]["apercu"]) : NetworkImage(
                                    "https://blog.hubspot.com/hubfs/Shrug-Emoji.jpg"),
                              ),
                              title: snapshot.data.docs[i]
                                  .data()["fields"]["titre_fr"] != null ?
                              Column(
                                children: [
                                  Text(
                                    snapshot.data.docs[i].data()["fields"]["titre_fr"],
                                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                                    ),
                                  SizedBox(height:10.0),
                                  Text(
                                    snapshot.data.docs[i].data()['fields']['resume_horaires_fr'] != null ?
                                    snapshot.data.docs[i].data()['fields']['resume_horaires_fr']
                                        : '',
                                    style: TextStyle(fontSize: 16.0,fontStyle: FontStyle.italic),

                                    textAlign: TextAlign.left,
                                  ),
                                  SizedBox(height:10.0),
                                ],
                              )
                                  : Text('Pas de titre'),
                              subtitle: snapshot.data.docs[i]
                                  .data()["fields"]["description_fr"] != null ?
                              Text(
                                snapshot.data.docs[i]
                                    .data()["fields"]["description_fr"],
                                style: TextStyle(fontSize: 14.0),
                                textAlign: TextAlign.justify,
                              )
                                  : Text('Pas de description'),
                              // trailing: RaisedButton(
                              //     color: Colors.lightGreen[600],
                              //     child: Text(
                              //       'Voir Plus',
                              //       style: TextStyle(color: Colors.white),),
                              //     onPressed: () {
                              //       Navigator.push(context,
                              //         MaterialPageRoute(builder: (context) =>
                              //             DetailsEvenement(user: widget.user,
                              //                 id: snapshot.data.docs[i].id,
                              //                 data: snapshot.data.docs[i].data())),
                              //       );
                              //     }),
                            )
                        );
                      }else{
                        return SizedBox(height:0.0, width: 0.0,);
                      }
                  });
                }else{
                  return(Text('Un problème est survenu'));
                }
              }
          ),
        ),
      ],
    );
  }
}