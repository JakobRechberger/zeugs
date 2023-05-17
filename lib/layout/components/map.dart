import 'package:flutter/material.dart';

class MapBox extends StatelessWidget {
  const MapBox({Key? key}) :
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Map Overview')),
      body: const Center(
        child: Text('integrate MapBox API'),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        onPressed: () {  },
        child: const Icon(Icons.add),
      ),

    );
  }
}
