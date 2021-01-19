import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/rendering.dart';
import 'cartscreen.dart';
import 'loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hismart/menuscreen.dart';
import 'package:hismart/profilescreen.dart';
import 'package:provider/provider.dart';
import 'Model/cart.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  final String username;
  final int intMethod;

  HomeScreen({Key key, @required this.username, @required this.intMethod}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    MenuScreen(),
    CartScreen(),
    ProfileScreen()
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }



  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title:  Text("      Black Stone Coffee",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              switch (widget.intMethod) {
                case 2:
                  await googleSignIn.disconnect();
                  await googleSignIn.signOut();
                  break;
                case 3:
                  await LoginScreen.facebookSignIn.logOut();
                  break;
              }
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                      (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text('Home'),
            backgroundColor: Colors.redAccent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            title: Text('Cart'),
            backgroundColor: Colors.redAccent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile'),
            backgroundColor: Colors.redAccent,
          )
        ],
      ),
    );
  }
}

