import 'package:get/get.dart';

import 'state.dart';

class DashBoardLogic extends GetxController {
  final DashBoardState state = DashBoardState();

  // 这里可以添加获取实时数据的方法
  void updateFormaldehydeLevel(double newLevel) {
    state.currentFormaldehydeLevel = newLevel;
    update();
  }
}
