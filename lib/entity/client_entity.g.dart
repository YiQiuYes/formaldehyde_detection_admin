// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientEntity _$ClientEntityFromJson(Map<String, dynamic> json) => ClientEntity(
  clientId: (json['clientId'] as num?)?.toInt(),
  userId: json['userId'] as String,
  address: json['address'] as String?,
  isSuperuser: json['isSuperuser'] as bool,
  connected: json['connected'] as bool,
);

Map<String, dynamic> _$ClientEntityToJson(ClientEntity instance) =>
    <String, dynamic>{
      'clientId': instance.clientId,
      'userId': instance.userId,
      'address': instance.address,
      'isSuperuser': instance.isSuperuser,
      'connected': instance.connected,
    };
