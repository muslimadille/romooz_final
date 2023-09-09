import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextScreen extends StatelessWidget {
  String data;
   TextScreen(
       this.data,
       {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(body: Center(child: SelectableText(data)));
  }
}
