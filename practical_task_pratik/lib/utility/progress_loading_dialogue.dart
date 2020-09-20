
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingDialogue extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        Text("Loading Data ...."),
        CircularProgressIndicator()
      ],
    );
  }
}