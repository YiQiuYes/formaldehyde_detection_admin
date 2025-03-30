// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientEntity _$ClientEntityFromJson(Map<String, dynamic> json) => ClientEntity(
  username: json['username'] as String,
  ipAddress: json['ip_address'] as String,
  clientId: json['clientid'] as String,
);

Map<String, dynamic> _$ClientEntityToJson(ClientEntity instance) =>
    <String, dynamic>{
      'username': instance.username,
      'ip_address': instance.ipAddress,
      'clientid': instance.clientId,
    };
