import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreen createState() => new _ProfileScreen();
}
class _ProfileScreen extends State<ProfileScreen> {

  StreamSubscription _subscriptionTodo;
  static String routeName = "/profile";
  String _Name = "Display the Name here";
  String _PhoneNumber = "Display the Phone Number here";
  String _Address = "Display the Address here";
  String _name="";
  String _phonenumber="";
  String _address="";

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

  Future<void> addProfile(String name, String phonenumber, String address) async {
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

  @override
  Widget build(BuildContext context) {
    void pri()
    {
      print(_Name);
      print(_PhoneNumber);
    }
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
                  borderSide: new BorderSide(
                  ),
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
                  borderSide: new BorderSide(
                  ),
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
                  borderSide: new BorderSide(
                  ),
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
                  addProfile(_name, _phonenumber, _address);
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
            )
          ],
        ),
      ),
    );
  }
  _updateTodo(Account value) {
    var name = value.name;
    var phonenumber = value.phonenumber;
    var address = value.address;
    setState((){
      _Name = name;
      _PhoneNumber=phonenumber;
      _Address=address;
    });
  }
}



class Account {
  String name;
  String phonenumber;
  String address;
  Account(String _name,String _phonenumber,String _address)
  {
    name=_name;
    phonenumber=_phonenumber;
    address=_address;
  }
}



class FirebaseProfile {
  /// FirebaseTodos.getTodoStream("-KriJ8Sg4lWIoNswKWc4", _updateTodo)
  /// .then((StreamSubscription s) => _subscriptionTodo = s);
  static Future<void> getProfileStream(
      void onData(Account account)) async {
    String accountKey = FirebaseAuth.instance.currentUser.uid;

    print(accountKey);

    var db = FirebaseDatabase.instance.reference().child("accounts").orderByChild(
        "UID").equalTo(accountKey);
    db.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      if(values==null)
        {
          var account = new Account("Nhập tên","Nhập số điện thoại","Nhập địa chỉ");
          onData(account);
          return;
        }
      values.forEach((key, values) {
        var account = new Account(
            values["Name"], values["PhoneNumber"], values["Address"]);
        onData(account);
        return;
      }
      );
    }
    );
  }
}




