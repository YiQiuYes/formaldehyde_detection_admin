import 'package:json_annotation/json_annotation.dart';

part 'user_data.g.dart';

@JsonSerializable()
class UserData {
  @JsonKey(name: 'isLogin')
  bool isLogin;
  @JsonKey(name: 'token')
  String? token;
  @JsonKey(name: "refreshToken")
  String? refreshToken;

  UserData({this.isLogin = false, this.token, this.refreshToken});

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}
