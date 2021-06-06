import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:organadora/view/food/products.dart';
import 'package:http/http.dart' as http;
class Cart extends StatefulWidget {
   final Products products;

  const Cart({Key key, this.products}) : super(key: key);
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
 double screenHeight, screenWidth;
  List productlist;
  String _titlecenter = "Loading Products...";
  @override
  void initState() {
    super.initState();
    _loadcart();
  }
    @override
    Widget build(BuildContext context) {
      screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
      return Scaffold(
        appBar: AppBar(
          title: Text('Cart'),
        ),
           body: Center(
        child: Container(
            child: Column(
          children: [
            productlist == null
                ? Flexible(child: Center(child: Text(_titlecenter)))
                : Flexible(
                    child: Center(
            child: GridView.count(
                crossAxisCount: 1,
                childAspectRatio:
                    (screenWidth / screenHeight) / 1.06,
                children:List.generate(productlist.length, (index) {
                  return Padding(
                    padding: EdgeInsets.all(7),
                    child: Card(
                      elevation: 10,
                      child: InkWell(
                        onTap: ()=>_loadFoodDetail(index),
                        child: Column(
                          children: [
                             Padding(
                                padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                                child: Text(productlist[index]['name'],
                                    style:TextStyle(fontSize: 18,fontWeight: FontWeight.bold))),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                              height: screenHeight / 4.1,
                              width: screenWidth / 1.2,
                              
                            ),
                             Padding(
                                padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                                child: Text("Price: RM"+productlist[index]['price'],
                                    style:TextStyle(fontSize: 18,))),
                            Padding(
                                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: Text("Weight: "+productlist[index]['weight']+"g",
                                    style:TextStyle(fontSize: 18,))),
                          ],
                        )
                        ),
                    )
                  );
                }),
              )
            ),
          ),
          ],
        )),
      ),
      );
    }

  _loadFoodDetail(int index) {}

  void _loadcart() {
     http.post(
        Uri.parse(
            "https://crimsonwebs.com/s271819/organadora/php/load_cart.php"),
        body: {}).then((response) {
      if (response.body == "nodata") {
        _titlecenter = "Sorry no product";
        return;
      }else {
        var jsondata = json.decode(response.body);
        productlist = jsondata["cart"];
        //setState(() {});
        print(productlist);
      }
    });
  }
}
