// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
  isLogin: json['isLogin'] as bool? ?? false,
  token: json['token'] as String?,
  refreshToken: json['refreshToken'] as String?,
  userName: json['userName'] as String?,
);

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
  'isLogin': instance.isLogin,
  'token': instance.token,
  'refreshToken': instance.refreshToken,
  'userName': instance.userName,
};
