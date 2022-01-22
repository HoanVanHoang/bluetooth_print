

import 'package:flutter/cupertino.dart';
import 'package:recognize_vehicler/CloudFirestore.dart';
import 'package:recognize_vehicler/SingletonData.dart';
import 'package:recognize_vehicler/vehicle.dart';

class InventoryDaily extends StatefulWidget {
  InventoryDaily({Key key}) : super(key: key);
  InventoryDailyState  createState() => InventoryDailyState();
}

class InventoryDailyState extends State<InventoryDaily> {
  CloudFirestoreUtils utils = CloudFirestoreUtils();
  List<Vehicle> vehicles = List();
  double sumMonney = 0.0;
  int sumVehicle = 0;
  double sumMonneyMonth = 0.0;
  int sumVehicleMonth = 0;
  SingletonData singletonData = SingletonData();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getListVehicle();
    getListVehicleMonth();
  }
  @override
  Widget build(BuildContext context) {

  }

  Future<void> getListVehicle() async{
      var time = DateTime.now();
      vehicles = await utils.getListVehicleByCondition(time.day, time.month, time.year, singletonData.userId);
      if(vehicles.isNotEmpty){
        vehicles.forEach((element) {
            sumMonney+= element.price;
            sumVehicle+=1;
        });
      }
      setState(() {
        sumMonney++;
      });
  }

  Future<void> getListVehicleMonth() async{
    var time = DateTime.now();
    vehicles = await utils.getListVehicleByConditionByMonth(time.month, time.year);
    if(vehicles.isNotEmpty){
      vehicles.forEach((element) {
        sumMonneyMonth+= element.price;
        sumVehicleMonth+=1;
      });
    }
    setState(() {
      sumMonneyMonth++;
    });
  }

}