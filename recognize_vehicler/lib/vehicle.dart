
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'vehicle.g.dart';

@JsonSerializable()
class Vehicle extends Equatable{
  String id;
  String numberId;
  int price;
  int minute;
  int hour;
  int day;
  int month;
  int year;
  int userId;

  Vehicle({this.id,this.numberId, this.price, this.minute, this.hour, this.day,
      this.month, this.year, this.userId});

  factory Vehicle.fromJson(Map<String, dynamic> json) => _$VehicleFromJson(json);

  toJson() => _$VehicleToJson(this);

  @override
  List<Object> get props {
  }
}