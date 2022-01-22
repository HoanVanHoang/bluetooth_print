
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'vehicle_off.g.dart';

@JsonSerializable()
class VehicleOff extends Equatable{
  int id;
  String numberId;
  int price;
  int minute;
  int hour;
  int day;
  int month;
  int year;
  int userId;
  String previousCharacter;
  int editNumber = 0;


  VehicleOff({this.id,this.numberId, this.price, this.minute, this.hour, this.day,
      this.month, this.year, this.userId, this.previousCharacter, this.editNumber});

  factory VehicleOff.fromJson(Map<String, dynamic> json) => _$VehicleOffFromJson(json);

  toJson() => _$VehicleOffToJson(this);

  @override
  List<Object> get props {
  }
}