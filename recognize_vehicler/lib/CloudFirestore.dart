import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recognize_vehicler/user.dart';
import 'package:recognize_vehicler/vehicle.dart';

class CloudFirestoreUtils {
  final databaseReference = FirebaseFirestore.instance;
  Map data;

  Future<Vehicle> createVehicle(Vehicle instance) async {
    DocumentReference ref = await databaseReference.collection("vehicle").add({
      'numberId': instance.numberId,
      'price': instance.price,
      'minute': instance.minute,
      'day': instance.day,
      'month': instance.month,
      'hour': instance.hour,
      'year': instance.year,
      'user_id': instance.userId
    }).catchError((onError) => new Vehicle());
    print("Added: " + ref.id);
    instance.id = ref.id;
    return instance;
  }

  Future<bool> updateData(Vehicle v) {
    databaseReference
        .collection("vehicle")
        .doc(v.id)
        .update(v.toJson())
        .whenComplete(() => true)
        .catchError((err) {
      return false;
    });
  }


  Future<bool> deleteData(String id) {
    databaseReference
        .collection("vehicle")
        .doc(id)
        .delete()
        .whenComplete(() => true)
        .catchError((err) {
      return false;
    });
  }

  Future<List<Vehicle>> getListVehicleByCondition(
      int day, int month, int year, int userId) async {
    List<Vehicle> result = List();
    await databaseReference
        .collection("vehicle")
        .where("day", isEqualTo: day)
        .where("month", isEqualTo: month)
        .where("year", isEqualTo: year)
        .where("user_id", isEqualTo: userId)
        .get()
        .then((QuerySnapshot snapshot) {
      List<QueryDocumentSnapshot> temp = snapshot.docs;
      if (temp.length > 0) {
        temp.forEach((element) {
          String tempId = element.id;
          Map<String, dynamic> tempObj =element.data();
          tempObj["id"] = tempId;
          Vehicle v = Vehicle.fromJson(tempObj);
          result.add(v);
        });
      }
    }).catchError((onError){
      print(onError);
    });

    return result;
  }

  Future<List<Vehicle>> getListVehicleByConditionByMonth(
      int month, int year) async {
    print("test2");
    List<Vehicle> result = List();
    await databaseReference
        .collection("vehicle")
        .where("month", isEqualTo: month)
        .where("year", isEqualTo: year)
        .get()
        .then((QuerySnapshot snapshot) {
      List<QueryDocumentSnapshot> temp = snapshot.docs;
      if (temp.length > 0) {
        temp.forEach((element) {
          String tempId = element.id;
          Map<String, dynamic> tempObj =element.data();
          tempObj["id"] = tempId;
          Vehicle v = Vehicle.fromJson(tempObj);
          result.add(v);
        });
      }
    });
    return result;
  }

  Future<bool> updateLogin(String device, String id, String lastTime) {
    databaseReference
        .collection("user")
        .doc(id)
        .update({
      'device_info':device,
      "last_time": lastTime
       })
        .whenComplete(() => true)
        .catchError((err) {
      return false;
    });
  }

  Future<List<User>> getListUser() async {
    print("test2");
    List<User> result = List();
    await databaseReference
        .collection("user")
        .get()
        .then((QuerySnapshot snapshot) {
      List<QueryDocumentSnapshot> temp = snapshot.docs;
      print("size document ${temp.length}");
      if (temp.length > 0) {
        temp.forEach((element) {
          String idTemp1 = element.reference.id;
          Map<String, dynamic> tempObj =element.data();
          tempObj["id"] = idTemp1;
          print("data ${element.data().toString()}");
          User v = User.fromJson(tempObj);
          result.add(v);
          return result;
        });
      }
    }).catchError((err) {
      print("error ${err.toString()}");
    });
    return result;
  }

  Future<List<User>> getListUserByUserName(String userName) async {
    print("test2");
    List<User> result = List();
    await databaseReference
        .collection("user")
        .where("username", isEqualTo: userName)
        .get()
        .then((QuerySnapshot snapshot) {
      List<QueryDocumentSnapshot> temp = snapshot.docs;
      print("size document ${temp.length}");
      if (temp.length > 0) {
        temp.forEach((element) {
          String idTemp1 = element.reference.id;
          Map<String, dynamic> tempObj =element.data();
          tempObj["id"] = idTemp1;
          print("data ${element.data().toString()}");
          User v = User.fromJson(tempObj);
          result.add(v);
          return result;
        });
      }
    }).catchError((err) {
      print("error ${err.toString()}");
    });
    return result;
  }

  Future<List<User>> getListUserByUserId(int id) async {
    print("test2");
    List<User> result = List();
    await databaseReference
        .collection("user")
        .where("user_id", isEqualTo: id)
        .get()
        .then((QuerySnapshot snapshot) {
      List<QueryDocumentSnapshot> temp = snapshot.docs;
      print("size document ${temp.length}");
      if (temp.length > 0) {
        temp.forEach((element) {
         String idTemp1 = element.reference.id;
         Map<String, dynamic> tempObj =element.data();
         tempObj["id"] = idTemp1;
          print("data ${element.data().toString()}");
          User v = User.fromJson(tempObj);
          result.add(v);
          return result;
        });
      }
    }).catchError((err) {
      print("error ${err.toString()}");
    });
    return result;
  }

  Future<List<Vehicle>> getListVehicle(int userId) async {
    List<Vehicle> result = List();
    await databaseReference
        .collection("vehicle")
        .where("user_id", isEqualTo: userId)
        .get()
        .then((QuerySnapshot snapshot) {
      List<QueryDocumentSnapshot> temp = snapshot.docs;
      if (temp.length > 0) {
        temp.forEach((element) {
          String tempId = element.id;
          Map<String, dynamic> tempObj =element.data();
          tempObj["id"] = tempId;
          Vehicle v = Vehicle.fromJson(tempObj);
          result.add(v);
        });
      }
    });
    print("test2 ${result.length}");
    return result;
  }
}
