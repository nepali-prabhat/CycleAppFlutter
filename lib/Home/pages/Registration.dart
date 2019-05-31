import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Data {
  String username;
  String email;
  String password;
  String phone_no;
  String address;
  Data({this.username, this.email, this.password, this.phone_no, this.address});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      phone_no: json['phone_no'] as String,
      address: json['address'] as String,
    );
  }
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["username"] = username;
    map["email"] = email;
    map["password"] = password;
    map["phone_no"] = phone_no;
    map["address"] = address;

    return map;
  }
}

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: new Drawer(),
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          "Register Your Account",
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          FloatingActionButton(
              child: Icon(Icons.person_outline),
              backgroundColor: Colors.redAccent,
              onPressed: () => {_scaffoldKey.currentState.openEndDrawer()})
        ],
      ),
      body: MainForm(),
    );
  }
}

///main registration form
class MainForm extends StatefulWidget {
  @override
  _MainFormState createState() => _MainFormState();
}

class _MainFormState extends State<MainForm> {
  // Future<Data> data;
  bool sendPostRequest = false;
  bool success = false;

  Future<Map<String, dynamic>> createPost(String url, {Map body}) async {
    var response = await http.post(url, body: body);
    var jsonData = json.decode(response.body);
    print(response.statusCode);

    return jsonData;
  }

  _MainFormState({Key key});
  static final Url = 'http://192.168.254.4:3000/signup';
  TextEditingController username = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  TextEditingController address = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Material(
            elevation: 1.0,
            child: Container(
              // scolor: Colors.white.withOpacity(0.6),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.8)),
              child: Form(
                key: null,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: <Widget>[
                      new TextFormField(
                          autofocus: false,
                          keyboardType: TextInputType
                              .emailAddress, // Use email input type for emails.
                          controller: email,
                          validator: (val) =>
                              !val.contains('@') ? 'Not a valid email' : null,
                          decoration: new InputDecoration(
                            icon: Icon(Icons.email),
                            labelText: "Email",
                            contentPadding: EdgeInsets.all(10.0),
                            hintText: 'you@example.com',
                          )),
                      SizedBox(
                        height: 30,
                      ),
                      new TextFormField(
                          autofocus: false,
                          keyboardType: TextInputType
                              .text, // Use email input type for emails.
                          controller: username,
                          validator: (val) => val.length < 6
                              ? 'Atleast six character required'
                              : null,
                          decoration: new InputDecoration(
                            icon: Icon(Icons.person_pin_circle),
                            labelText: "Username",
                            contentPadding: EdgeInsets.all(10.0),
                            hintText: 'karunkop',
                          )),
                      SizedBox(
                        height: 30,
                      ),
                      new TextFormField(
                          autofocus: false,
                          keyboardType: TextInputType
                              .phone, // Use email input type for emails.
                          controller: phone,
                          validator: (val) => val.length == 10
                              ? null
                              : "phone no requires 10 digits",
                          decoration: new InputDecoration(
                            icon: Icon(Icons.phone),
                            labelText: "Phone_no",
                            contentPadding: EdgeInsets.all(10.0),
                            hintText: '+977 9861538501',
                          )),
                      SizedBox(
                        height: 30,
                      ),
                      new TextFormField(
                          autofocus: false,
                          keyboardType: TextInputType
                              .text, // Use email input type for emails.
                          controller: password,
                          validator: (val) => val.length < 6
                              ? 'Atleast six character required'
                              : null,
                          obscureText: true,
                          decoration: new InputDecoration(
                            icon: Icon(Icons.vpn_key),
                            labelText: "Password",
                            contentPadding: EdgeInsets.all(10.0),
                            hintText: 'Password',
                          )),
                      SizedBox(
                        height: 30,
                      ),
                      new TextFormField(
                          autofocus: false,
                          keyboardType: TextInputType
                              .text, // Use email input type for emails.
                          controller: address,
                          decoration: new InputDecoration(
                            icon: Icon(Icons.home),
                            labelText: "Address",
                            contentPadding: EdgeInsets.all(10.0),
                            hintText: '28 kilo , Dhulikhel',
                          )),
                      SizedBox(
                        height: 25,
                      ),
                      Builder(
                        builder: (context) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  sendPostRequest = true;
                                });
                              },
                              child: new Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 100),
                                decoration: BoxDecoration(
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                        color: Colors.red,
                                        offset: Offset(1.0, 6.0),
                                        blurRadius: 5.0,
                                      ),
                                    ],
                                    color: Colors.redAccent,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Text(
                                  "Register",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      sendPostRequest
                          ? FutureBuilder(
                              future: createPost(Url,
                                  body: new Data(
                                          username: username.text,
                                          email: email.text,
                                          password: password.text,
                                          phone_no: phone.text,
                                          address: address.text)
                                      .toMap()),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                }
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  if (snapshot.hasError) {
                                    return Text("Something went Wrong");
                                  } else if (snapshot.hasData) {
                                    print(snapshot.data);
                                    var response = snapshot.data;
                                    String key;
                                    for (var key in response.keys) {
                                      key = key;
                                      print(key);
                                    }

                                    for (var value in response.values) {
                                      int l = response.length;

                                      return Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 15),
                                        decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(0.2),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        child: Text(
                                          value.toString(),
                                          textAlign: TextAlign.center,
                                          style: l == 1
                                              ? TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 20,
                                                  fontFamily:
                                                      "Roboto-Light.ttf",
                                                )
                                              : TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 20,
                                                  fontFamily:
                                                      "Roboto-Light.ttf",
                                                ),
                                        ),
                                      );
                                    }
                                  }
                                }
                              })
                          : Container(),
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        "Or",
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.grey,
                            fontFamily: 'Roboto-Light.ttf'),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Sign In With",
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.grey,
                            fontFamily: 'Roboto-Light.ttf'),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          CircleAvatar(
                            maxRadius: 25,
                            child: Image.asset(
                              'assets/images/fb.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                          CircleAvatar(
                            maxRadius: 25,
                            child: Image.asset(
                              'assets/images/google.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
