import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';
import 'state.dart';

class DeviceManagerPage extends StatelessWidget {
  DeviceManagerPage({super.key});

  final DeviceManagerLogic logic = Get.put(DeviceManagerLogic());
  final DeviceManagerState state = Get.find<DeviceManagerLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
