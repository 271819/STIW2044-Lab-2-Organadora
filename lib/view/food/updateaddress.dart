import 'package:flutter/material.dart';
import 'package:organadora/view/food/checkoutpage.dart';
import 'package:organadora/view/food/payment.dart';
import 'package:organadora/view/main/user.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;

class UpdateAddress extends StatefulWidget {
  final User user;
  final Payment payment;
  final double total;
  const UpdateAddress({Key key, this.user,this.payment,this.total}) : super(key: key);
  @override
  _UpdateAddressState createState() => _UpdateAddressState();
}

class _UpdateAddressState extends State<UpdateAddress> {
  ProgressDialog pr;
  TextEditingController stateController = new TextEditingController();
  TextEditingController areaController = new TextEditingController();
  TextEditingController pcdController = new TextEditingController();
  TextEditingController dtlController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context);
    pr.style(
      message: 'Setting new Address...',
      borderRadius: 5.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Your Shipping Address',
            style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.lightGreenAccent[400],
      ),
      body: SingleChildScrollView(
          child: Container(
              child: Column(
        children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 35, 10, 10),
              child: Text(" Name: " + widget.user.name,
                  style: TextStyle(fontSize: 22))),
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
              child: Text("Phone : " + widget.user.phone,
                  style: TextStyle(fontSize: 22))),
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
              maxLines: 7,
              controller: dtlController,
              decoration: InputDecoration(
                hintText: "Enter Detailed addrss",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
          MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            minWidth: 240,
            height: 55,
            color: Colors.redAccent,
            child: Text(
              "Set new Address",
              style: TextStyle(fontSize: 23, color: Colors.white),
            ),
            onPressed: updateaddressdialog,
          ),
           GestureDetector(
              child: Text("Use old address",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      decoration: TextDecoration.underline)),
              onTap: _oldaddress,
            ),
        ],
      ))),
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
          gravity: ToastGravity.TOP,
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
    String address = details + " " + poscode + " " + area + " " + state;
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
            msg: "Successfully set new address ",
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

  void _oldaddress() {
     Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (content) => CheckOutPage(user: widget.user)));
  }
}
