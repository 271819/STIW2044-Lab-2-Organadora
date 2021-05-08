import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:organadora/user.dart';

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
                      maxLines: 8,
                      style: TextStyle(fontSize: 20.0),
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                          hintText: 'Whats your gram?',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          )),
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
                borderRadius: BorderRadius.all(Radius.circular(20))),
            title: Text("Take your picture from",
                style: TextStyle(color: Colors.red)),
            content: Container(
                child: Column(
              children: [
                GestureDetector(
                    onTap: () => {Navigator.pop(context), _camera()},
                    child: Image.asset(
                      'assets/images/camera.png',
                      fit: BoxFit.cover,
                      width: 180,
                      height: 150,
                    )),
                SizedBox(height: 5),
                Text("OR",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 30,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Container(
                  child: GestureDetector(
                      onTap: () => {Navigator.pop(context), _gallery()},
                      child: Image.asset(
                        'assets/images/gallery.png',
                        fit: BoxFit.cover,
                        width: 145,
                        height: 145,
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

  /*cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: _image.path,
      aspectRatioPresets:[
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      androidUiSettings: AndroidUiSettings(
        toolbarTitle:'Cropper',
        toolbarColor: Colors.deepOrange,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false
      ),
      iosUiSettings: IOSUiSettings(
        minimumAspectRatio: 1.0,
      ));
      if(croppedFile != null){
        _image = croppedFile;
        setState(() {
          
        });
      }
  }*/
}
