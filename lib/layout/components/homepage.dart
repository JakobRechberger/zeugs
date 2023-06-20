import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';

import 'package:vertiefung_zeugs/layout/components/offerscreen.dart';

import 'package:flutter/material.dart';
import 'package:vertiefung_zeugs/layout/components/map/mapscreen.dart';
import 'package:google_fonts/google_fonts.dart';


class AppAction {
  final Color color;
  final String label;
  final Color labelColor;
  final IconData iconData;
  final Color iconColor;
  final void Function(BuildContext) callback;

  AppAction({
    this.color = Colors.blueGrey,
    required this.label,
    this.labelColor = Colors.white,
    required this.iconData,
    this.iconColor = Colors.white,
    required this.callback,
  });
}

final List<AppAction> actions = [
  AppAction(
    label: 'Rent',
    iconData: Icons.location_on_outlined,
    callback: (context) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => const RentScreen()));
    },
  ),
  AppAction(
    label: 'Offer',
    iconData: Icons.add_circle_outline_outlined,
    callback: (context) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => const OfferScreen()));
    },
  ),
  AppAction(
    label: 'Help Center',
    iconData: Icons.help_center_outlined,
    callback: (context) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => const HelpScreen()));
    },
  ),
  AppAction(
    label: 'Favourites',
    iconData: Icons.favorite_border_outlined,
    callback: (context) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => const FavouritesScreen()));
    },
  ),
];

class HomePage extends StatelessWidget {
  const HomePage( {super.key});
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final displayName = currentUser?.displayName ?? currentUser?.email ;
    return AppLayout(
      pageTitle: 'zeugs',
      key: const Key('Home Page'),
        isMainPage: true,
      child:Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/layout/components/media/background.jpg'), // Replace with the path to your background image
              fit: BoxFit.cover,
            ),
          ),
          padding: const EdgeInsets.all(30.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GridView.count(
                  crossAxisSpacing: 15.0,
                  mainAxisSpacing: 15.0,
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  children: actions.asMap().entries.map((entry) {
                    final int index = entry.key;
                    final AppAction action = entry.value;
                    return ActionButton(action: action, key: Key('Grid-$index'));
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: -20,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hey $displayName!'
                    , style: const TextStyle(color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Find, borrow and share in Germany\'s largest tool box!', style: TextStyle(color: Colors.white),
                  ),
              ],
              )
          ),
        ),
      ],
      )


    );
  }
}

class AppLayout extends StatelessWidget {
  final String pageTitle;
  final Widget child;
  final bool isMainPage;

  const AppLayout({required Key key, required this.pageTitle, required this.child, required this.isMainPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: Colors.orange,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if(isMainPage)
                    const SizedBox(width: 50),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 3.0), // Adjust the border color and width as needed
                    ),
                    child: Text(
                      pageTitle,
                      style: GoogleFonts.nunito(
                        textStyle: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<ProfileScreen>(
                    builder: (context) => ProfileScreen(
                      appBar: AppBar(
                        title: const Text('User Profile'),
                      ),
                      actions: [
                        SignedOutAction((context) {
                          Navigator.of(context).pop();
                        })
                      ],
                      children: [
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.all(2),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Image.asset('lib/layout/components/media/ic_launcher.png'),
                          ),
                        ),
                      ],
                    ),
                    ),
                );
              },
            ),
          ],
          ),
        iconTheme: const IconThemeData(
          color: Colors.white, // Set the color of the back arrow button
        ),
        ),
      body: child,
    );
  }
}

class ActionButton extends StatelessWidget {
  final AppAction action;

  const ActionButton({
    required Key key,
    required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => action.callback?.call(context),
      style: OutlinedButton.styleFrom(
        backgroundColor: action.color.withOpacity(0.8),
        padding: const EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Set borderRadius to 0 for squared shape
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconTheme(
            data: IconThemeData(
              color: action.iconColor,
              size: 70, // Increase the icon size
            ),
            child: Icon(action.iconData),
          ),
          const SizedBox(height: 8), // Adjust the spacing between icon and text
          Text(
            action.label,
            style: TextStyle(
              color: action.labelColor,
              fontSize: 18, // Increase the font size
              fontWeight: FontWeight.bold, // Optional: Add fontWeight
            ),
          ),
        ],
      ),
    );
  }
}

class RentScreen extends StatelessWidget {
  const RentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppLayout(
      pageTitle: ('zeugs'),
      key: Key('Favourites Page'),
      isMainPage: false,
      child: MapScreen(),
    );
  }
}

class OfferScreen extends StatelessWidget {
  const OfferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppLayout(
      pageTitle: 'zeugs',
      key: Key('OfferPage'),
      isMainPage: false,
      child: AddScreen(),
    );
  }
}

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppLayout(
      pageTitle: 'zeugs',
      key: Key('Help Center'),
        isMainPage: false,
      child: Center(
      child:
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Help  Center', style: TextStyle(color: Colors.orangeAccent, fontSize:30)),
          Text('This site is currently under construction. Come back later.' ,textAlign: TextAlign.center ,style: TextStyle( fontSize:20)),
          Icon(Icons.construction_outlined, ),
        ],
      )
      )
    );
  }
}

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppLayout(
      pageTitle: 'zeugs',
      key: Key('Favourites Page'),
      isMainPage: false,
      child: Center(
        child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Favourites', style: TextStyle(color: Colors.redAccent, fontSize:30)),
            Text('This site is currently under construction. Come back later.' ,textAlign: TextAlign.center ,style: TextStyle( fontSize:20)),
            Icon(Icons.construction_outlined, ),
          ],
        )
      ),
    );
  }
}


