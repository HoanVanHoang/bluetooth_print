

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:recognize_vehicler/vehicle_off.dart';
import 'package:sqflite/sqflite.dart';

import 'CloudFirestore.dart';
import 'DatabaseUtils.dart';
import 'SingletonData.dart';
import 'String_Constants.dart';

class EditTicket extends StatefulWidget{
  VehicleOff vehicle;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return EditTicketState(this.vehicle);
  }

  EditTicket(this.vehicle);
}

class EditTicketState extends State<EditTicket> {

  String dateString = "";
  String previousString = "";
  String provinceString = "";
  String numberVihicleString = "";
  String priceVehilce = "";
  int day = 0, month = 0, year = 0, minute =0, hour = 0;
  SingletonData singletonData = SingletonData();
  var dateController = TextEditingController(text: "");
  var previousController = TextEditingController(text: "");
  var priceController = TextEditingController(text: "");
  var numberController = TextEditingController(text: "");
  var provinceController = TextEditingController(text: "");
  VehicleOff vehicle = new VehicleOff();
  String pathImage;
  DatabaseUtils databaseUtils = DatabaseUtils();
  Database db ;
   String  oldNumberId = "", oldprevious = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    DateTime date = DateTime.now();
    dateString = '${vehicle.hour}h${vehicle.minute} - ${vehicle.day}/${vehicle.month}/${vehicle.year}';
    dateController.text = dateString;
    numberController.text = vehicle.numberId;
    String priceTemp = singletonData.price.toString();
    priceController.text = vehicle.price.toString();
    previousString = vehicle.previousCharacter;
    previousController.text = vehicle.previousCharacter;
    oldNumberId = vehicle.numberId;
    oldprevious = vehicle.previousCharacter;
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
          title: Text("ແກ້ໄຂປີ້ລົດ"),
          centerTitle: true,
          leading: InkWell(
            onTap: (){
              Navigator.pop(context, true);
            },
              child: Icon(Icons.arrow_back)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
                            day = date.day;
                            month = date.month;
                            year = date.year;
                            minute = date.minute;
                            hour = date.hour;
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
                    String vehicleIdentify = numberController.text;
                    vehicle.numberId = vehicleIdentify;

                    if(day!=0){
                      vehicle.day = day;
                      vehicle.month = month;
                      vehicle.year = year;
                      vehicle.minute = minute;
                      vehicle.hour = hour;
                    }
                    int editNumber = vehicle?.editNumber??0;
                    editNumber+=1;
                    vehicle.editNumber = editNumber;
                    vehicle.userId = singletonData.userId;
                    vehicle.price = int.parse(priceController.text);
                    vehicle.previousCharacter = previousString;
                    singletonData.price = vehicle.price;
                    if(db==null){
                      db = await databaseUtils.database;
                    }
                    await databaseUtils.updateVehicle(vehicle, db, oldNumberId, oldprevious).then((value) {
                      print("updated vehicle");
                      Navigator.pop(context);
                    });
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
                    child: Center(child: Text(Strings.save, style: TextStyle(color: Colors.white, fontSize: 20))),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  EditTicketState(VehicleOff vehicleOff){
      this.vehicle = vehicleOff;
  }
}