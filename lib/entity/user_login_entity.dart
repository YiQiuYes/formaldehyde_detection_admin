import 'package:json_annotation/json_annotation.dart';

part 'user_login_entity.g.dart';

@JsonSerializable()
class UserLoginEntity {
  @JsonKey(name: 'token')
  String? token;
  @JsonKey(name: "refreshToken")
  String? refreshToken;
  @JsonKey(name: "userName")
  String? userName;

  UserLoginEntity({this.token, this.refreshToken, this.userName});

  factory UserLoginEntity.fromJson(Map<String, dynamic> json) =>
      _$UserLoginEntityFromJson(json);

  Map<String, dynamic> toJson() => _$UserLoginEntityToJson(this);
}
