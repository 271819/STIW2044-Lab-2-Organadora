import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:organadora/view/main/user.dart';
import 'package:organadora/view/food/products.dart';
import 'package:organadora/view/main/mydrawer.dart';
 
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
  bool typing = false;
  String name ="";
  TextEditingController srccontroller = new TextEditingController();
  String _titlecenter = "Loading Products...";
  @override
  void initState() {
    super.initState();
    _loadproducts(name);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Organic Product"),
        toolbarHeight: screenHeight/11,
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
        Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
          child: TextFormField(
                  controller: srccontroller,
                  decoration: InputDecoration(
                    hintText: "Search product",
                    suffixIcon: IconButton(
                      onPressed: () => _loadproducts(srccontroller.text.toString()),
                      icon: Icon(Icons.search),
                    ),
                    border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.all(Radius.circular(10.0)),
                        ),
                  ),
                ),
        ),
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
                    ])
                )),
              SizedBox(height: 15),
            ],
          )),
         ));
        }),
      )),
      )],
    )),
  ));
}
  
  _loadproducts(String name) {
    print(name);
      http.post(
          Uri.parse(
              "https://crimsonwebs.com/s271819/organadora/php/load_orgproducts.php"),
          body: {
            'name':name,
          }).then((response) {
             print(response.body);
        if (response.body == "nodata") {
          _titlecenter = "Sorry no product";
          Fluttertoast.showToast(
            msg: "No Product Found",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 2,
            backgroundColor: Color.fromRGBO(191, 30, 46, 50),
            textColor: Colors.white,
            fontSize: 23.0);
          return;
        } else {
          var jsondata = json.decode(response.body);
          productlist = jsondata["products"];
          setState(() {});
          print(productlist);
        }
      });
  }
}