import 'package:flutter/material.dart';
import 'loginscreen.dart';
import 'user.dart';
 
 
class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({Key key, this.user}) : super(key: key);

  
  @override
  _MainScreenState createState() => _MainScreenState();
}
   
class _MainScreenState extends State<MainScreen> {
  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: Text('Organadora Main Screen'),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
            // ignore: missing_required_param
            UserAccountsDrawerHeader(
              accountEmail: Text(widget.user.email),
              currentAccountPicture: CircleAvatar(
                backgroundColor:
                Theme.of(context).platform ==TargetPlatform.android
                ?Colors.white
                :Colors.red,
              child: Text(widget.user.email
              .toString()
              .substring(0,1)
              .toUpperCase(),style: TextStyle(fontSize: 16))
              ),
              ),
            ListTile(
              title: Text("Your Profile"),
            ),
            ListTile(
              title: Text("Favourite"),
            ),
            ListTile(
              title: Text("Log out"),
              onTap: (){
                showDialog(context: context, builder: (BuildContext context){
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
                  title: Text("Log out the account?"),
                   content: Text("Are you sure?"),
                   actions: [
                     TextButton(child: Text("OK"), onPressed: (){
                       Navigator.push(
                  context, MaterialPageRoute(
                    builder: (content) => LoginScreen()));
                      },),
                   TextButton(child: Text("Cancel"),onPressed: (){
                      Navigator.of(context).pop();
                }),
              ],
          );
       });
                
              },
            ),
          ],)
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("HELLO USER"),
              Text(" WELCOME TO ORGANADORA"),
            ],
          ),
        ),
      
    );
  }
}
