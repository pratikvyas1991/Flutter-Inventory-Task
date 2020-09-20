
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorDialogue extends StatelessWidget{
  String message;
  ErrorDialogue(this.message);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          message,
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }

}