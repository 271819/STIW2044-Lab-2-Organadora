import 'package:flutter/material.dart';
import 'package:organadora/view/mydrawer.dart';
import 'package:organadora/user.dart';
import 'loginscreen.dart';
import 'orgagramscreen.dart';

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({Key key, this.user}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("mainScreen"),
      ),
      drawer: Mydrawer(user: widget.user),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("HELLO USER"),
            Text(" WELCOME TO ORGANADORA"),
          ],
        ),
      ),
    );
  }
}
