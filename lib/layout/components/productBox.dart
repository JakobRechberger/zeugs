import 'package:flutter/material.dart';

class ProductBox extends StatelessWidget {
  const ProductBox({Key? key, required this.name, required this.description, required this.price}) :
        super(key: key);
  final String name;
  final String description;
  final int price;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.orangeAccent,
        child: Row(
            children: <Widget>[
              Expanded(
                  child: Container(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                              name, style: const TextStyle(
                              fontWeight: FontWeight.bold
                          )
                          ),
                          Text(description), Text(
                              "Price: $price"
                          ),
                        ],
                      )
                  )
              )
            ]
        )
    );
  }
}
