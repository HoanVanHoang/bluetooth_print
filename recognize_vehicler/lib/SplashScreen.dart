import 'dart:async';
import 'dart:ui';

import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:recognize_vehicler/LoginScreen.dart';
import 'package:recognize_vehicler/MainScreen.dart';
import 'package:recognize_vehicler/SingletonData.dart';
import 'package:recognize_vehicler/UtilsDialog.dart';
import 'package:recognize_vehicler/user.dart';
import 'package:recognize_vehicler/vehicle_off.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'String_Constants.dart';
import 'CloudFirestore.dart';
import 'DatabaseUtils.dart';

class SplashSc extends StatelessWidget {
  SingletonData singletonData = SingletonData();
  CloudFirestoreUtils utils = new CloudFirestoreUtils();

  @override
  Widget build(BuildContext context) {
    check(context);
    // testDb();
    return Center(
        child: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.blue, Colors.red])),
      child: Center(
          child: Icon(
        Icons.qr_code,
        color: Colors.white,
        size: 120,
      )),
    ));
  }
  Future<void> testDb() async{
    DatabaseUtils databaseUtils = DatabaseUtils();
    Database db = await databaseUtils.database;
    VehicleOff vehicle = new VehicleOff();
    vehicle.numberId = "vehicleIdentify";
    vehicle.day = 24;
    vehicle.month = 2;
    vehicle.year = 2021;
    vehicle.userId = 1;
    vehicle.price = 2000;
    await databaseUtils.createVehicle(vehicle, db);
    List<VehicleOff> vehicles = await databaseUtils.getListVehicle(db, 1, 1, 1,1);
    print(vehicles.length);
  }
  Future<bool> check(BuildContext context) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    print(
        'Running on ${androidInfo.model} ${androidInfo.id} ${androidInfo.device} ${androidInfo.manufacturer} '
        '${androidInfo.hardware} ${androidInfo.product}'); // e.g. "Moto G (4)"
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String name = _prefs.get("username");
    String passWord = _prefs.getString("password");
    String fullName = _prefs.getString("full_name");
    String lastTime = _prefs.getString("last_time");
    String device = _prefs.getString("device_info");
    int role = _prefs.getInt("role");
    bool isLoged = _prefs.get("isLogin");
    int userId = _prefs.get("user_id");
    singletonData.userId = userId;
    List<User> users = await utils.getListUserByUserId(userId);
    if (users.length>0&&users[0].device!=null&&!(users[0].device.trim() == (androidInfo.model + androidInfo.id))) {
      _prefs.setString("username", "");
      _prefs.setString("password", "");
      _prefs.setString("username", "");
      _prefs.setBool("isLogin", false);
      isLoged = false;
      UtilsDialog.showAlertDialogLoginAgain(
          context,
          Strings.notify,
          Strings.logined_another, () {
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.leftToRightWithFade,
            alignment: Alignment.topCenter,
            child: Login(),
          ),
        );
      });
    }
   else if (isLoged != null && isLoged) {
      await utils.getListUserByUserName(name).then((values) {
        if (values.length > 0 && values[0].password.trim() == passWord.trim()) {
          Timer(Duration(seconds: 2), () {
            print("login success");
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.leftToRightWithFade,
                alignment: Alignment.topCenter,
                child: MainScreen(),
              ),
            );
          });
        } else {
          Timer(Duration(seconds: 2), () {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.leftToRightWithFade,
                alignment: Alignment.topCenter,
                child: Login(),
              ),
            );
          });
        }
      });
    } else {
      Timer(Duration(seconds: 2), () {
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.leftToRightWithFade,
            alignment: Alignment.topCenter,
            child: Login(),
          ),
        );
      });
    }
  }

  void loginAgain(BuildContext context) {
    Timer(Duration(seconds: 2), () {
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.leftToRightWithFade,
          alignment: Alignment.topCenter,
          child: Login(),
        ),
      );
    });
  }
}
