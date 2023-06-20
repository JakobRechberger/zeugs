import 'package:flutter/material.dart';

import 'mapmarker.dart';

class RentOverlayScreen extends StatelessWidget {
  final MapMarker item;
  final VoidCallback onClosePressed;

  const RentOverlayScreen(this.item, {super.key, required this.onClosePressed});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 17,
      left: 17,
      right: 17,
      height: MediaQuery
          .of(context)
          .size
          .height * 0.7,

      child:
      Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: Colors.white,
        child:
        SingleChildScrollView(
          child:
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.title ?? '',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
