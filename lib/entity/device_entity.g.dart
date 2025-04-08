// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceEntity _$DeviceEntityFromJson(Map<String, dynamic> json) => DeviceEntity(
  clientId: (json['clientId'] as num?)?.toInt(),
  userId: json['userId'] as String,
  address: json['address'] as String?,
  isSuperuser: json['isSuperuser'] as bool,
  connected: json['connected'] as bool,
  concentration: (json['concentration'] as num?)?.toDouble() ?? 0.0,
  databaseName: json['databaseName'] as String,
);

Map<String, dynamic> _$DeviceEntityToJson(DeviceEntity instance) =>
    <String, dynamic>{
      'clientId': instance.clientId,
      'userId': instance.userId,
      'address': instance.address,
      'isSuperuser': instance.isSuperuser,
      'connected': instance.connected,
      'databaseName': instance.databaseName,
      'concentration': instance.concentration,
    };
