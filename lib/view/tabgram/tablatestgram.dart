import 'package:flutter/material.dart';
 
 
class TabLatestGram extends StatefulWidget {
  @override
  _TabLatestGramState createState() => _TabLatestGramState();
}

class _TabLatestGramState extends State<TabLatestGram> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: Center(
          child: Container(
            child: Text('Latest Grams'),
          ),
        ),
    );
  }
}