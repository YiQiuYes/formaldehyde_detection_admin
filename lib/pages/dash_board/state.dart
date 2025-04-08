import 'dart:async';

import 'package:get/get_rx/src/rx_types/rx_types.dart';

class DashBoardState {
  RxInt onlineDevices = 0.obs;
  RxInt totalDevices = 0.obs;

  // 刷新定时器
  late Timer refreshTimer; 
  
  DashBoardState() {
    ///Initialize variables
  }
}
