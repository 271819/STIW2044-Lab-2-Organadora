import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:organadora/user.dart';
import 'package:organadora/view/food/addorgproducts.dart';
import 'package:organadora/view/food/products.dart';
import 'package:organadora/view/mydrawer.dart';
 
class OrgProductsScreen extends StatefulWidget {
    final Products products;
     final User user;
  const OrgProductsScreen({Key key, this.products, this.user}) : super(key: key);
  @override
  _OrgProductsScreenState createState() => _OrgProductsScreenState();
}

class _OrgProductsScreenState extends State<OrgProductsScreen> {
  double screenHeight, screenWidth;
  List productlist;
  TextEditingController qty = new TextEditingController();
  String _titlecenter = "Loading Products...";
  @override
  void initState() {
    super.initState();
    _loadproducts();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Search the products"),
        toolbarHeight: screenHeight/10,
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: Icon(Icons.shopping_cart, size: 30),
              ))
        ],
      ),
      drawer: Mydrawer(user: widget.user),
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
                    (screenWidth / screenHeight) / 0.27,
                children:List.generate(productlist.length, (index) {
                  return Padding(
                    padding: EdgeInsets.all(7),
                    child: Card(
                  elevation: 10,
                  child: InkWell(
                    onTap: ()=>{},
                    child: Row(
                      children: [
                        Expanded(
                          flex:3,
                          child: Container(
                          margin: EdgeInsets.fromLTRB(10, 10, 0, 10),
                          
                          height: 200,
                          width: 50,
                          child: CachedNetworkImage(
                            imageUrl:
                                "https://crimsonwebs.com/s271819/organadora/images/org_products/${productlist[index]['prid']}.png",
                          ),
                        ),
                        ),
                        Expanded(
                          flex:5,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Text(productlist[index]['name'],
                                  style:TextStyle(fontSize: 25,fontWeight: FontWeight.bold)),
                              ),
                              SizedBox(height:10),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10,0,0,10),
                                child: Text("Price: RM"+productlist[index]['price'],
                                  style:TextStyle(fontSize: 18,)),
                              ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0,0,0,10),
                                  child: Text("Weight: "+productlist[index]['weight']+"g",
                                    style:TextStyle(fontSize: 18,)),
                                ),

                                Padding(
                                  padding:const EdgeInsets.fromLTRB(10,0,10,0),
                                  child: Text("Qty: "+productlist[index]['quantity'],
                                    style:TextStyle(fontSize: 18,)),
                                ),

                              ],
                            )
                          )
                        ),
                        SizedBox(height: 15),
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
  floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    floatingActionButton: FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.redAccent,
      onPressed: addproduct,
    )
    );
  }

void _loadproducts() {
  http.post(
      Uri.parse(
          "https://crimsonwebs.com/s271819/organadora/php/load_orgproducts.php"),
      body: {
      }).then((response) {
    if (response.body == "nodata") {
      _titlecenter = "Sorry no product";
      return;
    } else {
      var jsondata = json.decode(response.body);
      productlist = jsondata["products"];
      setState(() {});
      print(productlist);
    }
  });
  }

  addproduct() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
            Radius.circular(20),
          )),
          title: Text("Add new product", style: TextStyle(fontSize: 25)),
          content: new Container(
            height: 100,
            width:40,
            child: Column(
              children: [
                SizedBox(height: 15),
                Text("Are you sure you want to add a new product?",
                    style: TextStyle(fontSize: 21)),
                SizedBox(height: 15),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(context,
                MaterialPageRoute(builder: (content) => AddOrgProducts()));
              },
            ),
            TextButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ],
        );
      },
    );
  }
}