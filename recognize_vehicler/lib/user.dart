
import 'package:json_annotation/json_annotation.dart';
import 'package:recognize_vehicler/SingletonData.dart';
part 'user.g.dart';

@JsonSerializable()
class User {
  String username;
  String password;
  String id = "";
  int role;
  String fullName;
  int userId;
  String lastTimeLogin;
   String device ="";
  User({this.username, this.password, this.id, this.role, this.fullName, this.userId, this.lastTimeLogin, this.device});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  toJson() => _$UserToJson(this);
}