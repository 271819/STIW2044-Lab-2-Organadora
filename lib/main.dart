import 'package:flutter/material.dart';
import 'package:organadora/view/splashscreen.dart';
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Organadora',
      home: SplashScreen());
  }
}