import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class Pin {
  static const double size = 25;

  Pin({this.location, this.name, this.desc, this.lat, this.long});

  final String location;
  final String name;
  final String desc;
  final double lat;
  final double long;
}

class PinMarker extends Marker {
  PinMarker({@required this.pin})
      : super(
    anchorPos: AnchorPos.align(AnchorAlign.top),
    height: Pin.size,
    width: Pin.size,
    point: LatLng(pin.lat, pin.long),
    builder: (BuildContext ctx) => Icon(Icons.location_on_outlined),
  );

  final Pin pin;
}

class PinMarkerPopup extends StatelessWidget {
  const PinMarkerPopup({Key key, this.pin}) : super(key: key);
  final Pin pin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
            Text(
              pin.location,
              overflow: TextOverflow.fade,
              softWrap: false,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12.0,
              ),
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
            Text(
              pin.name,
              overflow: TextOverflow.fade,
              softWrap: false,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14.0,
              ),
            ),
            Text(
              pin.desc,
              style: const TextStyle(fontSize: 12.0),
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
          ],
        ),
      ),
    );
  }
}
