import 'package:fete_science_app/Services/Auth.dart';
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

  List<Marker> markers;
  int pointIndex;
  List points = [
    LatLng(51.5, -0.09),
    LatLng(49.8566, 3.3522),
  ];

  @override
  void initState() {
    pointIndex = 0;
    markers = [
      Marker(
        anchorPos: AnchorPos.align(AnchorAlign.center),
        height: 30,
        width: 30,
        point: points[pointIndex],
        builder: (ctx) => Icon(Icons.pin_drop),
      ),
      Marker(
        anchorPos: AnchorPos.align(AnchorAlign.center),
        height: 30,
        width: 30,
        point: LatLng(53.3498, -6.2603),
        builder: (ctx) => Icon(Icons.pin_drop),
      ),
      Marker(
        anchorPos: AnchorPos.align(AnchorAlign.center),
        height: 30,
        width: 30,
        point: LatLng(53.3488, -6.2613),
        builder: (ctx) => Icon(Icons.pin_drop),
      ),
      Marker(
        anchorPos: AnchorPos.align(AnchorAlign.center),
        height: 30,
        width: 30,
        point: LatLng(53.3488, -6.2613),
        builder: (ctx) => Icon(Icons.pin_drop),
      ),
      Marker(
        anchorPos: AnchorPos.align(AnchorAlign.center),
        height: 30,
        width: 30,
        point: LatLng(48.8566, 2.3522),
        builder: (ctx) => Icon(Icons.pin_drop),
      ),
      Marker(
        anchorPos: AnchorPos.align(AnchorAlign.center),
        height: 30,
        width: 30,
        point: LatLng(49.8566, 3.3522),
        builder: (ctx) => Icon(Icons.pin_drop),
      ),
      PinMarker(
        pin: Pin(
          location: 'Paris',
          name: 'Eiffel Tower',
          desc:
              ' Monument de paris  de paris  de paris  de paris  de paris  de paris  de paris  de paris  de paris  de paris  de paris  de paris  de paris  de paris  de paris  de paris  ezaez zaeze azezae zaeaz eazezae aeae aze aea ze',
          lat: 48.857661,
          long: 2.295135,
        ),
      ),
    ];

    super.initState();
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

