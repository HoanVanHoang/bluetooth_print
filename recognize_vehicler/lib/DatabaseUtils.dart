import 'package:path/path.dart';
import 'package:recognize_vehicler/String_Constants.dart';
import 'package:recognize_vehicler/vehicle.dart';
import 'package:recognize_vehicler/vehicle_off.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseUtils {
  static const String DB_NAME = "vehicle_database_v1.db";
  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    return await openDatabase(
        join(await getDatabasesPath(), "database_v3.db"),
       version: 1,
      onCreate: (Database db, int version) async {
        // When creating the db, create the table
        await db.execute(
            'CREATE TABLE vehicle (id INTEGER PRIMARY KEY, '
                'numberId TEXT, '
                'price INTEGER, '
                'minute INTEGER,'
                'hour INTEGER, '
                'day INTEGER,'
                'month INTEGER,'
                'year INTEGER, '
                'user_id INTEGER, '
                'previous_character TEXT,'
                'edit_number INTEGER'
                ')');
      }
    );
  }

  Future<VehicleOff> createVehicle(VehicleOff instance, Database db) async {
   int idVehicle =  await db.insert("vehicle", {
      'numberId': instance.numberId,
      'price': instance.price,
      'minute': instance.minute,
      'day': instance.day,
      'month': instance.month,
      'hour': instance.hour,
      'year': instance.year,
      'user_id': instance.userId,
       'previous_character': instance.previousCharacter,
       'edit_number': instance.editNumber
    });
    return instance;
  }

  Future<VehicleOff> updateVehicle(VehicleOff instance, Database db, String oldnumberid, String oldprevious) async {
    int idVehicle =  await db.rawUpdate(
        'UPDATE vehicle SET numberId = ?, price = ? , minute = ?,'
            'day = ?, month = ?, hour = ?, year = ?, previous_character = ?, edit_number = ?  '
            'WHERE numberId = ? and previous_character = ?',
        [instance.numberId, instance.price, instance.minute, instance.day,
          instance.month, instance.hour, instance.year, instance.previousCharacter, instance.editNumber,
          oldnumberid, oldprevious]);
    return instance;
  }

  Future<List<VehicleOff>> getListVehicle(Database db, int day, int month, int year, int userId) async{
    List<Map<String, dynamic>> maps = await db.rawQuery('SELECT * FROM vehicle'
        ' where day = ${day} and month = ${month} and year = ${year} and user_id = ${userId}');
    List<VehicleOff> vehicles = maps.map((e) =>VehicleOff.fromJson(e)).toList();
    if(vehicles.length>0) return vehicles;
    return [];
  }
}
