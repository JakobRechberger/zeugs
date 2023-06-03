import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:vertiefung_zeugs/layout/components/map.dart';

import 'package:flutter/material.dart';


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
  AppAction(
    color: Colors.transparent,
    label: 'Favourites',
    iconData: Icons.new_releases,
    callback: (context) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => const FavouritesScreen()));
    },
  ),
];

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      pageTitle: 'zeugs',
      key: const Key('Home Page'),
      child: Container(
       decoration: const BoxDecoration(
          image: DecorationImage(
          image: AssetImage('lib/layout/components/media/background.jpg'), // Replace with the path to your background image
          fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: GridView.count(
            crossAxisSpacing: 15.0,
            mainAxisSpacing: 15.0,
            crossAxisCount: 2,
            children:
            actions.map((action) => ActionButton(action: action, key: const Key('Grid'),)).toList(),
          ),
        ),
      ),
    );
  }
}

class AppLayout extends StatelessWidget {
  final String pageTitle;
  final Widget child;

  const AppLayout({required Key key, required this.pageTitle, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text(pageTitle)),
        backgroundColor: Colors.orange),
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
          borderRadius: BorderRadius.circular(5), // Set borderRadius to 0 for squared shape
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
      pageTitle: ('Products Page'),
      key: Key('Favourites Page'),
      child: MapScreen(),
    );
  }
}

class OfferScreen extends StatelessWidget {
  const OfferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppLayout(
      pageTitle: 'Offer Page',
      key: Key('OfferPage'),
      child: Center(
        child: Text('add Tools window'),
      ),
    );
  }
}

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppLayout(
      pageTitle: 'Help Center',
      key: Key('Help Center'),
      child: Center(
        child: Text('URGENT', style: TextStyle(color: Colors.redAccent)),
      ),
    );
  }
}

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppLayout(
      pageTitle: 'Favourites',
      key: Key('Favourites Page'),
      child: Center(
        child: Text('NEWS', style: TextStyle(color: Colors.green)),
      ),
    );
  }
}


