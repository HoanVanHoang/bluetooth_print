import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:recognize_vehicler/DatabaseUtils.dart';
import 'package:recognize_vehicler/SingletonData.dart';
import 'package:recognize_vehicler/SplashScreen.dart';
import 'package:recognize_vehicler/form_input_screen.dart';
import 'package:recognize_vehicler/vehicle.dart';
import 'package:sqflite/sqflite.dart';

Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    SingletonData singletonData = SingletonData();
    await Firebase.initializeApp();
    try {
      singletonData.cameras = await availableCameras();
    } on CameraException catch (e) {
      print(e);
    }
    runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ML Vision',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashSc(),
    );
  }
}

