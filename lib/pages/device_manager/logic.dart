import 'dart:convert';

import 'package:formaldehyde_detection/entity/ch2o_record_entity.dart';
import 'package:formaldehyde_detection/pages/device_manager/state.dart';
import 'package:formaldehyde_detection/state/global_logic.dart';
import 'package:formaldehyde_detection/utils/logger_util.dart';
import 'package:formaldehyde_detection/utils/websocket_util.dart';
import 'package:get/get.dart';

class DeviceManagerLogic extends GetxController {
  final DeviceManagerState state = DeviceManagerState();
  final GlobalLogic globalLogic = Get.find<GlobalLogic>();

  final websocket = WebSocketUtil();

  void loadDevices() {
    // 加载设备数据
    globalLogic.loadDevices();
  }

  void initWebSocket() {
    websocket.initWebSocket(
      onOpen: () {
        // 初始化心跳包
        websocket.initHeartBeat();
      },
      onMessage: (message) {
        final Map<String, dynamic> data = jsonDecode(message);
        // 处理接收到的消息
        final ch2oRecord = Ch2oRecordEntity.fromJson(data);
        for (var element in globalLogic.state.devices) {
          if (element.clientId == ch2oRecord.clientId) {
            element.concentration = ch2oRecord.recordValue;
            break;
          }
        }
        globalLogic.update();
      },
    );
  }

  void closeWebSocket() {
    websocket.destroyHeartBeat();
    websocket.closeSocket();
  }
}
