// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
  token: json['token'] as String?,
  refreshToken: json['refreshToken'] as String?,
  isLogin: json['isLogin'] as bool? ?? false,
);

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
  'isLogin': instance.isLogin,
  'token': instance.token,
  'refreshToken': instance.refreshToken,
};
