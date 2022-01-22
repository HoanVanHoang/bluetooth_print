// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_off.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleOff _$VehicleOffFromJson(Map<String, dynamic> json) {
  return VehicleOff(
    id: json['id'] as int,
    numberId: json['numberId'] as String,
    price: json['price'] as int,
    minute: json['minute'] as int,
    hour: json['hour'] as int,
    day: json['day'] as int,
    month: json['month'] as int,
    year: json['year'] as int,
    userId: json['user_id'] as int,
    previousCharacter: json['previous_character'] as String,
    editNumber: json['edit_number'] as int
  );
}

Map<String, dynamic> _$VehicleOffToJson(VehicleOff instance) => <String, dynamic>{
      'id':instance.id,
      'numberId': instance.numberId,
      'price': instance.price,
      'minute': instance.minute,
      'day': instance.day,
      'month': instance.month,
      'hour': instance.hour,
      'year': instance.year,
      'user_id': instance.userId,
      'previous_character' : instance.previousCharacter,
      'edit_number' :instance.editNumber
    };
