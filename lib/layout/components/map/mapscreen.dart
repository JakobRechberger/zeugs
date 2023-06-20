import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:vertiefung_zeugs/layout/components/map/renttoolcard.dart';
import 'package:vertiefung_zeugs/layout/components/map/toolinfo.dart';
import 'mapmarker.dart';
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State createState() => FullMap();
}
class FullMap extends State<MapScreen> with TickerProviderStateMixin {
  bool isMenuExpanded = false;
  bool displayTools = true;
  bool displayToolInfo = false;
  int selectedIndex = 0;
  OverlayScreen? overlayScreen;
  List itemsOnMap = [];
  var distance = const Distance();
  LatLng? myLocation = LatLng(49.7775, 9.9631);
  var currentLocation = LatLng(49.7775, 9.9631);
  final mapController = MapController();
  final pageController = PageController();
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _animation;


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void toggleMenu() {
    setState(() {
      isMenuExpanded = !isMenuExpanded;
      if (isMenuExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }
  double calculateDistance(LatLng? itemLocation){
    final meter =
    distance(myLocation!, itemLocation!);
    final km = double.parse((meter/1000).toStringAsFixed(2));
    return km;
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }
  Widget _show() {
    return FloatingActionButton(
      onPressed: () async {
        Position? position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
        myLocation = LatLng(position.latitude, position.longitude);
        print("my location is  ${position.latitude}  ${position.longitude}      ");
        for (int i = 0; i < mapMarkers.length; i++){
          mapMarkers[i].distance = calculateDistance(mapMarkers[i].location);
        }
        _animatedMapMove(myLocation!, 13);

      },
      tooltip: 'Locate',
      child: const Icon(Icons.my_location_outlined),
    );
  }

  Widget _getPermission() {
    return FloatingActionButton(
      child: const Icon(Icons.settings),
      onPressed: () async {
        var status = await Permission.locationWhenInUse.request();
        if (status.isGranted){
          print("success");
        }
        print("Location granted : $status");
      },
    );
  }
  void onClosePressed() {
    setState(() {
      displayToolInfo = false;
      overlayScreen = null;
    });
  }
  void _animatedMapMove(LatLng destLocation, double destZoom) {
    final latTween = Tween<double>(
        begin: mapController.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: mapController.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);
    var controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    Animation<double> animation =
    CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
      );
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
          FlutterMap(
            mapController: mapController,
            options:
            MapOptions(
              minZoom: 5,
              maxZoom: 18,
              zoom: 8,
              center: currentLocation,
              onMapReady: () {
                mapController.mapEventStream.listen((evt) {});
              },
              ),
            children: [
              TileLayer(
                urlTemplate: '',
                additionalOptions: const {
                  'accessToken':'',
                  'id': 'mapbox.mapbox-streets-v8'
                },
              ),
              CurrentLocationLayer(),
              MarkerLayer(
                markers: [
                  for (int i = 0; i < mapMarkers.length; i++)
                    Marker(
                    height: 40,
                    width: 40,
                    point: mapMarkers[i].location ?? LatLng(49.7899, 9.9311),
                    builder: (_) {
                      return GestureDetector(
                        onTap: () {
                          pageController.animateToPage(
                            i,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                          currentLocation = (mapMarkers[i].location ??
                              myLocation)!;
                          selectedIndex = i;
                          setState(() {});
                        },
                          child: AnimatedScale(
                          duration: const Duration(milliseconds: 500),
                            scale: selectedIndex == i ? 1 : 0.7,
                            child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 500),
                            opacity: selectedIndex == i ? 1 : 0.5,
                            child:
                             const LocationPin(),
                      )
                          )
                      );
                    }),
                ],
              ),

            ],

          ),
        Stack(
          children: [
            if (displayToolInfo && overlayScreen != null)...[
              overlayScreen!,
            ]
            else...[
              if (displayTools)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 2,
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: PageView.builder(
                    controller: pageController,
                    onPageChanged: (value) {
                      selectedIndex = value;
                      currentLocation =
                      (mapMarkers[value].location ?? myLocation)!;
                      _animatedMapMove(currentLocation, 13);
                      setState(() {});
                    },
                    itemCount: mapMarkers.length,
                    itemBuilder: (_, index) {
                      final item = mapMarkers[index];
                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: Colors.white,
                          child: Row(
                            children: [
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [

                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 20),
                                          Text(
                                            item.title ?? '',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            '${item.distance?.toStringAsFixed(1)} km entfernt' ?? '',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                displayToolInfo = !displayToolInfo;
                                                displayTools = !displayTools;
                                              });

                                              overlayScreen = OverlayScreen(
                                                item,
                                                onClosePressed: () {
                                                  setState(() {
                                                    displayToolInfo = false;
                                                    displayTools = true;
                                                    overlayScreen = null;
                                                  });
                                                },
                                              );
                                            },
                                            child: const Text('Zum Werkzeug >',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.orangeAccent,
                                              ),
                                            ),

                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child:
                                    item.imageFile != null ?
                                    Image.file(item.imageFile!,
                                      fit: BoxFit.cover,)
                                        :item.imagePath != null ?
                                    Image.asset(
                                      item.imagePath ?? '',
                                      fit: BoxFit.cover,
                                    )
                                        : const Icon(Icons.no_photography_outlined, size: 50),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],


          ],
        ),

        if (isMenuExpanded)
          Positioned.fill(
            child: GestureDetector(
              onTap: toggleMenu,
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.only(top: 32, left: 16, right: 16, bottom: 13),
            decoration: const BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Search',
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {
                    String text = _searchController.text;
                    for(int i = 0; i < mapMarkers.length; i++){
                      if(mapMarkers[i].title!.contains(text)){
                        itemsOnMap.add(mapMarkers[i]);
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        if(!displayToolInfo)
        Positioned(
          bottom: displayTools ? MediaQuery.of(context).size.height * 0.25 : 15,
          right: 17,
          child:
          FloatingActionButton(
            onPressed: toggleMenu,
            child: AnimatedIcon(
              icon: AnimatedIcons.menu_close,
              progress: _animationController,
            ),
          ),
        ),
        if (isMenuExpanded && !displayToolInfo)
          Positioned(
            bottom: displayTools ? MediaQuery.of(context).size.height * 0.35 : 90,
            right: 17,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(_animationController),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(height: 16),
                  _show(),
                  const SizedBox(height: 16),
                  _getPermission(),
                ],
              ),
            ),
          ),
      ],

    );
  }
}
class LocationPin extends StatelessWidget {
  const LocationPin({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 40,
      height: 40,
        child: Icon(
        Icons.location_pin,
        color: Colors.orangeAccent,
        size: 40,
        )
    );
  }
}




