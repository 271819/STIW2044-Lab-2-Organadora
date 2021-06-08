import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:organadora/view/main/user.dart';
import 'package:http/http.dart' as http;

class TabNewGram extends StatefulWidget {
  final User user;

  const TabNewGram({Key key, this.user}) : super(key: key);
  @override
  _TabNewGramState createState() => _TabNewGramState();
}

class _TabNewGramState extends State<TabNewGram> {
  double screenHeight, screenWidth;
  File _image;
  String pathAsset = "assets/images/upload.png";
  TextEditingController _descCtrl = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Container(
          child: Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => {_onPictureSelection()},
                      child: Container(
                        height: 230,
                        width: 240,
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
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text("Click image to take your gram picture",
                        style: TextStyle(fontSize: 15.0, color: Colors.black)),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: _descCtrl,
                      maxLines: 7,
                      style: TextStyle(fontSize: 20.0),
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        hintText: 'Whats your gram?',
                        hintStyle: TextStyle(color: Colors.blue),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(270, 0, 0, 0),
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        minWidth: 50,
                        height: 50,
                        color: Colors.blueAccent,
                        elevation: 5,
                        child: Text("Post"),
                        onPressed: post,
                      ),
                    ),
                  ],
                ),
              )),
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

  void post() {
    if (_image == null || _descCtrl.text.toString() == "") {
      Fluttertoast.showToast(
          msg: "Image or Grams is empty!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromRGBO(191, 30, 46, 50),
          textColor: Colors.white,
          fontSize: 23.0);
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
          title: Text("Post Your Gram?", style: TextStyle(fontSize: 25)),
          content: Text("Are you sure?"),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                _postuserGram();
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

  void _postuserGram() {
    String base64Image = base64Encode(_image.readAsBytesSync());
    String desc = _descCtrl.text.toString();
    print(base64Image);
    print(desc);
    http.post(
        Uri.parse(
            "https://crimsonwebs.com/s271819/organadora/php/insert_gram.php"),
        body: {
          "email": widget.user.email,
          "gram_desc": desc,
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
