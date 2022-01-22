import 'dart:io';
import 'dart:typed_data';

import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:image/image.dart';
import 'package:page_transition/page_transition.dart';
import 'package:recognize_vehicler/CloudFirestore.dart';
import 'package:recognize_vehicler/HomeScreen.dart';
import 'package:recognize_vehicler/SingletonData.dart';
import 'package:recognize_vehicler/String_Constants.dart';
import 'package:recognize_vehicler/UtilsDialog.dart';
import 'package:recognize_vehicler/vehicle.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:recognize_vehicler/vehicle_off.dart';
import 'package:sqflite/sqflite.dart';

import 'DatabaseUtils.dart';
import 'MainScreen.dart';

class FormInputScreenNoPrinter extends StatefulWidget {
  FormInputScreenNoPrinter({Key key, this.number}) : super(key: key);
  final String number;

  @override
  State<StatefulWidget> createState() {
    return FormInputScreenNoPrinterState();
  }
}

class FormInputScreenNoPrinterState extends State<FormInputScreenNoPrinter> {
  String dateString = "";
  String previousString = "";
  String provinceString = "";
  String numberVihicleString = "";
  String priceVehilce = "";
  int day = 0, month = 0, year = 0;
  SingletonData singletonData = SingletonData();
  var dateController = TextEditingController(text: "");
  var previousController = TextEditingController(text: "");
  var priceController = TextEditingController(text: "");
  var numberController = TextEditingController(text: "");
  var provinceController = TextEditingController(text: "");
  VehicleOff vehicle = new VehicleOff();
  CloudFirestoreUtils utils = CloudFirestoreUtils();
  String pathImage;
  DatabaseUtils databaseUtils = DatabaseUtils();
  Database db ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DateTime date = DateTime.now();
    dateString = '${date.hour}h${date.minute} - ${date.day}/${date.month}/${date.year}';
    dateController.text = dateString;
    numberController.text = widget.number;
    String priceTemp = singletonData.price.toString();
    priceController.text = priceTemp;
    intDatabase();
  }

  void intDatabase() async {
    db =await databaseUtils.database;
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.parking),
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: Text(
                Strings.form_input,
                style: TextStyle(fontSize: 25, color: Colors.black),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      minTime: DateTime(2018, 3, 5),
                      maxTime: DateTime(2050, 1, 1), onConfirm: (date) {
                    dateString = '${date.day}/${date.month}/${date.year}';
                    dateController.text = dateString;
                  }, currentTime: DateTime.now(), locale: LocaleType.en);
                },
                child: TextField(
                  onTap: () {
                    DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        minTime: DateTime(2018, 3, 5),
                        maxTime: DateTime(2050, 1, 1), onConfirm: (date) {
                      vehicle.day = date.day;
                      vehicle.month = date.month;
                      vehicle.year = date.year;
                      dateString = '${date.hour}h${date.minute} - ${date.day}/${date.month}/${date.year}';
                      dateController.text = dateString;
                    }, currentTime: DateTime.now(), locale: LocaleType.en);
                  },
                  onChanged: (text) {
                    dateString = text;
                  },
                  controller: dateController,
                  obscureText: false,
                  style: singletonData.style,
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      hintText: "Date time",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0))),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                keyboardType: TextInputType.number,
                onChanged: (text) {
                  numberVihicleString = text;
                },
                controller: numberController,
                obscureText: false,
                style: singletonData.style,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    hintText: Strings.input_number,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0))),
              ),
            ),
            Padding(
              padding:  EdgeInsets.only(left: MediaQuery.of(context).size.width/2),
              child:RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                color: Colors.blueAccent,
                onPressed: () {
                    setState(() {
                      numberController.text="";
                      numberVihicleString="";
                    });
                },
                child: Text(
                  Strings.clear,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                keyboardType: TextInputType.text,
                onChanged: (text) {
                  previousString = text;
                },
                controller: previousController,
                obscureText: false,
                style: singletonData.style,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    hintText: Strings.previous,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0))),
              ),
            ),
            Padding(
              padding:  EdgeInsets.only(left: MediaQuery.of(context).size.width/2),
              child:RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                color: Colors.blueAccent,
                onPressed: () {
                  setState(() {
                    previousController.text="";
                    previousString="";
                  });
                },
                child: Text(
                  Strings.clear,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                keyboardType: TextInputType.number,
                onChanged: (text) {
                  priceVehilce = text;
                },
                controller: priceController,
                obscureText: false,
                style: singletonData.style,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    hintText: Strings.input_price,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0))),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: InkWell(
                onTap: () async{
                   DateTime dateTime = DateTime.now();
                  print(convertHourAndMinute(15)+convertHourAndMinute(15));
                  print(numberVihicleString);

                   String vehicleIdentify = numberVihicleString;
                   vehicle.numberId = vehicleIdentify;
                   vehicle.day = dateTime.day;
                   vehicle.month = dateTime.month;
                   vehicle.year = dateTime.year;
                   vehicle.minute = dateTime.minute;
                   vehicle.hour = dateTime.hour;
                   vehicle.userId = singletonData.userId;
                   vehicle.price = int.parse(priceController.text);
                   vehicle.previousCharacter = previousString;
                   singletonData.price = vehicle.price;
                   vehicle.editNumber = 0;
                   if(db==null){
                     db = await databaseUtils.database;
                   }
                   var result = await databaseUtils.createVehicle(vehicle, db).then((value) {
                     print("created vehicle");
                   });
                   UtilsDialog.showAlertDialogOk(context,"Created ticket", Strings.notify);

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
                  child: Center(child: Text(Strings.print, style: TextStyle(color: Colors.white, fontSize: 20))),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



  void onCancle(BuildContext context) {
    Navigator.pop(context);
  }


  Future<List<String>> getSuggest(String pattern) async {
    print(pattern);
    List<String> results = [];
    if (pattern.trim().isEmpty) {
      return [];
    }
    for (String string in provinces) {
      if (string.trim().contains(pattern)) {
        results.add(string);
      }
    }
    print(results.length);
    return results;
  }

  Future<Ticket> _ticket(PaperSize paper) async {
    DateTime dateTime = DateTime.now();
    String vehicleIdentify = numberVihicleString;
    vehicle.numberId = vehicleIdentify;
    vehicle.day = dateTime.day;
    vehicle.month = dateTime.month;
    vehicle.year = dateTime.year;
    vehicle.minute = dateTime.minute;
    vehicle.hour = dateTime.hour;
    vehicle.userId = singletonData.userId;
    vehicle.price = int.parse(priceController.text);
    vehicle.previousCharacter = previousString;
    vehicle.editNumber = 0;
    singletonData.price = vehicle.price;
    if(db==null){
      db = await databaseUtils.database;
    }
    await databaseUtils.createVehicle(vehicle, db).then((value) {
      print("created vehicle");
    });
    final ticket = Ticket(paper);
    // Image assets
    final ByteData data = await rootBundle.load('assets/logo_small.jpg');
    final Uint8List bytes = data.buffer.asUint8List();
    var image = decodeImage(bytes);
    ticket.image(image);
    ticket.text(
    Strings.parking_coupon,
      styles: PosStyles(align: PosAlign.center,height: PosTextSize.size2,
          width: PosTextSize.size2),
      linesAfter: 1,
    );
      ticket.text(" ${Strings.bike}: ${previousString}-"+numberVihicleString,
          styles: PosStyles( bold: true, align: PosAlign.left, width: PosTextSize.size2));
    ticket.text(" ${Strings.date}: ${dateTime.day}/${dateTime.month}/${dateTime.year}",
        styles: PosStyles(bold: true, align: PosAlign.left, width: PosTextSize.size2));
    ticket.text(" ${Strings.time}: ${convertHourAndMinute(dateTime.hour)}:${convertHourAndMinute(dateTime.minute)}",
        styles: PosStyles(bold: true, align: PosAlign.left, width: PosTextSize.size2));
    ticket.text("${Strings.price}: ${int.parse(priceController.text)}",
        styles: PosStyles(bold: true, align: PosAlign.left, width: PosTextSize.size2));
    ticket.feed(1);
    ticket.text('Thank You',styles: PosStyles(align: PosAlign.center, bold: true));
    ticket.cut();

    return ticket;
  }

  String convertHourAndMinute(int params){
    if(params>0&&params<10){
      return "0${params}";
    }else{
      return params.toString();
    }
  }

  Future<void> _startPrint(PrinterBluetooth printer) async {
     singletonData.printerManager.selectPrinter(printer);
    final result = await singletonData.printerManager.printTicket(await _ticket(PaperSize.mm58));
    if(result.value == PosPrintResult.printerNotSelected){
      UtilsDialog.showAlertDialogPrintSuccess(context, Strings.device_dont_selected, Strings.notify);
    }
  }
  List<String> provinces = [
    "ນະຄອນຫລວງວຽງຈັນ",
    "ແຂວງຜົ້ງສາລີ",
    "ແຂວງບໍ່ແກ້ວ",
    "​ແຂວງຫລວງນ້ຳທາ",
    "ແຂວງອຸດົມໄຊ",
    "ແຂວງຫລວງພະບາງ",
    "ແຂວງໄຊຍະບູລີ",
    "ແຂວງຫົວພັນ",
    "ແຂວງຊຽງຂວາງ",
    "ແຂວງວຽງຈັນ",
    "ແຂວບໍລິຄຳໄຊ",
    "ແຂວງຄຳມ່ວນ",
    "ແຂວງສະຫວັນນະເຂດ",
    "ແຂວງສາລະວັນ",
    "ແຂວງຈຳປາສັກ",
    "ແຂວງເຊກອງ",
    "ແຂວງອັດຕະປື",
    "ແຂວງໄຊສົມບູນ"
  ];
}
