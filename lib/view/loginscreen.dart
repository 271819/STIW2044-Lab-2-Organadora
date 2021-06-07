import 'package:flutter/material.dart';
import 'package:organadora/view/food/orgproducts.dart';
import 'package:organadora/view/mainscreen.dart';
import 'package:organadora/view/registerscreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:organadora/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _remember = false;
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  SharedPreferences prefs;

  @override
  void initState() {
    loadPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        body: Center(
            child: SingleChildScrollView(
                child: Column(
          children: [
            Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Image.asset('assets/images/organadora.png', scale: 0.9)),
            Card(
              elevation: 20,
              color: Colors.lightGreenAccent[400],
              margin: EdgeInsets.fromLTRB(30, 0, 30, 15),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                child: Column(
                  children: [
                    Text("Login",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30)),
                    SizedBox(height: 15),
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
                    SizedBox(height: 15),
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
                        obscureText: true,
                        controller: _passwordController,
                      ),
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: _remember,
                          onChanged: (bool value) {
                            _onChange(value);
                          },
                        ),
                        Text(
                          "Remember Me",
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      minWidth: 240,
                      height: 55,
                      color: Colors.blueAccent,
                      child: Text(
                        "Login",
                        style: TextStyle(fontSize: 23, color: Colors.white),
                      ),
                      onPressed: _onlogin,
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              child: Text("Register New Account",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      decoration: TextDecoration.underline)),
              onTap: _registernewUser,
            ),
            SizedBox(height: 6),
            GestureDetector(
              child: Text("Forgot Password",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      decoration: TextDecoration.underline)),
              onTap: _forgotpassword,
            )
          ],
        ))),
      ),
    );
  }

  void _registernewUser() {
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => RegisterScreen()));
  }

  void _forgotpassword() {
    TextEditingController _newemail = new TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Forgot Your Password?", style: TextStyle(fontSize: 25)),
          content: new Container(
            height: 150,
            child: Column(
              children: [
                SizedBox(height: 15),
                Text("Enter your recovery email",
                    style: TextStyle(fontSize: 21)),
                SizedBox(height: 10),
                TextField(
                  controller: _newemail,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email",
                    icon: Icon(Icons.email),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text("Submit"),
              onPressed: () {
                print(_newemail.text);
                _resetPassword(_newemail.text.toString());
                Navigator.of(context).pop();
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

  void _resetPassword(String emailreset) {
    http.post(
        Uri.parse(
            "https://crimsonwebs.com/s271819/organadora/php/reset_user.php"),
        body: {"email": emailreset}).then((response) {
      print("Email reset " + emailreset);
      print(response.body);
     
    });
  }

  void _onlogin() {
    String email = _emailController.text.toString();
    String password = _passwordController.text.toString();
    http.post(
        Uri.parse(
            "https://crimsonwebs.com/s271819/organadora/php/login_user.php"),
        body: {
          "email": email,
          "password": password,
        }).then((response) {
      print(response.body);
      print(email + " " + password);
      if (response.body == "failed") {
        Fluttertoast.showToast(
            msg: "Login Failed ",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Color.fromRGBO(191, 30, 46, 50),
            textColor: Colors.white,
            fontSize: 23.0);
      } else {
        Fluttertoast.showToast(
            msg: "Login Success ",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Color.fromRGBO(191, 30, 46, 50),
            textColor: Colors.white,
            fontSize: 23.0);
        List userdata = response.body.split(",");
        User user = User(
            email: email,
            password: password,
            // name: userdata[1],
            datereg: userdata[2],
            rating: userdata[3],
            credit: userdata[4],
            status: userdata[5]);
        Navigator.push(context,
            MaterialPageRoute(builder: (content) => OrgProductsScreen(user: user)));
            //MaterialPageRoute(builder: (content) => MainScreen(user: user)));
      }
    });
  }

  void _onChange(bool value) {
    String _email = _emailController.text.toString();
    String _password = _passwordController.text.toString();

    if (_email.isEmpty || _password.isEmpty) {
      Fluttertoast.showToast(
          msg: "Email/password is empty",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Color.fromRGBO(191, 30, 46, 50),
          textColor: Colors.white,
          fontSize: 23.0);
      return;
    }
    setState(() {
      _remember = value;
      storePref(value, _email, _password);
    });
  }

  Future<void> storePref(bool value, String email, [String password]) async {
    prefs = await SharedPreferences.getInstance();
    if (value) {
      await prefs.setString("email", email);
      await prefs.setString("password", password);
      await prefs.setBool("rememberme", value);
      Fluttertoast.showToast(
          msg: "Your information is stored",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromRGBO(191, 30, 46, 50),
          textColor: Colors.white,
          fontSize: 23.0);
      return;
    } else {
      await prefs.setString("email", '');
      await prefs.setString("password", '');
      await prefs.setBool("rememberme", value);
      Fluttertoast.showToast(
          msg: "Your information is removed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromRGBO(191, 30, 46, 50),
          textColor: Colors.white,
          fontSize: 23.0);
      setState(() {
        _emailController.text = "";
        _passwordController.text = "";
        _remember = false;
      });
      return;
    }
  }

  Future<void> loadPref() async {
    prefs = await SharedPreferences.getInstance();
    String _email = prefs.getString("email") ?? '';
    String _password = prefs.getString("password") ?? '';
    _remember = prefs.getBool("remember") ?? false;

    setState(() {
      _emailController.text = _email;
      _passwordController.text = _password;
    });
  }
}
