

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
    MapMarker(
        imagePath: 'lib/layout/components/media/Bohrmaschine.jpg',
        title: 'Bohrmaschine',
        location: LatLng(49.7875, 9.9300),
        distance: 0.0,
        description: 'Bosch Drill for home improvement',
        condition: 'Used',
        price: 8.0,
        purchasedate: 2021
    ),
    MapMarker(
        imagePath: 'lib/layout/components/media/Hammer.jpg',
        title: 'Hammer',
        location: LatLng(49.7892, 9.9333),
        distance: 0.0,
        description: 'Advanced Hammer for professional use',
        condition: 'Good',
        price: 3.0,
        purchasedate: 2020
    ),
    MapMarker(
        imagePath: 'lib/layout/components/media/Säge.jpg',
        title: 'Säge',
        location: LatLng(49.7856, 9.9326),
        distance: 0.0,
        description: 'Premium Saw for precise woodworking',
        condition: 'Like New',
        price: 6.0,
        purchasedate: 2018
    ),
    MapMarker(
        imagePath: 'lib/layout/components/media/Bohrmaschine.jpg',
        title: 'Bohrmaschine',
        location: LatLng(49.7909, 9.9391),
        distance: 0.0,
        description: 'Compact Bosch Drill for small projects',
        condition: 'Heavily Used',
        price: 4.0,
        purchasedate: 2010
    ),
    MapMarker(
        imagePath: 'lib/layout/components/media/Bohrmaschine.jpg',
        title: 'Bohrmaschine',
        location: LatLng(49.7885, 9.9456),
        distance: 0.0,
        description: 'Bosch Drill with high torque',
        condition: 'New',
        price: 9.0,
        purchasedate: 2022
    ),
    MapMarker(
        imagePath: 'lib/layout/components/media/Hammer.jpg',
        title: 'Hammer',
        location: LatLng(49.7935, 9.9321),
        distance: 0.0,
        description: 'Lightweight Hammer for easy usage',
        condition: 'New',
        price: 3.0,
        purchasedate: 2017
    ),
    MapMarker(
        imagePath: 'lib/layout/components/media/Säge.jpg',
        title: 'Säge',
        location: LatLng(49.7846, 9.9476),
        distance: 0.0,
        description: 'Compact Saw for small woodworking projects',
        condition: 'Used',
        price: 5.0,
        purchasedate: 2021
    ),
    MapMarker(
        imagePath: 'lib/layout/components/media/Bohrmaschine.jpg',
        title: 'Bohrmaschine',
        location: LatLng(49.7929, 9.9311),
        distance: 0.0,
        description: 'Bosch Drill with multiple speed options',
        condition: 'Heavily Used',
        price: 6.0,
        purchasedate: 2008
    ),
    MapMarker(
        imagePath: 'lib/layout/components/media/Bohrmaschine.jpg',
        title: 'Bohrmaschine',
        location: LatLng(49.7905, 9.9486),
        distance: 0.0,
        description: 'Bosch Drill with adjustable grip',
        condition: 'New',
        price: 11.0,
        purchasedate: 2023
    ),
    MapMarker(
        imagePath: 'lib/layout/components/media/Hammer.jpg',
        title: 'Hammer',
        location: LatLng(49.7975, 9.9381),
        distance: 0.0,
        description: 'Ergonomic Hammer for efficient use',
        condition: 'Good',
        price: 4.0,
        purchasedate: 2019
    ),

  ];

