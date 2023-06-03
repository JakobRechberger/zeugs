import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';




class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State createState() => FullMap();
}
class FullMap extends State<MapScreen> with SingleTickerProviderStateMixin {
  MapboxMap? mapboxMap;
  bool isMenuExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

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

  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
  }

  Widget _show() {
    return FloatingActionButton(
    onPressed: () {
      mapboxMap?.location
          .updateSettings(LocationComponentSettings(enabled: true));
    },
    tooltip: 'Locate',
    child: const Icon(Icons.location_searching_sharp),
    );
  }

  Widget _hide() {
    return FloatingActionButton(
      child: const Icon(Icons.exit_to_app_outlined),
      onPressed: () {
        mapboxMap?.location
            .updateSettings(LocationComponentSettings(enabled: false));
      },
    );
  }
  Widget _getPermission() {
    return FloatingActionButton(
      child: const Icon(Icons.request_page_outlined),
      onPressed: () async {
        var status = await Permission.locationWhenInUse.request();
        if (status.isGranted){
          print("success");
        }
        print("Location granted : $status");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final MapWidget mapWidget = MapWidget(
        key: const ValueKey("mapWidget"),
        resourceOptions: ResourceOptions(accessToken: ""),
        onMapCreated: _onMapCreated);


    return Scaffold(
      body:
          Stack(
            children: [
              Center(
                child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: mapWidget),
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
                  padding: const EdgeInsets.only(top: 32, left: 16, right: 16, bottom: 3),
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
                          // Handle filter button press
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 16,
                right: 16,
                child: FloatingActionButton(
                  onPressed: toggleMenu,
                  child: AnimatedIcon(
                    icon: AnimatedIcons.menu_close,
                    progress: _animationController,
                  ),
                ),
              ),
              // Expanded Menu
              if (isMenuExpanded)
                Positioned(
                  bottom: 90,
                  right: 16,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 1),
                      end: Offset.zero,
                    ).animate(_animationController),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _show(),
                        const SizedBox(height: 16),
                        _hide(),
                        const SizedBox(height: 16),
                        _getPermission(),
                      ],
                    ),
                  ),
                ),
            ],
          ),
    );
  }
    /*return Scaffold(
        body: MapWidget(
          key: const ValueKey("mapWidget"),
          resourceOptions: ResourceOptions(accessToken: "sk.eyJ1IjoiamFrb2JyZWNoYmVyZ2VyIiwiYSI6ImNsaHVtYjFtdjAxOTAzbnJ3OGFqczRtNTkifQ.IbS4Q7hu_0cldmzM4Sr3Jw"),
          onMapCreated: _onMapCreated,
        ));*/
  }



