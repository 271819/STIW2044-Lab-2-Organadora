import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:organadora/view/food/products.dart';
import 'package:http/http.dart' as http;
import 'package:organadora/view/main/user.dart';
import 'package:progress_dialog/progress_dialog.dart';
class Cart extends StatefulWidget {
   final Products products;
   final User user;
  const Cart({Key key, this.products, this.user}) : super(key: key);
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
 double screenHeight, screenWidth;
 double _totalprice =0.0;
  List cartlist;
  ProgressDialog pr;
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
    pr = ProgressDialog(context);
    pr.style(
      message: 'Updating cart...',
      borderRadius: 5.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
    );
      return Scaffold(
        appBar: AppBar(
          title: Text(' Your Cart'),
        ),
           body: Center(
        child: Container(
            child: Column(
          children: [
            cartlist == null
                ? Flexible(child: Center(child: Text(_titlecenter)))
                : Flexible(
                   child: Center(
      child: GridView.count(
        crossAxisCount: 1,
        childAspectRatio:
            (screenWidth / screenHeight) / 0.27,
        children:List.generate(cartlist.length, (index) {
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
                  height: 230,
                  width: 80,
                  child: CachedNetworkImage(
                    imageUrl:
                        "https://crimsonwebs.com/s271819/organadora/images/products/${cartlist[index]['prid']}.jpg",
                  ),
                ),
                ),
          Container(
            height: 150,
            child: VerticalDivider(color: Colors.grey,thickness:1,)),
            Expanded(
              flex:5,
              child: Padding(
                padding: const EdgeInsets.all(7.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                    child: Text(cartlist[index]['name'],
                      style:TextStyle(fontSize: 22,fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height:10),
                  
                    Text("RM"+ (double.parse(cartlist[index]['price'])).toStringAsFixed(2),
                      style:TextStyle(fontSize: 21,color: Colors.red)),
                  
                  Padding(
                          padding:const EdgeInsets.fromLTRB(40,0,10,0),
                    child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              _modQty(index, "removecart");
                            },
                          ),
                          
                          Text(cartlist[index]['quantity'],
                          style:TextStyle(fontSize: 18,)),

                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              _modQty(index, "addcart");
                            },
                          ),
                        ],
                      ),
                  ),
                 ])
                )),
            Expanded(
              flex:1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _deleteCartDialog(index);
                    },
                   )
                 ]
                )),
              SizedBox(height: 15),
             ],
          )),
         ));
        }),
      )),
      ),
      Container(
          padding: EdgeInsets.fromLTRB(10, 20, 20, 20),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Divider(
                color: Colors.red,
                height: 1,
              ),
              Text(
                "TOTAL: RM " + _totalprice.toStringAsFixed(2),
                style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
              ElevatedButton(
                onPressed: () {
                  _payDialog();
                },
                child: Text("CHECKOUT"),
              )
            ],
          )),
      ],
    )),
  )
  );
}

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
        cartlist = jsondata["cart"];
        
         _titlecenter = "";
        _totalprice = 0.0;
        for (int i = 0; i < cartlist.length; i++) {
          _totalprice = _totalprice +
              double.parse(cartlist[i]['price']) *
                  int.parse(cartlist[i]['quantity']);
        }
        print(cartlist);
      }
      setState(() {});
    });
  }

  Future<void> _modQty(int index, String s) async {
     pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    await pr.show();
    http.post(
        Uri.parse(
            "https://crimsonwebs.com/s271819/organadora/php/update_cart.php"),
        body: {
          "op": s,
          "prid": cartlist[index]['prid'],
          "qty": cartlist[index]['quantity']
        }).then((response) {
      print(response.body);
      if (response.body == "success") {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        _loadcart();
        pr.hide().then((isHidden) {
          print(isHidden);
        });
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
            pr.hide().then((isHidden) {
          print(isHidden);
        });
      }
    });
  }
  void _payDialog() {
    if (_totalprice == 0.0) {
      Fluttertoast.showToast(
          msg: "Amount not payable",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    } else {
      showDialog(
          builder: (context) => new AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: new Text(
              'Proceed with checkout?',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text("Yes"),
                onPressed: () async {
                  /*Navigator.of(context).pop();
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CheckOutPage(
                          email: widget.email, total: _totalprice),
                    ),
                  );*/
                },
              ),
              TextButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              }),
            ]),
      context: context);
    }
  }

  void _deleteCartDialog(int index) {
     showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
            Radius.circular(20),
          )),
          title: Text("Delete cart", style: TextStyle(fontSize: 26)),
          content: new Container(
            height: 60,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Delete "+cartlist[index]['name'] + " from cart ?",
                    style: TextStyle(fontSize: 18)),
              ]
            ),
          ),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteCart(index);
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

  Future<void> _deleteCart(int index) async {
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    await pr.show();
     http.post(
        Uri.parse(
            "https://crimsonwebs.com/s271819/organadora/php/delete_cart.php"),
        body: {
          "prid":cartlist[index]['prid'],
        }).then((response) {
      if (response.body == "success") {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
          _loadcart();
          pr.hide().then((isHidden) {
          print(isHidden);
        });
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
            pr.hide().then((isHidden) {
            print(isHidden);
        });
      }
        print(cartlist);
      }
    );
  }
  
}