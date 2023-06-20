
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:vertiefung_zeugs/layout/components/map/mapmarker.dart';
class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _image;

  final ImagePicker picker = ImagePicker();

  List<int> years = List.generate(20, (index) => DateTime.now().year - index);
  String selectedToggleValue = 'New';

  int selectedYear = DateTime.now().year;
  double price = 0;
  void onYearChanged(int? value) {
    setState(() {
      selectedYear = value ?? DateTime.now().year;
    });
  }
  void onToggleValueChanged(String value) {
    setState(() {
      selectedToggleValue = value;
    });
  }
  void onPriceChanged(String value) {
    setState(() {
      price = double.tryParse(value) ?? 0;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);

    setState(() {
      _image = pickedImage != null ? File(pickedImage.path) : null;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveObject() async {
    String name = _nameController.text;
    String description = _descriptionController.text;


    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    LatLng location = LatLng(position.latitude, position.longitude);
    MapMarker mapmarker = MapMarker(
        imageFile: _image,
        title: name,
        location: location,
        distance: 0.0,
        description: description.isNotEmpty ? description : null,
        price: price,
        condition: selectedToggleValue,
        purchasedate: selectedYear,
    );
    mapMarkers.add(mapmarker);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Stack(
        children: [

        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: GestureDetector(
                    onTap: () => _pickImage(ImageSource.gallery),
                    child: Container(
                      width: 200,
                      height: 250,
                      color: Colors.grey.shade300,
                      child: _image != null
                          ? Image.file(
                        _image!,
                        fit: BoxFit.cover,
                      )
                          : const Icon(
                        Icons.add_photo_alternate,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16.0),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                ),
                const SizedBox(height: 24.0),
                const Text('Condition',
                  style: TextStyle(fontSize: 20),),
                Row(
                  children: [
                    const Text(
                      'Purchase Date:',
                    ),
                    const SizedBox(width: 30),
                    DropdownButton<int>(
                      value: selectedYear,
                      items: years.map((int year) {
                        return DropdownMenuItem<int>(
                          value: year,
                          child: Text(year.toString()),
                        );
                      }).toList(),
                      onChanged: onYearChanged,
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Condition:',
                        ),
                        const SizedBox(width: 40.0),
                        Radio(
                          value: 'New',
                          groupValue: selectedToggleValue,
                          onChanged: (value) => onToggleValueChanged(value!),
                        ),
                        const Text('New'),
                      ],
                    ),
                    Row(
                      children: [
                        const SizedBox(width: 105.0),
                        Radio(
                          value: 'Good',
                          groupValue: selectedToggleValue,
                          onChanged: (value) => onToggleValueChanged(value!),
                        ),
                        const Text('Good'),
                      ],
                    ),
                    Row(
                      children: [
                        const SizedBox(width: 105.0),
                        Radio(
                          value: 'Used',
                          groupValue: selectedToggleValue,
                          onChanged: (value) => onToggleValueChanged(value!),
                        ),
                        const Text('Used'),
                      ],
                    ),
                    Row(
                      children: [
                        const SizedBox(width: 105.0),
                        Radio(
                          value: 'Heavily Used',
                          groupValue: selectedToggleValue,
                          onChanged: (value) => onToggleValueChanged(value!),
                        ),
                        const Text('Heavily Used'),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Price: ',
                    ),
                    const SizedBox(width: 80),
                    SizedBox(
                      width: 100,
                      height: 50,
                      child: TextField(
                        onChanged: onPriceChanged,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Amount',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      '€',
                    ),
                  ],
                ),

                const SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: _saveObject,
                  style: const ButtonStyle(

                  ),
                  child: const Text('Add Tool'),
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
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Add Tool'
                      , style: TextStyle(color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
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
