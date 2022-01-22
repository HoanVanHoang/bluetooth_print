// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    username: json['username'] as String,
    password: json['password'] as String,
    role: json['role'] as int,
    fullName: json['full_name'] as String,
    userId: json["user_id"] as int,
    lastTimeLogin: json["last_time"] as String,
    id: json["id"] as String,
    device: json["device_info"] as String
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
      'id': instance.id,
      'role': instance.role as int,
      'full_name' : instance.fullName as String,
      'user_id' : instance.userId as int,
      'last_time': instance.lastTimeLogin as String,
      'device_info':  instance.device as String
    };
