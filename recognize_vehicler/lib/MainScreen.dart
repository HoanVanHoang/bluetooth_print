import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:recognize_vehicler/HomeScreen.dart';
import 'package:recognize_vehicler/ListDetail.dart';
import 'package:recognize_vehicler/LoginScreen.dart';
import 'package:recognize_vehicler/UtilsDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'CloudFirestore.dart';
import 'Constants.dart';
import 'SingletonData.dart';
import 'String_Constants.dart';

class MainScreen extends StatefulWidget {
  @override
  MainState createState() => MainState();
}

class MainState extends State<MainScreen> {
  DateTime currentBackPressTime;
  CloudFirestoreUtils utils = CloudFirestoreUtils();
  final databaseReference = FirebaseFirestore.instance;
  SharedPreferences _prefs;
  SingletonData singletonData = SingletonData();
  Map data;
  var _selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(singletonData.status == Constants.EDITING){
      _selectedIndex = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.parking),
      ),
      body: WillPopScope(
          onWillPop: onWillPop, child: _widgetOptions[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: Strings.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: Strings.Inventory,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.login),
            label: Strings.log_out,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  Future<void> _onItemTapped(int index) async {
    if (index == 2) {
      _prefs = await SharedPreferences.getInstance();
      _prefs.setString("username", "");
      _prefs.setString("password", "");
      _prefs.setString("username", "");
      _prefs.setBool("isLogin", false);
      UtilsDialog.showAlertDialogOkanCancelForLogout(
          context, Strings.do_you_want, Strings.confirm_dialog, () {
        Navigator.pushReplacement(
          context,
          PageTransition(
            type: PageTransitionType.leftToRightWithFade,
            alignment: Alignment.topCenter,
            child: Login(),
          ),
        );
      }, () {
            Navigator.pop(context);
            setState(() {
              _selectedIndex = 0;
            });
      });
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    ListDetail(),
    Text(
      '',
      style: optionStyle,
    ),
  ];

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Toast.show("Click again to exit app", context);
      return Future.value(false);
    }
    exit(0);
  }
}
