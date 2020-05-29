import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FruitList extends StatelessWidget{
  final List<String> fruits = [ "Apple", "Banana", "Pear", "Orange", "Kiwi" ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: EdgeInsets.all(5),
            child: ListView.builder(
              itemBuilder: _buildFruitItem,
              itemCount: fruits.length,
            )
        )
    );
  }

  Widget _buildFruitItem( BuildContext context, int index ){
    return Card(
      child: Text( fruits[index] ),
    );
  }

}