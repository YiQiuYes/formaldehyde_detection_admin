import 'package:formaldehyde_detection/pages/device_manager/state.dart';
import 'package:formaldehyde_detection/api/client_api.dart';
import 'package:get/get.dart';

class DeviceManagerLogic extends GetxController {
  final DeviceManagerState state = DeviceManagerState();

  final clientApi = ClientApi();

  void loadDevices() async {
    final result = await clientApi.clientALLList();
    state.devices.value =
        result.map((client) {
          return Device(
            address: client.address ?? '',
            isOnline: client.connected,
            concentration: 0,
          );
        }).toList();
    update();
  }
}
