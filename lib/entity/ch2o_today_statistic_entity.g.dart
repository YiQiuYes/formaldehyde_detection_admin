// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ch2o_today_statistic_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ch2oTodayStatisticEntity _$Ch2oTodayStatisticEntityFromJson(
  Map<String, dynamic> json,
) => Ch2oTodayStatisticEntity(
  max: (json['max'] as num).toDouble(),
  min: (json['min'] as num).toDouble(),
  avg: (json['avg'] as num).toDouble(),
);

Map<String, dynamic> _$Ch2oTodayStatisticEntityToJson(
  Ch2oTodayStatisticEntity instance,
) => <String, dynamic>{
  'max': instance.max,
  'min': instance.min,
  'avg': instance.avg,
};
