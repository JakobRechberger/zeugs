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
  bool displayTools = false;
  bool displayToolInfo = false;
  bool isFilterExpanded = false;
  double currentFilterDistanceValue = 2.5;
  double currentFilterPriceValue = 10;
  String searchText = '';
  int selectedIndex = 0;
  OverlayScreen? overlayScreen;
  List<MapMarker> filteredItems = [];
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
  void filterItems(String value) {
    String text = value;
    setState(() {
      searchText = value;
      filteredItems = mapMarkers.where((marker) => marker.title!.toLowerCase().contains(text.toLowerCase())).toList();
      displayTools = true;
    });
    for (int i = 0; i < filteredItems.length; i++){
      filteredItems[i].distance = calculateDistance(filteredItems[i].location);
    }
    filteredItems.sort((a, b) => a.distance!.compareTo(b.distance as num));
  }
  filterByParameters(){
    filteredItems.clear();
    setState(() {
      displayTools = true;
    });
    filteredItems = mapMarkers.where((marker) => marker.title!.toLowerCase().contains(searchText.toLowerCase()) && marker.distance! <= currentFilterDistanceValue && marker.price! <= currentFilterPriceValue).toList();
    for (int i = 0; i < filteredItems.length; i++){
      filteredItems[i].distance = calculateDistance(filteredItems[i].location);
    }
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
                urlTemplate: 'https://api.mapbox.com/styles/v1/jakobrechberger/clhumypca020801r0e3yp7i5j/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiamFrb2JyZWNoYmVyZ2VyIiwiYSI6ImNsaHFpcjM4bDI0eW4za3MxcmE1bTR0dzkifQ.BnYgVzlLIohVwazSJSFMrg',
                additionalOptions: const {
                  'accessToken':'',
                  'id': 'mapbox.mapbox-streets-v8'
                },
              ),
              CurrentLocationLayer(),
              MarkerLayer(
                markers: [
                  for (int i = 0; i < filteredItems.length; i++)
                    Marker(
                    height: 40,
                    width: 40,
                    point: filteredItems[i].location ?? LatLng(49.7899, 9.9311),
                    builder: (_) {
                      return GestureDetector(
                        onTap: () {
                          pageController.animateToPage(
                            i,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                          currentLocation = (filteredItems[i].location ??
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
                      (filteredItems[value].location ?? myLocation)!;
                      _animatedMapMove(currentLocation, 13);
                      setState(() {});
                    },
                    itemCount: filteredItems.length,
                    itemBuilder: (_, index) {
                      final item = filteredItems[index];
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
                                                isFilterExpanded = false;
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
          child:
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.only(top: 32, left: 16, right: 16, bottom: 13),
            decoration: const BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onSubmitted: (value) {
                          filterItems(value);
                        },
                        decoration: const InputDecoration(
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
                        setState(() {
                          isFilterExpanded = !isFilterExpanded; // Toggle the isMenuExpanded variable
                        });
                      }
                  ),
                ],
              ),
                Visibility(
                visible: isFilterExpanded,
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'max. Distance',
                      ),
                    ),
                    Slider(
                      value: currentFilterDistanceValue,
                      max: 5,
                      divisions: 10,
                      activeColor: Colors.black54,
                      label: '${currentFilterDistanceValue}km',
                      onChanged: (double value) {
                        setState(() {
                          currentFilterDistanceValue = value;
                        });
                        filterByParameters();
                      },
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Price',
                      ),
                    ),
                    Slider(
                      value: currentFilterPriceValue,
                      max: 30,
                      divisions: 30,
                      activeColor: Colors.black54,
                      label: '$currentFilterPriceValue€/day',
                      onChanged: (double value) {
                        setState(() {
                          currentFilterPriceValue = value;
                        });
                        filterByParameters();
                      },
                    ),
                  ],
                ),
                ),
              ],
            )
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




