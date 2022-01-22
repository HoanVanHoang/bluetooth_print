// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vehicle _$VehicleFromJson(Map<String, dynamic> json) {
  return Vehicle(
    id: json['id'] as String,
    numberId: json['numberId'] as String,
    price: json['price'] as int,
    minute: json['minute'] as int,
    hour: json['hour'] as int,
    day: json['day'] as int,
    month: json['month'] as int,
    year: json['year'] as int,
    userId: json['user_id'] as int
  );
}

Map<String, dynamic> _$VehicleToJson(Vehicle instance) => <String, dynamic>{
      'id':instance.id,
      'numberId': instance.numberId,
      'price': instance.price,
      'minute': instance.minute,
      'day': instance.day,
      'month': instance.month,
      'hour': instance.hour,
      'year': instance.year,
      'user_id': instance.userId
    };
