import 'package:flutter/material.dart';
import 'package:motion_tab_bar/motiontabbar.dart';
import 'package:organadora/view/mydrawer.dart';
import 'package:organadora/user.dart';
import 'package:organadora/view/tabgram/tablatestgram.dart';
import 'package:organadora/view/tabgram/tabnewgram.dart';
import 'package:organadora/view/tabgram/tabyourgram.dart';

class OrgagramScreen extends StatefulWidget {
  final User user;
  final int curtab;
  const OrgagramScreen({Key key, this.user, this.curtab}) : super(key: key);

  @override
  _OrgagramScreenState createState() => _OrgagramScreenState();
}

class _OrgagramScreenState extends State<OrgagramScreen> {
  int currentIndex =0;
  List<Widget> tabchildren;
  String maintitle = "OrganicGram";
  TabController controller;

  @override
  void initState() {
    super.initState();
    tabchildren = [TabLatestGram(), TabNewGram(user: widget.user), TabYourGram()];
  }
  

  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MotionTabBar(
        labels:[
          "Latest Gram","New Gram","Your Gram"
        ],
        initialSelectedTab: "Latest Gram",
        tabIconColor: Colors.green,
        tabSelectedColor: Colors.red,
        onTabItemSelected: onTabTapped,
        icons:[
          Icons.new_releases,Icons.camera,Icons.favorite_rounded,
        ],
        textStyle: TextStyle(color: Colors.red),
      ),
      appBar: AppBar(
        title: Text("Organic gram"),
      ),
      drawer: Mydrawer(user: widget.user),
      body: tabchildren[currentIndex],
    );
    
  }
  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
      if (currentIndex == 0) {
        maintitle = "Latest Grams";
      }
      if (currentIndex == 1) {
        maintitle = "New Grams";
      }
      if (currentIndex == 2) {
        maintitle = "Your Grams";
      }
    });
  }
}
