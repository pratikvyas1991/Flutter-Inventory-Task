
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingDialogue extends StatelessWidget{
  String message;
  LoadingDialogue(this.message);
  @override
  Widget build(BuildContext context) {
    print("@@@ LoadingDialogue from "+message);
    return Column(
      children: [
        Text("Loading "+message+" Data ...."),
        CircularProgressIndicator()
      ],
    );
  }
}