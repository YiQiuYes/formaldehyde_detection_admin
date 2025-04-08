import 'package:get/get.dart';

import 'state.dart';

class DeviceDetailLogic extends GetxController {
  final DeviceDetailState state = DeviceDetailState();

    // 这里可以添加获取实时数据的方法
  void updateFormaldehydeLevel(double newLevel) {
    state.currentFormaldehydeLevel = newLevel;
    update();
  }
}
