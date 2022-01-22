
import 'dart:math';

import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:recognize_vehicler/CloudFirestore.dart';
import 'package:recognize_vehicler/MainScreen.dart';
import 'package:recognize_vehicler/SingletonData.dart';
import 'package:recognize_vehicler/UtilsDialog.dart';
import 'package:recognize_vehicler/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'String_Constants.dart';

class Login extends StatefulWidget {
  Login({Key key, this.title}) : super(key: key);
  final String title;
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController userNameController = new TextEditingController(text: "");
  TextEditingController passWordController = new TextEditingController(text: "");
  CloudFirestoreUtils utils = new CloudFirestoreUtils();
  SingletonData singletonData= SingletonData();
  String username= "", pass= "";
  List<User> users = List();
  SharedPreferences _prefs;
  @override
  initState() {
    // TODO: implement initState
    super.initState();
    getListUser();

  }
  @override
  Widget build(BuildContext context) {
    final emailField = TextField(
      onChanged: (text){
        username = text;
      },
      controller: userNameController,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final passwordField = TextField(
      controller: passWordController,
      onChanged: (text){
        pass = text;
      },
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
           await checkLogin(context);
        },
        child: Text(Strings.login,
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 155.0,
                    child: Image.asset(
                      "assets/logo.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 45.0),
                  emailField,
                  SizedBox(height: 25.0),
                  passwordField,
                  SizedBox(
                    height: 35.0,
                  ),
                  loginButon,
                  SizedBox(
                    height: 15.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> checkLogin(BuildContext context) async {
    DateTime dateTime = DateTime.now();
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    _prefs = await SharedPreferences.getInstance();
    pass = passWordController.text.trim();
    username= userNameController.text.trim();
    if(username!=null&&username.isNotEmpty){
      bool match = false;
      users.forEach((element) {
        print(element.password+"  "+pass+" "+username);
        if(element.username.trim()==username.trim()){
          if(element.password.trim()==pass.trim()){
            _prefs.setInt("user_id", element.userId);
            _prefs.setString("username", element.username);
            _prefs.setString("password", element.password);
            _prefs.setBool("isLogin", true);
            _prefs.setString("full_name", element.fullName);
            _prefs.setString("last_time", dateTime.toString());
            singletonData.userId = element.userId;
            print(singletonData.userId);
            element.device= androidInfo.model+androidInfo.id;
            utils.updateLogin(element.device, element.id, dateTime.toString());
            match=true;
            // Director to Main screen
            // return;
          }
        }
        // Account not exist

      });
      if(match){
        Navigator.pushReplacement(
          context,
          PageTransition(
            type: PageTransitionType.leftToRightWithFade,
            alignment: Alignment.topCenter,
            child: MainScreen(),
          ),
        );
      } else{
        // print("add hereeeeee");
        UtilsDialog.showAlertDialogOk(context, Strings.account_incorrect, Strings.error);
      }
    }
  }
  Future<bool> getListUser() async {
   utils.getListUser().then((value){
     print("Size user: ${value.length}");
     if(value!=null&&value.isNotEmpty){
       users = value;
     }
   });
  }
}