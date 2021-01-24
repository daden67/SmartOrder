import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreen createState() => new _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen> {
  StreamSubscription _subscriptionTodo;
  static String routeName = "/profile";
  String _Name = "";
  String _PhoneNumber = "";
  String _Address = "";
  String _name = "";
  String _phonenumber = "";
  String _address = "";

  @override
  void initState() {
    FirebaseProfile.getProfileStream(_updateTodo);
    super.initState();
  }

  @override
  void dispose() {
    if (_subscriptionTodo != null) {
      _subscriptionTodo.cancel();
    }
    super.dispose();
  }

  Future<void> addProfile(
      String name, String phonenumber, String address) async {
    final url = 'https://hismart-4d4ea.firebaseio.com/accounts.json';
    String uid = FirebaseAuth.instance.currentUser.uid;

    try {
      final response = await http.post(url,
          body: json.encode({
            'Name': name,
            'PhoneNumber': phonenumber,
            'Address': address,
            'UID': uid
          }));
    } catch (err) {
      throw err;
    }
  }

  void RemoveProfile() {
    String accountKey = FirebaseAuth.instance.currentUser.uid;

    print(accountKey);
    FirebaseDatabase.instance
        .reference()
        .child('accounts')
        .orderByChild('UID')
        .equalTo(accountKey)
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> children = snapshot.value;
      children.forEach((key, value) {
        FirebaseDatabase.instance
            .reference()
            .child('accounts')
            .child(key)
            .remove();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    void init() {
      this._name = _Name;
      this._phonenumber = _PhoneNumber;
      this._address = _Address;
      print(_Name);
      print(_PhoneNumber);
      print(_Address);
    }

    init();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20),
            TextFormField(
              onChanged: (value) {
                print(value);
                this._name = value;
              },
              controller: TextEditingController(text: _Name),
              //initialValue: _Name,
              decoration: new InputDecoration(
                labelText: "Name",
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                  borderSide: new BorderSide(),
                ),
                //fillColor: Colors.green
              ),
              style: new TextStyle(
                fontFamily: "Poppins",
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              onChanged: (value) {
                print(value);
                this._phonenumber = value;
              },
              controller: TextEditingController(text: _PhoneNumber),
              decoration: new InputDecoration(
                labelText: "Phone Number",
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                  borderSide: new BorderSide(),
                ),
                //fillColor: Colors.green
              ),
              style: new TextStyle(
                fontFamily: "Poppins",
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              onChanged: (value) {
                print(value);
                this._address = value;
              },
              controller: TextEditingController(text: _Address),
              decoration: new InputDecoration(
                labelText: "Address",
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                  borderSide: new BorderSide(),
                ),
                //fillColor: Colors.green
              ),
              style: new TextStyle(
                fontFamily: "Poppins",
              ),
            ),
            SizedBox(height: 30),
            Container(
              height: 40,
              width: MediaQuery.of(context).size.width * 0.3,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(50),
              ),
              child: FlatButton(
                onPressed: () {
                  RemoveProfile();
                  addProfile(_name, _phonenumber, _address);
                  setState(() {
                    _Name = _name;
                    _PhoneNumber = _phonenumber;
                    _Address = _address;
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                    Fluttertoast.showToast(
                      msg: "Saved",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.lightBlueAccent,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  });
                },
                child: Container(
                  padding: EdgeInsets.only(
                    top: 7,
                  ),
                  child: Text(
                    "Save",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 400,right: 20),
                child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(
                        50,
                      ),
                      topRight: Radius.circular(
                        50,
                      ),
                      bottomLeft: Radius.circular(
                        50,
                      ),
                      bottomRight: Radius.circular(
                        50,
                      ),
                    ),
                  ),
                  padding: EdgeInsets.all(10),
                  child: IconButton(
                      iconSize: 40,
                      color: Colors.black,
                      icon: Icon(Icons.home),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      }),
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }

  _updateTodo(Account value) {
    var name = value.name;
    var phonenumber = value.phonenumber;
    var address = value.address;
    setState(() {
      _Name = name;
      _PhoneNumber = phonenumber;
      _Address = address;
    });
  }
}

class Account {
  String name;
  String phonenumber;
  String address;

  Account(String _name, String _phonenumber, String _address) {
    name = _name;
    phonenumber = _phonenumber;
    address = _address;
  }
}

class FirebaseProfile {
  /// FirebaseTodos.getTodoStream("-KriJ8Sg4lWIoNswKWc4", _updateTodo)
  /// .then((StreamSubscription s) => _subscriptionTodo = s);
  static Future<void> getProfileStream(void onData(Account account)) async {
    String accountKey = FirebaseAuth.instance.currentUser.uid;

    print(accountKey);

    var db = FirebaseDatabase.instance
        .reference()
        .child("accounts")
        .orderByChild("UID")
        .equalTo(accountKey);
    db.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      if (values == null) {
        var account = new Account("", "", "");
        onData(account);
        return;
      }
      values.forEach((key, values) {
        var account = new Account(
            values["Name"], values["PhoneNumber"], values["Address"]);
        onData(account);
        return;
      });
    });
  }
}
