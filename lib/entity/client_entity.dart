import 'package:json_annotation/json_annotation.dart';
part 'client_entity.g.dart';

@JsonSerializable()
class ClientEntity {
  @JsonKey(name: "clientId")
  int? clientId;
  @JsonKey(name: 'userId')
  String userId;
  @JsonKey(name: "address")
  String? address;
  @JsonKey(name: "isSuperuser")
  bool isSuperuser;
  @JsonKey(name: "connected")
  bool connected;
  @JsonKey(name: "databaseName")
  String databaseName;
  @JsonKey(name: "safe")
  double safe;
  @JsonKey(name: "warn")
  double warn;
  @JsonKey(name: "danger")
  double danger;

  ClientEntity({
    this.clientId,
    required this.userId,
    this.address,
    required this.isSuperuser,
    required this.connected,
    required this.databaseName,
    required this.safe,
    required this.warn,
    required this.danger,
  });

  factory ClientEntity.fromJson(Map<String, dynamic> json) => _$ClientEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ClientEntityToJson(this);
}
