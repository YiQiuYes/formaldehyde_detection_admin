// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ch2o_record_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ch2oRecordEntity _$Ch2oRecordEntityFromJson(Map<String, dynamic> json) =>
    Ch2oRecordEntity(
      recordId: (json['recordId'] as num).toInt(),
      clientId: (json['clientId'] as num).toInt(),
      recordTime: (json['recordTime'] as num).toInt(),
      recordValue: (json['recordValue'] as num).toDouble(),
    );

Map<String, dynamic> _$Ch2oRecordEntityToJson(Ch2oRecordEntity instance) =>
    <String, dynamic>{
      'recordId': instance.recordId,
      'clientId': instance.clientId,
      'recordTime': instance.recordTime,
      'recordValue': instance.recordValue,
    };
