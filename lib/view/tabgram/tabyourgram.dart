import 'package:flutter/material.dart';
 
 
class TabYourGram extends StatefulWidget {
  @override
  _TabYourGramState createState() => _TabYourGramState();
}

class _TabYourGramState extends State<TabYourGram> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: Center(
          child: Container(
            child: Text('Your Grams'),
          ),
        ),
    );
  }
}