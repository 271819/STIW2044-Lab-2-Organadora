import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:organadora/view/main/loginscreen.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscureText = true;
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordaController = new TextEditingController();
  TextEditingController _passwordbController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SingleChildScrollView(
              child: Column(
        children: [
          Container(
              margin: EdgeInsets.fromLTRB(10, 0, 10, 5),
              child: Image.asset('assets/images/organadora.png', scale: 0.9)),
          Card(
            color: Colors.lightGreenAccent[400],
            elevation: 20,
            margin: EdgeInsets.fromLTRB(30, 0, 30, 15),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
              child: Column(
                children: [
                  Text("Register New Account",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                  SizedBox(height: 20),
                  Container(
                    child: TextField(
                      style: TextStyle(fontSize: 20),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        fillColor: Colors.grey[300],
                        border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                          const Radius.circular(20.0),
                        )),
                        filled: true,
                        hintText: "Type in your Email",
                        labelText: 'Email',
                        icon: Icon(Icons.email, size: 30),
                      ),
                      controller: _emailController,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: TextField(
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        fillColor: Colors.grey[300],
                        border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                          const Radius.circular(20.0),
                        )),
                        filled: true,
                        hintStyle: new TextStyle(color: Colors.grey[800]),
                        hintText: "Type in your Password",
                        labelText: 'Password',
                        icon: Icon(Icons.lock, size: 30),
                      ),
                      obscureText: _obscureText,
                      controller: _passwordaController,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: TextField(
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        fillColor: Colors.grey[300],
                        border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                          const Radius.circular(20.0),
                        )),
                        filled: true,
                        hintStyle: new TextStyle(color: Colors.grey[800]),
                        hintText: "Type in your Password",
                        labelText: 'Confirm Password',
                        icon: Icon(Icons.lock, size: 30),
                      ),
                      obscureText: _obscureText,
                      controller: _passwordbController,
                    ),
                  ),
                  SizedBox(height: 30),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    minWidth: 240,
                    height: 55,
                    color: Colors.blueAccent,
                    child: Text(
                      "Register",
                      style: TextStyle(fontSize: 23, color: Colors.white),
                    ),
                    onPressed: _onRegister,
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            child: Text(
              "Already register?",
              style: TextStyle(
                color: Colors.red,
                fontSize: 22,
                decoration: TextDecoration.underline,
              ),
            ),
            onTap: _alreadyRegister,
          ),
        ],
      ))),
    );
  }

  void _onRegister() {
    String _email = _emailController.text.toString();
    String _passworda = _passwordaController.text.toString();
    String _passwordb = _passwordbController.text.toString();

    if (_email.isEmpty || _passworda.isEmpty || _passwordb.isEmpty) {
      Fluttertoast.showToast(
          msg: "Email/password is empty ",
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
                borderRadius: BorderRadius.all(Radius.circular(20))),
            title: Text("Register new user?"),
            content: Text("Are you sure?"),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                  _registerNewUser(_email, _passworda, _passwordb);
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
  }

  void _alreadyRegister() {
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => LoginScreen()));
  }

  void _registerNewUser(String email, String password, String passwordb) {
    if (email.contains("@")) {
      if (password.length >= 6) {
        if (password == passwordb) {
          http.post(
              Uri.parse(
                  "https://crimsonwebs.com/s271819/organadora/php/register_user.php"),
              body: {
                "email": email,
                "password": password,
              }).then((response) {
            print(response.body);
            if (response.body == "success") {
              Fluttertoast.showToast(
                  msg:
                      "Registration Success. Please check your email for verification link ",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 2,
                  backgroundColor: Color.fromRGBO(191, 30, 46, 50),
                  textColor: Colors.white,
                  fontSize: 23.0);
              // ignore: dead_code
              Timer(
                  Duration(seconds: 3),
                  () => Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (content) => LoginScreen())));
              return;
            } else {
              Fluttertoast.showToast(
                  msg: "User email already exists. ",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Color.fromRGBO(191, 30, 46, 50),
                  textColor: Colors.white,
                  fontSize: 23.0);
              return;
            }
          });
        } else {
          Fluttertoast.showToast(
              msg: "The password is not match ",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Color.fromRGBO(191, 30, 46, 50),
              textColor: Colors.white,
              fontSize: 23.0);
          return;
        }
      } else {
        Fluttertoast.showToast(
            msg: "Password length should minumum 6 character ",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Color.fromRGBO(191, 30, 46, 50),
            textColor: Colors.white,
            fontSize: 23.0);
        return;
      }
    } else {
      Fluttertoast.showToast(
          msg: "Invalid email address",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromRGBO(191, 30, 46, 50),
          textColor: Colors.white,
          fontSize: 23.0);
      return;
    }
  }
}
