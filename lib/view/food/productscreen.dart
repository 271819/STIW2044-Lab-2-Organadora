import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:organadora/view/food/productdetails.dart';
import 'package:organadora/view/food/categories.dart';

import 'products.dart';
 
class ProductScreen extends StatefulWidget {
    final Categories categories;

  const ProductScreen({Key key, this.categories}) : super(key: key);
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
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
        title: Text(widget.categories.categories),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  viewcart();
                },
                child: Icon(Icons.shopping_cart, size: 30),
              ))
        ],
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
                crossAxisCount: 2,
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
                              child: CachedNetworkImage(
                                imageUrl:
                                    "https://crimsonwebs.com/s271819/organadora/images/products/${productlist[index]['prid']}.jpg",
                                
                              ),
                            ),
                             Padding(
                                padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                                child: Text("Price: RM"+productlist[index]['price'],
                                    style:TextStyle(fontSize: 18,))),
                            Padding(
                                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: Text("Weight: "+productlist[index]['weight']+"g",
                                    style:TextStyle(fontSize: 18,))),
                            
                            SizedBox(height: 15),

                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              minWidth: 150,
                              height: 40,
                              color: Colors.blueAccent,
                              child: Text(
                                "Add to Cart",
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                              onPressed: ()=>{_addcart(index)}
                            ),
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

  void _loadproducts() {
    http.post(
        Uri.parse(
            "https://crimsonwebs.com/s271819/organadora/php/load_products.php"),
        body: {
          "id":widget.categories.id,
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

  _loadFoodDetail(int index) {
    Products product = new Products(
      prid:productlist[index]['prid'],
      name:productlist[index]['name'],
      price:productlist[index]['price'],
      weight:productlist[index]['weight'],
      quantity:productlist[index]['quantity'],
      ingredient:productlist[index]['ingredient'],
      cateid: widget.categories.id,
      date:productlist[index]['date'],
    );
    print(productlist[index]['name']);
     Navigator.push(
                  context, MaterialPageRoute(builder: (content) => ProductDetails(products: product)));
}

  void favourite() {
  }

  void viewcart() {
  }

  void _addtocart(int index) {
    String prid = productlist[index]['prid'];
    String name = productlist[index]['name'];
    String price = productlist[index]['price'];
    String quantity = qty.text.toString();
     http.post(
        Uri.parse(
            "https://crimsonwebs.com/s271819/organadora/php/insert_cart.php"),
        body: {
          "price": price,
          "prid":prid,
          "name":name,
          "quantity":quantity,
        }).then((response) {
        if (response.body == "failed") {
          Fluttertoast.showToast(
              msg: "Failed to added product to your cart",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          Fluttertoast.showToast(
              msg: "Successful added product to your cart!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
        
  });
}

  _addcart(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
            Radius.circular(20),
          )),
          title: Text("Add to cart", style: TextStyle(fontSize: 25)),
          content: new Container(
            height: 150,
            child: Column(
              children: [
                SizedBox(height: 15),
                Text("Enter quantity of products",
                    style: TextStyle(fontSize: 21)),
                SizedBox(height: 15),
                Container(
                  width:80,
                  child: TextField(
                    controller: qty,
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Quantity",
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                _addtocart(index);
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
