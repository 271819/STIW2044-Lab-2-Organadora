import 'package:flutter/material.dart';
import 'package:organadora/view/cart/payment.dart';
import 'package:organadora/view/cart/payscreen.dart';
import 'dart:convert';
import 'package:organadora/view/cart/updateaddress.dart';
import 'package:organadora/view/main/user.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

class CheckOutPage extends StatefulWidget {
  final User user;
  final double total;
  final Payment payment;
  const CheckOutPage({Key key, this.total, this.user, this.payment})
      : super(key: key);
  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  double screenHeight, screenWidth;
  double _totalprice = 0.0, shippingfee = 0.00, payment = 0.0;
  List cartlist;
  String _titlecenter = "Loading Products...";
  @override
  void initState() {
    super.initState();
    _loadcart();
  }

  TextEditingController msgController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Check Out Page', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.lightGreenAccent[400],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                child: Container(
                  height: 150,
                  width: 380,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: InkWell(
                    onTap: () => setaddress(),
                    child: Column(
                      children: [
                        Container(
                            child: Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(18, 15, 0, 0),
                              child: Text( widget.user.name +" |\t "+widget.user.phone,
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        )),
                        Container(
                          child: Row(
                            children: [
                              Padding(
                                padding:const EdgeInsets.fromLTRB(30, 0, 0, 0),
                                child: Text(widget.user.email,
                                    style: TextStyle(fontSize: 18)),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Wrap(
                            children: [
                              Padding(
                                padding:const EdgeInsets.fromLTRB(30, 10, 10, 15),
                                child: Text(widget.user.address,
                                    style: TextStyle(fontSize: 18)),
                              ),
                            ],
                          ),
                        ),
                        Container(
                            child: Text("Make sure the Delivery Address is correct!!!",
                                style: TextStyle(
                                  color: Colors.red,
                            ))),
                          ],
                        )),
                  ),
                ),
              ),
              /*Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
              child: TextFormField(
                maxLines: 7,
                //controller: srccontroller,
                decoration: InputDecoration(
                  hintText: "Enter your current addrss",
                  suffixIcon: IconButton(
                    onPressed: () => setaddress(),
                    icon: Icon(Icons.location_pin, size: 45),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
              ),
            ),*/
              Divider(
                color: Colors.grey,
                height: 20,
                thickness: 3,
              ),
              SingleChildScrollView(
                child: Container(
                  height: 250,
                  width: 390,
                  child: Column(
                    children: [
                      cartlist == null
                    ? Flexible(child: Center(child: Text(_titlecenter)))
                    : Flexible(
                        child: Center(
                        child: GridView.count(
                      crossAxisCount: 1,
                      childAspectRatio:
                          (screenWidth / screenHeight) / 0.15,
                      children:
                          List.generate(cartlist.length, (index) {
                        return Padding(
                            padding: EdgeInsets.all(7),
                            child: Container(
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Container(
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "https://crimsonwebs.com/s271819/organadora/images/products/${cartlist[index]['prid']}.jpg",
                                      ),
                                    ),
                                  ),
                                  Container(
                                      height: 150,
                                      child: VerticalDivider(
                                        color: Colors.grey,
                                        thickness: 1,
                                      ),
                                    ),
                            Expanded(
                                flex: 6,
                                child: Padding(
                                padding:const EdgeInsets.all(11.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                    mainAxisAlignment:
                                        MainAxisAlignment
                                            .center,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.fromLTRB( 0, 0, 0, 5),
                                        child: Text(cartlist[index] ['name'],
                                            style: TextStyle(fontSize: 16,
                                                fontWeight:FontWeight .bold)),
                                      ),
                                      SizedBox(height: 10),
                                      Text("\tRM " +cartlist[index]['price'],
                                          style: TextStyle(fontSize: 15,color: Colors.red)),
                                    ])
                                )),
                              Expanded(
                                  flex: 3,
                                  child: Padding(
                                      padding:const EdgeInsets.all(11.0),
                                      child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment:MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:const EdgeInsets .fromLTRB(0, 0, 0, 5),
                                          child: Text( "x " +cartlist[index][ 'quantity'],
                                              style: TextStyle(
                                                  fontSize:18,
                                                  fontWeight:FontWeight.bold)),
                                          ),
                                        ])
                                      )),
                                    ],
                                  ),
                                ));
                              }),
                              )),
                            ),
                      Divider(
                        color: Colors.grey,
                        height: 20,
                        thickness: 3,
                      ),
                      /*  Container(
                    width:370,
                    decoration: BoxDecoration(
                    color: Colors.yellow[100],
                    border: Border.all(
                      color: Colors.red,
                      width: 2,
                    )),
                    height:40,
                    child:Text("Total Number of Prouct: ", style:TextStyle(fontSize: 18))),*/
                    ],
                  ),
                ),
              ),
              Container(
                height: 65,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(25, 3, 25, 10),
                  child: TextFormField(
                    controller: msgController,
                    decoration: InputDecoration(
                      hintText: "Please Leave your Message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: 370,
                child: Column(
                  children: [
                    Container(
                        child: Row(
                      children: [
                        Expanded(
                          flex: 8,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(17, 0, 0, 0),
                            child: Text("Order Total: ",
                                style: TextStyle(fontSize: 17)),
                          ),
                        ),
                        Expanded(
                            flex: 4,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(25, 0, 10, 0),
                              child: Text("RM " + _totalprice.toStringAsFixed(2),
                                  style: TextStyle(fontSize: 17)),
                            ))
                      ],
                    )),
                    Container(
                        child: Row(
                      children: [
                        Expanded(
                          flex: 8,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(17, 5, 0, 0),
                            child: Text("Shipping Fee: \n(FOC purchase over RM60)",
                                style: TextStyle(fontSize: 17)),
                          ),
                        ),
                        Expanded(
                            flex: 4,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(25, 0, 10, 0),
                              child: Text("RM " + shippingfee.toStringAsFixed(2),
                                  style: TextStyle(fontSize: 17)),
                        ))
                      ],
                    )),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Container(
                  height: 78,
                  width: 400,
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "TOTAL PAYMENT: \n\t\t\t\tRM " + payment.toStringAsFixed(2),
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                      Container(
                        height: 100,
                        color: Colors.red,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red),
                          ),
                          onPressed: () {
                            _payment(payment);
                          },
                          child: Text("Place Order"),
                        ),
                      ),
                    ],
                  )),
            ]),
          ),
        ),
      ),
    );
  }

  setaddress() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (content) => UpdateAddress(user: widget.user)));
  }

  void _loadcart() {
    http.post(
        Uri.parse(
            "https://crimsonwebs.com/s271819/organadora/php/load_cart.php"),
        body: {}).then((response) {
      print(response.body);
      if (response.body == "nodata") {
        return;
      } else {
        var jsondata = json.decode(response.body);
        cartlist = jsondata["cart"];
        _totalprice = 0.0;
        for (int i = 0; i < cartlist.length; i++) {
          _totalprice = _totalprice +
              double.parse(cartlist[i]['price']) *
                  int.parse(cartlist[i]['quantity']);
        }
        calfee(_totalprice);
        print(cartlist);
      }
      setState(() {});
    });
  }

  calfee(double totalprice) {
    if (totalprice > 60) {
      shippingfee = 0.00;
      payment = totalprice + shippingfee;
    } else {
      shippingfee = 5.00;
      payment = totalprice + shippingfee;
    }
  }

  void _payment(double payment) {
    String message = msgController.text.toString();
    double totalpayment = payment;
     showDialog(
        builder: (context) => new AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: new Text(
              'Pay RM ' + payment.toStringAsFixed(2) + "?",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text("Yes"),
                onPressed: () async {
                  Navigator.of(context).pop();

                  Payment payment = new Payment(
                      message:message, 
                      totalpayment:totalpayment,
                      );

                  await Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => PayScreen(payment: payment,user: widget.user),
                    ),
                  );
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
