
import 'package:flutter/material.dart';
import 'package:vertiefung_zeugs/layout/components/map/renttoolcard.dart';

import '../homepage.dart';
import 'mapmarker.dart';

class OverlayScreen extends StatelessWidget {
  final MapMarker item;

  final VoidCallback onClosePressed;

  const OverlayScreen(this.item, {super.key, required this.onClosePressed});

  @override
  Widget build(BuildContext context) {
    return
      Positioned(
        bottom: 17,
        left: 17,
        right: 17,
        height: MediaQuery.of(context).size.height * 0.7,

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
                      Text('${item.distance?.toStringAsFixed(1)} km away' ?? '',),
                      IconButton(
                        onPressed: onClosePressed,
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child:
                            item.imageFile != null ?
                            Image.file(item.imageFile!,
                              fit: BoxFit.contain,)
                                :item.imagePath != null ?
                            Image.asset(
                              item.imagePath ?? '',
                              fit: BoxFit.contain,
                            )
                                : const Icon(Icons.no_photography_outlined, size: 50),
                          ),
                        ),
                      ),


                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Text(
                                  'Description:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 10),
                                Text(item.description ?? 'unknown',
                                  softWrap: true,
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,

                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Text(
                                  'Condition:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 10),
                                Text(item.condition ?? 'unknown'),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Text(
                                  'Year of Purchase:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 10),
                                Text(item.purchasedate.toString() ?? 'unknown'),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Text(
                                  'Price:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 10),
                                Text('${item.price}€/day'),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: (){
                      RentOverlayScreen(
                        item,
                        onClosePressed: () {  },
                      );
                    },
                    child: const Text('Rent this Tool'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }
}
