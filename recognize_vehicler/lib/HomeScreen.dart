

import 'dart:io';

import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:recognize_vehicler/CameraScreen.dart';
import 'package:recognize_vehicler/ConfigPrice.dart';
import 'package:recognize_vehicler/SingletonData.dart';
import 'package:recognize_vehicler/String_Constants.dart';
import 'package:recognize_vehicler/form_input_screen.dart';
import 'package:recognize_vehicler/form_input_screen_no_print.dart';

import 'Constants.dart';

class HomeScreen extends StatefulWidget {
     HomeScreen({Key key}) : super(key: key);
     @override
      HomeScreenState createState()=>HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>{
  List<PrinterBluetooth> devices = [];
   SingletonData singletonData = SingletonData();

   String devicesMsg = "";
   @override
  void initState() {
    // TODO: implement initState
     super.initState();
     try{
       singletonData.bluetoothManager.isScanning.first.then((value){
         singletonData.bluetoothManager.stopScan();
       });
       if (Platform.isAndroid) {
         singletonData.bluetoothManager.state.listen((val) {
           print('state = $val');
           if (!mounted) return;
           if (val == 12) {
             print('on');
             initPrinter();
           } else if (val == 10) {
             print('off');
             setState(() => devicesMsg = 'Bluetooth Disconnect!');
           }
         });
       } else {
         initPrinter();
       }
     }catch(PlatformException){

     }
  }
  @override
  Widget build(BuildContext context) {
      return Container(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButton(
                      items: _getDeviceItems(),
                      onChanged: (value) => setState(() => singletonData.deviceSelected = value),
                      value: singletonData.deviceSelected,
                    ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                            ),
                            color: Colors.blueAccent,
                            onPressed: () {
                              initPrinter();
                            },
                            child: Text(
                              Strings.refresh,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                  ],
                ),

                InkWell(
                  onTap: (){
                    singletonData.status = Constants.NO_EDITTING;
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.leftToRightWithFade,
                        alignment: Alignment.topCenter,
                        child: FormInputScreen(),
                      ),
                    );
                  },
                  child: Container(
                    width: 200,
                    height: 100,
                    margin: const EdgeInsets.all(30.0),
                    padding: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        border: Border.all(color: Colors.blueAccent),
                         borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    child: Center(child: Text(Strings.input_by_hand, style: TextStyle(color: Colors.white, fontSize: 20))),
                  ),
                ),
                InkWell(
                  onTap: (){
                    singletonData.status = Constants.NO_EDITTING;
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.leftToRightWithFade,
                        alignment: Alignment.topCenter,
                        child: FormInputScreenNoPrinter(),
                      ),
                    );
                  },
                  child: Container(
                    width: 200,
                    height: 100,
                    margin: const EdgeInsets.all(30.0),
                    padding: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        border: Border.all(color: Colors.blueAccent),
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    child: Center(child: Text(Strings.input_by_hand_no_printer, style: TextStyle(color: Colors.white, fontSize: 20))),
                  ),
                ),
                InkWell(
                  onTap: (){
                    singletonData.status = Constants.NO_EDITTING;
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.leftToRightWithFade,
                        alignment: Alignment.topCenter,
                        child: ConfigPrice(),
                      ),
                    );
                  },
                  child: Container(
                    width: 200,
                    height: 50,
                    margin: const EdgeInsets.all(3.0),
                    padding: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        border: Border.all(color: Colors.blueAccent),
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    child: Center(child: Text(Strings.config_price, style: TextStyle(color: Colors.white, fontSize: 20))),
                  ),
                )
              ],
            ),
          ),
        ),
      );
  }
   List<DropdownMenuItem<PrinterBluetooth>> _getDeviceItems() {
     List<DropdownMenuItem<PrinterBluetooth>> items = [];
     if (devices.isEmpty) {
       items.add(DropdownMenuItem(
         child: Text(Strings.none),
       ));
     } else {
       devices.forEach((device) {
         items.add(DropdownMenuItem(
           child: Text(device.name),
           value: device,
         ));
       });
     }
     return items;
   }

  void initPrinter() {
    singletonData.printerManager.startScan(Duration(seconds: 2));
    singletonData.printerManager.scanResults.listen((val) {
      print(val.toString());
      if (!mounted) return;
      setState(() => devices = val);
      if (devices.isEmpty) setState(() => devicesMsg = Strings.no_decvice);
    });
  }

  @override
  void dispose() {
    singletonData.printerManager.stopScan();
    super.dispose();
  }
}