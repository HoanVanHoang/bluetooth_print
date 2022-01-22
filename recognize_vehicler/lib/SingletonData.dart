




import 'package:camera/camera.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'package:recognize_vehicler/Constants.dart';
import 'package:recognize_vehicler/user.dart';

class SingletonData {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  static final SingletonData _singleton = SingletonData._internal();
  List<PrinterBluetooth> devices = [];
  PrinterBluetooth deviceSelected = null;
  String devicesMsg;
  BluetoothManager bluetoothManager = BluetoothManager.instance;
  PrinterBluetoothManager printerManager = PrinterBluetoothManager();
  List<User> listUser = new List();
  int userId = 0;
  int price = 0;
  int status = Constants.NO_EDITTING;
  List<CameraDescription> cameras = [];
  factory SingletonData() {
    return _singleton;
  }

  SingletonData._internal();
}