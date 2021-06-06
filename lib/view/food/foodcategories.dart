import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:organadora/user.dart';
import 'package:organadora/view/food/productscreen.dart';
import 'package:organadora/view/food/categories.dart';

class FoodCategories extends StatefulWidget {
  final User user;

  const FoodCategories({Key key, this.user}) : super(key: key);
  @override
  _FoodCategoriesState createState() => _FoodCategoriesState();
}

class _FoodCategoriesState extends State<FoodCategories> {
  double screenHeight, screenWidth;
  List categorieslist;
  String _titlecenter = "Loading...";
  @override
  void initState() {
    super.initState();
    _loadcategories();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Organic Products'),
      ),
      body: Center(
        child: Container(
            child: Column(
          children: [
            categorieslist == null
                ? Flexible(child: Center(child: Text(_titlecenter)))
                : Flexible(
                    child: Center(
            child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio:
                    (screenWidth / screenHeight) / 0.7,
                children:
                    List.generate(categorieslist.length, (index) {
                  return Padding(
                    padding: EdgeInsets.all(7),
                    child: Card(
                      elevation: 10,
                      child: InkWell(
                        onTap: ()=>_loadFoodDetail(index),
                        
                        child: Column(
                          //crossAxisAlignment:CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: screenHeight / 4.1,
                              width: screenWidth / 1.2,
                              child: CachedNetworkImage(
                                imageUrl:
                                    "https://crimsonwebs.com/s271819/organadora/images/food_categories/${categorieslist[index]['Images']}.jpg",
                                fit: BoxFit.fill,
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                                child: Text(categorieslist[index]['categories'],
                                    style:TextStyle(fontSize: 20))),
                                    
                            SizedBox(height: 10),
                          ],
                        )),
                  ));
                })
              )
            )
          ),
          ],
        )),
      ),
    );
  }

  void _loadcategories() {
    http.post(
        Uri.parse(
            "https://crimsonwebs.com/s271819/organadora/php/load_categories.php"),
        body: {}).then((response) {
      if (response.body == "nodata") {
        _titlecenter = "Sorry no product";
        return;
      } else {
        var jsondata = json.decode(response.body);
        categorieslist = jsondata["categories"];
        setState(() {});
        print(categorieslist);
      }
    });
  }

_loadFoodDetail(int index) {
    print(categorieslist[index]['categories']);
    Categories categories = new Categories(
      id:categorieslist[index]['id'],
      categories:categorieslist[index]['categories'],
      images:categorieslist[index]['images'],
    );
     Navigator.push(
                  context, MaterialPageRoute(builder: (content) => ProductScreen(categories:categories)));
  }
}
