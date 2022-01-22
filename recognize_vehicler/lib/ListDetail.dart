

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:recognize_vehicler/CloudFirestore.dart';
import 'package:recognize_vehicler/SingletonData.dart';
import 'package:recognize_vehicler/edit_ticket_vehicle.dart';
import 'package:recognize_vehicler/vehicle.dart';
import 'package:recognize_vehicler/vehicle_off.dart';
import 'package:sqflite/sqflite.dart';

import 'Constants.dart';
import 'DatabaseUtils.dart';

class ListDetail extends StatefulWidget{
  @override
  _ListDetailState createState() => _ListDetailState();
}

class _ListDetailState extends State<ListDetail> {
  List<VehicleOff> vehicles = List();
  VehicleOff vehicle = VehicleOff();
  var dateController = TextEditingController();
  CloudFirestoreUtils utils = CloudFirestoreUtils();
  String dateString = "";
  String moneyCon = "";
  String numberVehicle = "";
  var moneyController = TextEditingController();
  var numbervehicle = TextEditingController();
  int statusData = 0 ; // 1 is loading , 2 no have data , 3 have data
  SingletonData singletonData = SingletonData();
  DatabaseUtils databaseUtils = DatabaseUtils();
  Database db ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DateTime dateTime = new DateTime.now();
    intDatabase();
    setState(() {
      statusData = 1;
      dateController.text = "${dateTime.day}/${dateTime.month}/${dateTime.year}";
      getListVehicle(dateTime.day, dateTime.month, dateTime.year);
    });
  }
  @override
  Widget build(BuildContext context) {
     var singletonData = SingletonData();
     return Container(
       width: MediaQuery.of(context).size.width,
       height: 500,
       child: Column(
         children: [
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: TextField(
               onTap: () {
                 DatePicker.showDatePicker(context,
                     showTitleActions: true,
                     minTime: DateTime(2018, 3, 5),
                     maxTime: DateTime(2050, 1, 1),
                     onConfirm: (date) {
                       vehicle.day = date.day;
                       vehicle.month = date.month;
                       vehicle.year = date.year;
                       getListVehicle(date.day, date.month, date.year);
                       dateString = '${date.day}/${date.month}/${date.year}';
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
           Row(
             children: [
               Padding(
                 padding: const EdgeInsets.only(left: 8.0),
                 child: Text("ຈຳ ນວນຍານພາຫະນະ: "),
               ),
               Expanded(child: Padding(
                 padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                 child: TextField(
                     controller: numbervehicle,
                     enabled: false,
                     decoration: InputDecoration(
                         contentPadding:
                         EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                         hintText: "",
                         border: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(5.0)))
                 ),
               ))
             ],
           ),
           Row(
             children: [
               Padding(
                 padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                 child: Text("ຈຳ ນວນເງິນທັງ ໝົດ: "),
               ),
               Expanded(child: Padding(
                 padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                 child: TextField(
                     controller: moneyController,
                     enabled: false,
                     decoration: InputDecoration(
                         contentPadding:
                         EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                         hintText: "",
                         border: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(5.0)))
                 ),
               ))
             ],
           )
           , Expanded(child: getWidget(statusData))
         ],
       ),
     );
  }

  Widget getWidget(int status){
     print("get widget ${status}" );
      switch(status){
        case 0:
          break;
        case 1:
          return Center(
            child: SizedBox(
              height: 40,
              width: 40,
              child: CircularProgressIndicator(
                value: 40,
              ),
            ),
          );
        case 2:  return Center(
          child: Text("No have data for search"),
        );
        case 3:
          return ListView.separated(
            separatorBuilder: (context, index) => Divider(
              color: Colors.black,
            ),
            itemCount: vehicles.length,
            itemBuilder: (context, index){
              return GestureDetector(
                onTap: (){
                  singletonData.status = Constants.EDITING;
                 var result = Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditTicket(vehicles[index])),
                  ).then((value) {
                    print("returned");
                    intDatabase();
                    DateTime dateTime = new DateTime.now();
                    setState(() {
                      statusData = 1;
                      dateController.text = "${dateTime.day}/${dateTime.month}/${dateTime.year}";
                      getListVehicle(dateTime.day, dateTime.month, dateTime.year);
                    });
                 });
                },
                child: ListTile(
                  title: Text( " ${index+1}. ${vehicles[index].previousCharacter} " +vehicles[index]?.numberId??""),
                  trailing: Text('ແກ້ໄຂ ${vehicles[index].editNumber} ຄັ້ງ'),
                ),
              );
            },
          );
      }
  }

  void intDatabase() async {
    db =await databaseUtils.database;
  }

  void getListVehicle(int day, int month, int year) async{
    print("get vehicle ${day}" );
    setState(() {
      statusData =1;
    });
    if(db ==null){
      db = await databaseUtils.database;
    }
    if(db!=null){
     await databaseUtils.getListVehicle(db, day, month, year, singletonData.userId).then((value) {
        print("get vehicle success ${value.length}" );
        setState(() {
          if(value.length>0) {
            statusData = 3;
            vehicles.clear();
            vehicles = value;
            int number = 0;
            int price = 0;
            vehicles.forEach((element) {
              number ++;
              price+=element.price;
            });
            numbervehicle.text = number.toString();
            moneyController.text= price.toString();
          }else {
            numbervehicle.text = "0";
            moneyController.text= "0";
            statusData = 2;
          }
        });
      }).catchError((onError){

      });
    }
  }

}