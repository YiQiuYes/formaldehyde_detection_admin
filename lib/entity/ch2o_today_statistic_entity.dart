import 'package:json_annotation/json_annotation.dart';
part 'ch2o_today_statistic_entity.g.dart';

@JsonSerializable()
class Ch2oTodayStatisticEntity {
  @JsonKey(name: "max")
  double max;
  @JsonKey(name: 'min')
  double min;
  @JsonKey(name: "avg")
  double avg;

  Ch2oTodayStatisticEntity({
    required this.max,
    required this.min,
    required this.avg,
  });

  factory Ch2oTodayStatisticEntity.fromJson(Map<String, dynamic> json) => _$Ch2oTodayStatisticEntityFromJson(json);

  Map<String, dynamic> toJson() => _$Ch2oTodayStatisticEntityToJson(this);
}
