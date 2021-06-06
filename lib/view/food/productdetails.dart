import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'products.dart';

class ProductDetails extends StatefulWidget {
  final Products products;

  const ProductDetails({Key key, this.products}) : super(key: key);
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  double screenHeight, screenWidth;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.products.name),
      ),
      body: Column(children: [
        Container(
          margin: EdgeInsets.fromLTRB(40, 20, 30, 0),
          height: screenHeight / 2.5,
          width: screenWidth / 1.1,
          child: CachedNetworkImage(
            imageUrl:
                "https://crimsonwebs.com/s271819/organadora/images/products/${widget.products.prid}.jpg",
          ),
        ),
        SizedBox(height:20),
        Container(
            margin: EdgeInsets.all(10),
            child: Table(
              defaultColumnWidth: FixedColumnWidth(170),
              border: TableBorder.all(
                  color: Colors.black, style: BorderStyle.solid, width: 2),
              children: [
                TableRow(children: [
                  Column(
                    children: [Container(height:30,child: Text("Price",style:TextStyle(fontSize: 22)))],
                  ),
                  Column(children: [Text("RM " + widget.products.price,style:TextStyle(fontSize: 22))])
                ]),
                TableRow(children: [
                  Column(
                    children: [Container(height:30,child: Text("Weight",style:TextStyle(fontSize: 22)))],
                  ),
                  Column(children: [Text(widget.products.weight+" g",style:TextStyle(fontSize: 22))])
                ]),
                TableRow(children: [
                  Column(
                    children: [Container(height:30,child: Text("Quantity",style:TextStyle(fontSize: 22)))],
                  ),
                  Column(children: [Text(widget.products.quantity,style:TextStyle(fontSize: 22))])
                ]),
                TableRow(children: [
                  Column(
                    children: [Container(height:30,child: Text("Ingredients",style:TextStyle(fontSize: 22)))],
                  ),
                  Column(children: [Text(widget.products.ingredient,style:TextStyle(fontSize: 22))])
                ]),
              ],
            )),
      ]),
    );
  }
}
