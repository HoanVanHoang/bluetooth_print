import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recognize_vehicler/SingletonData.dart';

import 'CloudFirestore.dart';
import 'image_detail.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController _controller;
  List<CameraDescription> cameras = [];
  SingletonData singletonData = SingletonData();
  @override
  void initState() {
    super.initState();
     initCamera();
  }
  Future<void> initCamera() async{
    try {
      _controller = CameraController(singletonData.cameras[0], ResolutionPreset.high);
      _controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    } on CameraException catch (e) {
      print(e);
    }
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<String> _takePicture() async {
    if (!_controller.value.isInitialized) {
      print("Controller is not initialized");
      return null;
    }

    // Formatting Date and Time
    String dateTime = DateFormat.yMMMd()
        .addPattern('-')
        .add_Hms()
        .format(DateTime.now())
        .toString();

    String formattedDateTime = dateTime.replaceAll(' ', '');
    print("Formatted: $formattedDateTime");

    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String visionDir = '${appDocDir.path}/Photos/Vision\ Images';
    await Directory(visionDir).create(recursive: true);
    final String imagePath = '$visionDir/image_$formattedDateTime.jpg';

    if (_controller.value.isTakingPicture) {
      print("Processing is progress ...");
      return null;
    }

    try {
      await _controller.takePicture(imagePath);
    } on CameraException catch (e) {
      print("Camera Exception: $e");
      return null;
    }

    return imagePath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ML Vision'),
      ),
      body: _controller.value.isInitialized
          ? Stack(
              children: <Widget>[
                CameraPreview(_controller),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: RaisedButton.icon(
                      icon: Icon(Icons.camera),
                      label: Text("Click"),
                      onPressed: () async {
                        await _takePicture().then((String path) {
                          if (path != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailScreen(path),
                              ),
                            );
                          }
                        });
                      },
                    ),
                  ),
                )
              ],
            )
          : Container(
              color: Colors.black,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }
}
