import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/rendering.dart';
import 'cartscreen.dart';
import 'historyscreen.dart';
import 'loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hismart/menuscreen.dart';
import 'package:hismart/profilescreen.dart';
import 'package:provider/provider.dart';
import 'Model/cart.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:hismart/Widgets/endDrawer.dart';

class HomeScreen extends StatefulWidget {
  final String username;
  final int intMethod;

  HomeScreen({Key key, @required this.username, @required this.intMethod})
      : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    MenuScreen(),
    CartScreen(),
    HistoryScreen(),
    ProfileScreen()
  ];
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      Fluttertoast.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "      Black Stone Coffee",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      endDrawer: Drawer(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              color: Colors.blue,
              child: Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage('assets/images/account.png'),
                            fit: BoxFit.fill,
                          )),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text(
                'Profile',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.push(context, new MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.help_outline),
              title: Text(
                'About',
                style: TextStyle(fontSize: 18),
              ),
              onTap: null,
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text(
                'Log out',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () async {
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
                Fluttertoast.showToast(
                    msg: "Logged out",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black54,
                    textColor: Colors.white,
                    fontSize: 16.0,
                );
              },
            ),
          ],
        ),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text('Home'),
            backgroundColor: Colors.lightBlueAccent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            title: Text('Cart'),
            backgroundColor: Colors.lightBlueAccent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            title: Text('History'),
            backgroundColor: Colors.lightBlueAccent,
          ),
        ],
      ),
    );
  }
}
