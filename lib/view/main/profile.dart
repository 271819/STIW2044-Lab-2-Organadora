import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:organadora/view/main/user.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:organadora/view/main/mainscreen.dart';
import 'package:progress_dialog/progress_dialog.dart';

class Profile extends StatefulWidget {
  final User user;

  const Profile({Key key, this.user}) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}


class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
    
  }
  File _image;
  String pathAsset = "assets/images/profile.png";
  bool _isEnable = false;
  bool _isEnablePhone = false;
  ProgressDialog pr;
  TextEditingController nameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    nameController.text = widget.user.name;
    phoneController.text = widget.user.phone;
     Container(
        child: CachedNetworkImage(
          imageUrl:
              "https://crimsonwebs.com/s271819/organadora/images/profile_image/.png",
        ),
      );
      // ignore: missing_required_param
    pr = ProgressDialog(context);
    pr.style(
      message: 'Updating...',
      borderRadius: 5.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Profile'),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  _saveChange();
                },
                child: Icon(Icons.save, size: 30),
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
              padding: EdgeInsets.fromLTRB(30, 50, 30, 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                        onTap: () => {_onUploadPic()},
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
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        )),
                    SizedBox(height: 20),
                    Divider(
                      color: Colors.grey,
                      height: 20,
                      thickness: 5,
                    ),
                    
                    SizedBox(height: 20),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Name:   ", style: TextStyle(fontSize: 20)),
                          Container(
                            width: 170,
                            child: TextField(
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.center,
                              controller: nameController,
                              enabled: _isEnable,
                            ),
                          ),
                          IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                setState(() {
                                  _isEnable = true;
                                });
                              })
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Phone:   " ,style: TextStyle(fontSize: 20)),
                          Container(
                            width: 170,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.center,
                              controller: phoneController,
                              enabled: _isEnablePhone,
                            ),
                          ),
                          IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                setState(() {
                                  _isEnablePhone = true;
                                });
                              }),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Text("Email:  " + widget.user.email,
                        style: TextStyle(fontSize: 20)),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Future _onUploadPic() async {
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

  void _saveChange() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
            Radius.circular(20),
          )),
          title: Text("Update Information ?", style: TextStyle(fontSize: 25)),
          content: Text("Are you sure?"),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                _updateInformation();
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

  Future<void> _updateInformation() async {
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    await pr.show();
    String base64Image = base64Encode(_image.readAsBytesSync());
    String name = nameController.text.toString();
    String phone = phoneController.text.toString();
    print(name);
    print(phone);
    print(base64Image);
    http.post(
        Uri.parse(
            "https://crimsonwebs.com/s271819/organadora/php/update_profile.php"),
        body: {
          "name": name,
          "phone": phone,
          "email": widget.user.email,
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

        setState(() {
          widget.user.name = nameController.text.toString();
          widget.user.phone = phoneController.text.toString();
        });
        pr.hide().then((isHidden) {
          print(isHidden);
        });
        Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (content) => MainScreen(user: widget.user)));
        
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Color.fromRGBO(191, 30, 46, 50),
            textColor: Colors.white,
            fontSize: 23.0);
            pr.hide().then((isHidden) {
          print(isHidden);
        });
      }
    });
  }

}

