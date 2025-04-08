// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_login_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserLoginEntity _$UserLoginEntityFromJson(Map<String, dynamic> json) =>
    UserLoginEntity(
      token: json['token'] as String?,
      refreshToken: json['refreshToken'] as String?,
      userName: json['userName'] as String?,
    );

Map<String, dynamic> _$UserLoginEntityToJson(UserLoginEntity instance) =>
    <String, dynamic>{
      'token': instance.token,
      'refreshToken': instance.refreshToken,
      'userName': instance.userName,
    };
