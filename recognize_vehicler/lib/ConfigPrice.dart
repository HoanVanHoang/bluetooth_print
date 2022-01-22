

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recognize_vehicler/SingletonData.dart';

import 'String_Constants.dart';

class ConfigPrice extends StatefulWidget{
  ConfigPriceState createState() => ConfigPriceState();
}
class ConfigPriceState extends State<ConfigPrice>{
  SingletonData singletonData = SingletonData();
  String price = "0";
  var numberController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    numberController.text = singletonData.price.toString();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.config_price),
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                keyboardType: TextInputType.number,
                onChanged: (text) {
                  price = text;
                },
                controller: numberController,
                obscureText: false,
                style: singletonData.style,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    hintText: Strings.input_price_number,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0))),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 150,
                    child: FlatButton(
                      onPressed: (){
                         singletonData.price = int.parse(numberController.text.trim());
                         onCancle(context);
                      },
                      //onPressed: onPrint,
                      child:
                      Text(Strings.save, style: TextStyle(color: Colors.blue)),
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: Colors.blue,
                              width: 1,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(50)),
                    ),
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: FlatButton(
                    onPressed: () {
                      onCancle(context);
                    },
                    child: Text(Strings.canncel, style: TextStyle(color: Colors.blue)),
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Colors.blue,
                            width: 1,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(50)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
   }
  void onCancle(BuildContext context) {
    Navigator.pop(context);
  }
}