import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:organadora/view/cart/mycart.dart';
import 'package:organadora/view/others/foodcategories.dart';
import 'package:organadora/view/lab3/orgproducts.dart';
import 'package:organadora/view/food/productscreen.dart';
import 'package:organadora/view/main/mydrawer.dart';
import 'package:organadora/view/main/user.dart';
import 'package:organadora/view/main/profile.dart';

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({Key key, this.user}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Organadora"),
      ),
    drawer: Mydrawer(user: widget.user),
     body: Container(
       decoration: new BoxDecoration(
         image: new DecorationImage(
           image: new ExactAssetImage('assets/images/organadora.png', scale: 0.70 ),          
         ),
       ),
       child: new BackdropFilter(
          filter: new ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
          child: new Container(
            decoration: new BoxDecoration(color: Colors.white.withOpacity(0.4)),
        padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 2.0),

        child: GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.all(3.0),
          children: <Widget>[
            makeDashboardItem("Profile", Icons.person),
            makeDashboardItem("Products", Icons.search),
            makeDashboardItem("Your Cart", Icons.shopping_cart),
           // makeDashboardItem("Favourite", Icons.favorite_rounded),
           // makeDashboardItem("Your Wallet", Icons.wallet_giftcard),
          ],
        ),
      ),))
    );
  }
    Card makeDashboardItem(String title, IconData icon) {
    return Card(
      clipBehavior: Clip.antiAlias,
       elevation:12.0,
        margin: new EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Container(
          decoration: BoxDecoration(color: Colors.lightGreenAccent[400]),
          child: new InkWell(
            onTap: () {
              if(title=="Profile"){
                 Navigator.push(
                  context, MaterialPageRoute(builder: (content) => Profile(user: widget.user)));
              }
               if(title=="Products"){
                 Navigator.push(
                  context, MaterialPageRoute(builder: (content) => ProductScreen(user: widget.user)));
              }
              if(title=="Your Cart"){
                 Navigator.push(
                  context, MaterialPageRoute(builder: (content) => Cart()));
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                SizedBox(height: 50.0),
                Center(
                    child: Icon(
                  icon,
                  size: 50.0,
                  color: Colors.black,
                )),
                SizedBox(height: 20.0),
                new Center(
                  child: new Text(title,
                      style:
                          new TextStyle(fontSize: 18.0, color: Colors.black)),
                )
              ],
            ),
          ),
        ),
    );
  }
}
