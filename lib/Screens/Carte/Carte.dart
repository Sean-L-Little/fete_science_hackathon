import 'package:fete_science_app/Services/Database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong/latlong.dart';

import 'PinCarte.dart';

class Carte extends StatefulWidget {
  Carte({Key key, this.title, this.user}) : super(key: key);
  final User user;
  final String title;
  @override
  _CarteState createState() => _CarteState();
}

class _CarteState extends State<Carte> {
  LatLng _center = LatLng(48.856614, 2.3522219);

  final PopupController _popupController = PopupController();
  final Database _dbService = Database();

  List<Marker> markers = new List<Marker>();

  @override
  void initState(){
    markers.add(PinMarker(
      pin: Pin(location: "TEST",
          name: "name",
          desc: "desc",
          lat: 42,
          long: 2),
    ));
    //initMarker();

    super.initState();
    /**
     * setState((){});
        setState(() {
        markers = markers;
        });
     */

  }
  Widget loadMap() {
    return StreamBuilder(
      stream: _dbService.getEvenementsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator()
          );
        }
        else if(snapshot.data==null){
          return Text('Pas d\'évènements disponible');
        }else if(snapshot.data.docs.length>0){
          for(int i =0; i<snapshot.data.docs.length;i++) {
            if (snapshot.data.docs[i]["fields"] != null &&
                snapshot.data.docs[i]["geometry"] != null) {
                markers.add(new PinMarker(
                  pin: Pin(
                      location: snapshot.data.docs[i]["fields"]["ville"] != null ? snapshot.data.docs[i]["fields"]["ville"] : "Pas de vill",
                      name: snapshot.data.docs[i]["fields"]["titre_fr"] != null ? snapshot.data.docs[i]["fields"]["titre_fr"] : "Pas de titre",
                      desc: snapshot.data.docs[i]["fields"]["description_fr"] != null ? snapshot.data.docs[i]["fields"]["description_fr"] : "Pas de description",
                      lat: snapshot.data.docs[i]["geometry"]["coordinates"][1] != null ? snapshot.data.docs[i]["geometry"]["coordinates"][1] : 53.81667,
                      long: snapshot.data.docs[i]["geometry"]["coordinates"][0] != null ? snapshot.data.docs[i]["geometry"]["coordinates"][0]: -3.05,
                  ),
                ));
            }
          }
         return new FlutterMap(
            options: new MapOptions(
              center: _center,
              zoom: 5.0,
              plugins: [
                MarkerClusterPlugin(),
              ],
              onTap: (_) =>
                  _popupController.hidePopup(), // Hide popup when the map is tapped.
            ),
            layers: [
              new TileLayerOptions(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c']),
              MarkerClusterLayerOptions(
                maxClusterRadius: 120,
                disableClusteringAtZoom: 6,
                size: Size(40, 40),
                anchor: AnchorPos.align(AnchorAlign.center),
                fitBoundsOptions: FitBoundsOptions(
                  padding: EdgeInsets.all(50),
                ),
                markers: markers,
                polygonOptions: PolygonOptions(
                    borderColor: Colors.blueAccent,
                    color: Colors.black12,
                    borderStrokeWidth: 3),
                popupOptions: PopupOptions(
                  popupSnap: PopupSnap.top,
                  popupController: _popupController,
                  popupBuilder: (_, Marker marker) {
                    if (marker is PinMarker) {
                      return PinMarkerPopup(pin: marker.pin);
                    }
                    return Card(child: const Text('Aucune information disponible'));
                  },
                ),
                builder: (context, markers) {
                  return FloatingActionButton(
                    child: Text(markers.length.toString()),
                    onPressed: null,
                  );
                },
              ),
            ],
          );
        }
        return Text('arretedechialer');
      }
    );
  }

  Widget build(BuildContext context) {
    return loadMap();
  }
}
