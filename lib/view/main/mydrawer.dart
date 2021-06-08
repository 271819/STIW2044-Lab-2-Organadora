import 'package:flutter/material.dart';
import 'package:organadora/view/main/loginscreen.dart';
import 'package:organadora/view/main/mainscreen.dart';
import 'package:organadora/view/others/orgagramscreen.dart';
import 'package:organadora/view/main/user.dart';

class Mydrawer extends StatefulWidget {
  final User user;

  const Mydrawer({Key key, this.user}) : super(key: key);

  @override
  _MydrawerState createState() => _MydrawerState();
}

class _MydrawerState extends State<Mydrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            height :180,
            // ignore: missing_required_param
            child: UserAccountsDrawerHeader(
              accountEmail: Text(widget.user.email,style: TextStyle(fontSize:20),),
              currentAccountPicture: new CircleAvatar(
                backgroundColor:
                    Theme.of(context).platform == TargetPlatform.android
                        ? Colors.white
                        : Colors.red,
                backgroundImage: AssetImage("assets/images/profile.png"),
                
              ),
            ),
          ),
          ListTile(
              title: Text("Dashboard",style : TextStyle(fontSize:20)),
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => MainScreen(user: widget.user)));
              }),
         /* ListTile(
              title: Text("Organic Gram",style : TextStyle(fontSize:20)),
              onTap: () {
                Navigator.pop(context); 
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) =>
                            OrgagramScreen(user: widget.user)));
              }),*/
          ListTile(
            title: Text("Organic Products",style : TextStyle(fontSize:20)),
          ),
          ListTile(
            title: Text("Your Carts",style : TextStyle(fontSize:20)),
          ),
          ListTile(
            title: Text("Log out",style : TextStyle(fontSize:20)),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      title: Text("Log out the account?"),
                      content: Text("Are you sure?"),
                      actions: [
                        TextButton(
                          child: Text("OK"),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (content) => LoginScreen()));
                          },
                        ),
                        TextButton(
                            child: Text("Cancel"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                      ],
                    );
                  });
            },
          ),
        ],
      ),
    );
  }
}
