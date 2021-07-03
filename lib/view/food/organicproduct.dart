import 'package:flutter/material.dart';
import 'package:motion_tab_bar/motiontabbar.dart';
import 'package:organadora/view/payment/mycart.dart';
import 'package:organadora/view/food/productscreen.dart';
import 'package:organadora/view/main/profile.dart';
import 'package:organadora/view/main/user.dart';

class OrganicProduct extends StatefulWidget {
  final User user;
  final int curtab;
  const OrganicProduct({Key key, this.user, this.curtab}) : super(key: key);

  @override
  _OrganicProductState createState() => _OrganicProductState();
}

class _OrganicProductState extends State<OrganicProduct> {
  int currentIndex =0;
  List<Widget> tabchildren;
  String maintitle = "";
  TabController controller;

  @override
  void initState() {
    super.initState();
    tabchildren = [ProductScreen(user: widget.user), Cart(user: widget.user), Profile(user: widget.user)];
  }
  
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MotionTabBar(
        labels:[
          "Products","Carts","Profile"
        ],
        initialSelectedTab: "Products",
        tabIconColor: Colors.green,
        tabSelectedColor: Colors.red,
        onTabItemSelected: onTabTapped,
        icons:[
          Icons.new_releases,
          Icons.shopping_cart,
          Icons.person,
        ],
        textStyle: TextStyle(color: Colors.red),
      ),
      appBar: AppBar(
        title: Text("Organadora",
        style: TextStyle(color: Colors.black, fontSize: 30,)),
        backgroundColor: Colors.lightGreenAccent[400],
        centerTitle: true,
        toolbarHeight: 60,
      ),
      body: tabchildren[currentIndex],
    );
    
  }
  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
      if (currentIndex == 0) {
        maintitle = "Products";
      }
      if (currentIndex == 1) {
        maintitle = "Carts";
      }
      if (currentIndex == 2) {
        maintitle = "Profiles";
      }
    });
  }
}
