import 'dart:async';

import 'package:formaldehyde_detection/api/client_api.dart';
import 'package:get/get.dart';

import 'state.dart';

class DashBoardLogic extends GetxController {
  final DashBoardState state = DashBoardState();

  final clientApi = ClientApi();

  /// 刷新设备状态
  /// [return] 无
  void refreshDeviceStatus() {
    clientApi.clientALLList().then((value) {
      int onlineDevices = 0;
      for (var element in value) {
        if (element.connected) {
          onlineDevices++;
        }
      }
      state.onlineDevices.value = onlineDevices;
      state.totalDevices.value = value.length;
      update();
    });
  }

  /// 定时器初始化
  /// [return] 无
  void initTimer() {
    state.refreshTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      refreshDeviceStatus();
    });
  }
}
