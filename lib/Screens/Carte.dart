import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fete_science_app/Services/Auth.dart';
import 'package:fete_science_app/Services/Database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong/latlong.dart';

import 'PinCarte.dart';

class Carte extends StatefulWidget {
  @override
  _CarteState createState() => _CarteState();
}

class _CarteState extends State<Carte> {
  LatLng _center = LatLng(48.856614, 2.3522219);

  final PopupController _popupController = PopupController();
  final Database _dbService = Database();

  List<Marker> markers = new List<Marker>();

  void initMarker() async{
    _dbService.getEvenementsStream();
    FirebaseFirestore.instance
        .collection('/Evenements')
        .get()
        .then((QuerySnapshot querySnapshot) => {
      querySnapshot.docs.forEach((doc) {
        try{
          if(doc["fields"]!=null && doc["geometry"]!=null){
            String newLocation = doc["fields.ville"] != null ? doc["fields.ville"] : " ";
            String newName = doc["fields.titre_fr"] != null ? doc["fields.titre_fr"] : " ";
            String newDesc = doc["fields.description_fr"] != null ? doc["fields.description_fr"] : " ";
            double newLat = doc["geometry.coordinates"][1] != null ? doc["geometry.coordinates"][1] : 0;
            double newLong = doc["geometry.coordinates"][0] != null ? doc["geometry.coordinates"][0] : 0;
          setState(() { // PAS SUR
            markers.add(PinMarker(
              pin: Pin(location: newLocation,
                  name: newName,
                  desc: newDesc,
                  lat: newLat,
                  long: newLong),
            ));
            print(markers.length.toString());
          });


          }
        }catch(error){
        }
      })

    });
  }


  @override
  void initState() {
    markers.add(PinMarker(
      pin: Pin(location: "TEST",
          name: "name",
          desc: "desc",
          lat: 42,
          long: 2),
    ));
    initMarker();

    super.initState();
    /**
     * setState((){});
        setState(() {
        markers = markers;
        });
     */

  }


  Widget build(BuildContext context) {
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
}
