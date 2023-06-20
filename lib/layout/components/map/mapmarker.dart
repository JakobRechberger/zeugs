

import 'dart:io';

import 'package:latlong2/latlong.dart';

class MapMarker {
  final String? imagePath;
  final File? imageFile;
  final String? title;
  late double? distance;
  final LatLng? location;
  final String? description;
  final double? price;
  final String? condition;
  final int? purchasedate;

  MapMarker({
    this.imagePath,
    this.imageFile,
    required this.title,
    required this.location,
    required this.distance,
    this.description,
    this.price,
    this.condition,
    this.purchasedate,
  });
}
  final mapMarkers = [
    MapMarker(
        imagePath: 'lib/layout/components/media/Hammer.jpg',
        title: 'Hammer',
        location: LatLng(49.7945, 9.9331),
      distance: 0.0,
      description: 'basic Hammer',
      condition: 'New',
        price: 3.5,
      purchasedate: 2014
        ),
    MapMarker(
        imagePath: 'lib/layout/components/media/Hammer.jpg',
        title: 'Hammer',
        location: LatLng(49.7985, 9.9382),
      distance: 0.0,
        description: 'basic Hammer',
        condition: 'Good',
        price: 2.0,
        purchasedate: 2019
        ),
    MapMarker(
        imagePath: 'lib/layout/components/media/Säge.jpg',
        title: 'Säge',
        location: LatLng(49.7836, 9.9476),
      distance: 0.0,
        description: 'basic Saw for woodworking',
        condition: 'Used',
        price: 3.5,
        purchasedate: 2022
        ),
    MapMarker(
        imagePath: 'lib/layout/components/media/Bohrmaschine.jpg',
        title: 'Bohrmaschine',
        location: LatLng(49.7899, 9.9311),
      distance: 0.0,
        description: 'Bosch Drill for maintenance tasks',
        condition: 'Heavily Used',
        price: 5.0,
        purchasedate: 2009
        ),
    MapMarker(
      imagePath: 'lib/layout/components/media/Bohrmaschine.jpg',
      title: 'Bohrmaschine',
      location: LatLng(49.7895, 9.9496),
      distance: 0.0,
        description: 'Bosch Drill for maintenance tasks',
        condition: 'New',
        price: 10.0,
        purchasedate: 2023
    ),
  ];

