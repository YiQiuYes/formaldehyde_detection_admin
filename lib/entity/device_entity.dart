import 'package:formaldehyde_detection/entity/client_entity.dart';
import 'package:json_annotation/json_annotation.dart';
part 'device_entity.g.dart';

@JsonSerializable()
class DeviceEntity extends ClientEntity {
  @JsonKey(name: "concentration")
  double concentration;

  DeviceEntity({
    super.clientId,
    required super.userId,
    super.address,
    required super.isSuperuser,
    required super.connected,
    this.concentration = 0.0,
    required super.databaseName,
  });

  factory DeviceEntity.fromJson(Map<String, dynamic> json) => _$DeviceEntityFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DeviceEntityToJson(this);

  void updateFrom(ClientEntity newData) {
    userId = newData.userId;
    isSuperuser = newData.isSuperuser;
    connected = newData.connected;
    address = newData.address;
    databaseName = newData.databaseName;
  }
}
