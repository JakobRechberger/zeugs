import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_gl/mapbox_gl.dart';


class MapBox extends StatelessWidget {
  final LatLng latLng;
  const MapBox({Key? key, required this.latLng}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Map Overview')),
      body: Stack(
        children: [
          MapboxMap(
            initialCameraPosition: CameraPosition(
            target: latLng,
              zoom: 13,
            ),
            onMapCreated: (controller) {controller.addSymbol(const SymbolOptions(
                geometry: LatLng(37.7749, -122.4194), // Example marker position
                iconImage: 'marker-icon', // Example marker icon
                ));},
            accessToken: 'sk.eyJ1IjoiamFrb2JyZWNoYmVyZ2VyIiwiYSI6ImNsaHVtYjFtdjAxOTAzbnJ3OGFqczRtNTkifQ.IbS4Q7hu_0cldmzM4Sr3Jw',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        onPressed: () {  },
        child: const Icon(Icons.add),
      ),

    );
  }
}
void addMarker(MapboxMapController controller, LatLng latLng) async {
  var byteData = await rootBundle.load("images/poi.png");
  var markerImage = byteData.buffer.asUint8List();

  controller.addImage('marker', markerImage);

  await controller.addSymbol(
    SymbolOptions(
      iconSize: 0.3,
      iconImage: "marker",
      geometry: latLng,
      iconAnchor: "bottom",
    ),
  );
}
