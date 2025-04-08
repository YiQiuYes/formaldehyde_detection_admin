import 'package:json_annotation/json_annotation.dart';
part 'ch2o_record_entity.g.dart';

@JsonSerializable()
class Ch2oRecordEntity {
  @JsonKey(name: "recordId")
  int recordId;
  @JsonKey(name: 'clientId')
  int clientId;
  @JsonKey(name: "recordTime")
  int recordTime;
  @JsonKey(name: "recordValue")
  double recordValue;

  Ch2oRecordEntity({
    required this.recordId,
    required this.clientId,
    required this.recordTime,
    required this.recordValue,
  });

  factory Ch2oRecordEntity.fromJson(Map<String, dynamic> json) => _$Ch2oRecordEntityFromJson(json);

  Map<String, dynamic> toJson() => _$Ch2oRecordEntityToJson(this);
}
