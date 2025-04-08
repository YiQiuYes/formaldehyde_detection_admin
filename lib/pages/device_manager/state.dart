import 'dart:async';

import 'package:get/get.dart';

class DeviceManagerState {
  // 刷新定时器
  Timer? refreshTimer;

  RxList<String> authenticators = List<String>.empty().obs;

  DeviceManagerState() {
    ///Initialize variables
  }
}
