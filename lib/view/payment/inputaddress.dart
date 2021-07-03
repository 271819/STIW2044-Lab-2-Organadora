import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:organadora/view/constructor/user.dart';
import 'package:organadora/view/payment/checkoutpage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
 
class InputAddress extends StatefulWidget {
   final User user;
  const InputAddress({Key key, this.user}) : super(key: key);
  @override
  _InputAddressState createState() => _InputAddressState();
}

class _InputAddressState extends State<InputAddress> {
  ProgressDialog pr;
  TextEditingController stateController = new TextEditingController();
  TextEditingController areaController = new TextEditingController();
  TextEditingController pcdController = new TextEditingController();
  TextEditingController dtlController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context);
    pr.style(
      message: 'Please Wait...',
      borderRadius: 5.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
    );
    return Scaffold(
        appBar: AppBar(
          title: Text('Enter your Address'),
        ),
        body: SingleChildScrollView(
        child:Center(
          child: Container(
            child: Column(children: [
             Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
            child: TextFormField(
              controller: stateController,
              decoration: InputDecoration(
                hintText: "Enter State",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
            child: TextFormField(
              controller: areaController,
              decoration: InputDecoration(
                hintText: "Enter Area",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
            child: TextFormField(
              controller: pcdController,
              decoration: InputDecoration(
                hintText: "Enter Poscode Number",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
            child: TextFormField(
              maxLines: 6,
              controller: dtlController,
              decoration: InputDecoration(
                hintText: "Enter Detailed addrss",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
            ),
          ),
           GestureDetector(
              child: Text("Use Current Location",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      decoration: TextDecoration.underline)),
              onTap: _usecurrentlocation,
            ),
          SizedBox(height:50),
           MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            minWidth: 240,
            height: 55,
            color: Colors.redAccent,
            child: Text(
              "SUBMIT",
              style: TextStyle(fontSize: 23, color: Colors.white),
            ),
            onPressed: updateaddressdialog,
          ),
            ],)
          ),
        ),
        ),
    );
  }
  void updateaddressdialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
            Radius.circular(20),
          )),
          title: Text("Set Your Shipping Address!!!", style: TextStyle(fontSize: 25)),
          content: Text("Are you sure your information is correct?"),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                updateaddress();
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
  Future<void> updateaddress() async {
    if (pcdController.text.toString() == "" ||
        stateController.text.toString() == "" ||
        dtlController.text.toString() == "" ||
        areaController.text.toString() == "") {
      Fluttertoast.showToast(
          msg: "Some of the field are empty!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Color.fromRGBO(191, 30, 46, 50),
          textColor: Colors.white,
          fontSize: 19.0);
      return;
    }
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    await pr.show();
    String details = dtlController.text.toString();
    String poscode = pcdController.text.toString();
    String state = stateController.text.toString();
    String area = areaController.text.toString();
    String address = details + ", " + poscode + " \n" + area + ", " + state;
    print(details);
    print(poscode);
    print(state);
    print(area);
    print(address);
    http.post(
        Uri.parse(
            "https://crimsonwebs.com/s271819/organadora/php/update_address.php"),
        body: {
          "address": address,
          "email":widget.user.email,
        }).then((response) {
      print(response.body);
      if (response.body == "success") {
        Fluttertoast.showToast(
            msg: "Successfully set a new address ",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Color.fromRGBO(191, 30, 46, 50),
            textColor: Colors.white,
            fontSize: 23.0);

        setState(() {
          widget.user.address= address;
        });
        pr.hide().then((isHidden) {
          print(isHidden);
        });
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (content) => CheckOutPage(user: widget.user)));
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
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


  Future<void> _usecurrentlocation() async {
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    await pr.show();
    await _determinePosition().then((value) => {_getPlace(value)});
    setState(
      () {},
    );
  }
   Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

void _getPlace(Position pos) async {
    List<Placemark> newPlace =
        await placemarkFromCoordinates(pos.latitude, pos.longitude);

    Placemark placeMark = newPlace[0];
    String name = placeMark.name.toString();
    String subLocality = placeMark.subLocality.toString();
    String locality = placeMark.locality.toString();
    String administrativeArea = placeMark.administrativeArea.toString();
    String postalCode = placeMark.postalCode.toString();
    String country = placeMark.country.toString();
    widget.user.address = name +
        "," +
        subLocality +
        "," +
        locality +
        "," +
        postalCode +
        ",\n" +
        administrativeArea +
        " " +
        country;
    Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (content) => CheckOutPage(user: widget.user)));
  }
}