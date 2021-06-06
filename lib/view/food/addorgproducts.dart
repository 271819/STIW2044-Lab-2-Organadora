import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:organadora/view/food/orgproducts.dart';
 
class AddOrgProducts extends StatefulWidget {
  @override
  _AddOrgProductsState createState() => _AddOrgProductsState();
}

class _AddOrgProductsState extends State<AddOrgProducts> {
   File _image;
  String pathAsset = "assets/images/upload.png";
  TextEditingController namecontroller = new TextEditingController();
  TextEditingController pricecontroller = new TextEditingController();
  TextEditingController qtycontroller = new TextEditingController();
  TextEditingController weightcontroller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Organic Products'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            child: Padding(
                padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () => {_onPictureSelection()},
                        child: Container(
                          height: 210,
                          width: 230,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: _image == null
                                  ? AssetImage(pathAsset)
                                  : FileImage(_image),
                              fit: BoxFit.cover,
                            ),
                            border: Border.all(
                              width: 3.0,
                              color: Colors.grey,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text("Click image to add the product",
                          style:
                              TextStyle(fontSize: 15.0, color: Colors.black)),
                      SizedBox(height: 15),
                      Card(
                        margin: EdgeInsets.fromLTRB(5, 0, 5, 10),
                        elevation: 10,
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
                            child: Column(
                              children: [
                                Text("Enter Product Information",
                                    style: TextStyle(
                                        fontSize: 21,
                                        fontWeight: FontWeight.bold)),
                                TextFormField(
                                  controller: namecontroller,
                                  decoration: const InputDecoration(
                                    hintText: 'Enter Product Name',
                                    labelText: 'Product Name',
                                  ),
                                ),
                                
                                TextFormField(
                                  controller: pricecontroller,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    hintText: 'Enter Product Price',
                                    labelText: 'Product Price',
                                  ),
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: weightcontroller,
                                  decoration: const InputDecoration(
                                    hintText: 'Enter Product Weight',
                                    labelText: 'Product weight in gram',
                                  ),
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: qtycontroller,
                                  decoration: const InputDecoration(
                                    hintText: 'Enter Product Quantity',
                                    labelText: 'Product Quantity',
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            )),
                      ),
                      SizedBox(height: 10),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        minWidth: 200,
                        height: 50,
                        color: Colors.blueAccent,
                        child: Text(
                          "Add Products",
                          style: TextStyle(fontSize: 23, color: Colors.white),
                        ),
                        onPressed: _addpr,
                      ),
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }

  _onPictureSelection() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
              Radius.circular(20),
            )),
            title: Text("Take your picture from",
                style: TextStyle(color: Colors.red, fontSize: 25)),
            content: Container(
                height: 450,
                child: Column(
                  children: <Widget>[
                    GestureDetector(
                        onTap: () => {Navigator.pop(context), _camera()},
                        child: Image.asset(
                          'assets/images/camera.png',
                          fit: BoxFit.cover,
                          width: 220,
                          height: 190,
                        )),
                    SizedBox(height: 10),
                    Text("OR",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 30,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Container(
                      child: GestureDetector(
                          onTap: () => {Navigator.pop(context), _gallery()},
                          child: Image.asset(
                            'assets/images/gallery.png',
                            fit: BoxFit.cover,
                            width: 180,
                            height: 170,
                          )),
                    ),
                  ],
                )),
          );
        });
  }

  Future _camera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(
        source: ImageSource.camera, maxHeight: 800, maxWidth: 800);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print("No image selected");
      }
    });
  }

  _gallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery, maxHeight: 800, maxWidth: 800);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print("No image selected");
      }
    });
  }

  void _addpr() {
    if (_image == null ||
        namecontroller.text.toString() == "" ||
        weightcontroller.text.toString() == "" ||
        pricecontroller.text.toString() == "" ||
        qtycontroller.text.toString() == "") {
      Fluttertoast.showToast(
          msg: "Some of the field or picture are empty!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Color.fromRGBO(191, 30, 46, 50),
          textColor: Colors.white,
          fontSize: 19.0);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
            Radius.circular(20),
          )),
          title: Text("Add the product?", style: TextStyle(fontSize: 25)),
          content: Text("Are you sure?"),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                _addnewproduct();
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

  void _addnewproduct() {
    String base64Image = base64Encode(_image.readAsBytesSync());
    String name = namecontroller.text.toString();
    String price = pricecontroller.text.toString();
    String weight = weightcontroller.text.toString();
    String qty = qtycontroller.text.toString();
    print(base64Image);
    print(name);
    print(price);
    print(weight);
    print(qty);
    http.post(
        Uri.parse("https://crimsonwebs.com/s271819/organadora/php/insert_orgproducts.php"),
        body: {
          "name": name,
          "price": price,
          "qty": qty,
          "weight": weight,
          "encoded_string": base64Image
        }).then((response) {
      print(response.body);
      if (response.body == "success") {
        Fluttertoast.showToast(
            msg: "Success ",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Color.fromRGBO(191, 30, 46, 50),
            textColor: Colors.white,
            fontSize: 23.0);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (content) => OrgProductsScreen()));
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Color.fromRGBO(191, 30, 46, 50),
            textColor: Colors.white,
            fontSize: 23.0);
      }
    });
  }
}