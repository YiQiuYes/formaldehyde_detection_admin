import 'package:json_annotation/json_annotation.dart';
part 'client_entity.g.dart';

@JsonSerializable()
class ClientEntity {
  @JsonKey(name: 'username')
  String username;
  @JsonKey(name: "ip_address")
  String ipAddress;
  @JsonKey(name: "clientid")
  String clientId;

  ClientEntity({
    required this.username,
    required this.ipAddress,
    required this.clientId,
  });

  factory ClientEntity.fromJson(Map<String, dynamic> json) => _$ClientEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ClientEntityToJson(this);
}
