import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:formaldehyde_detection/api/client_api.dart';
import 'package:formaldehyde_detection/entity/ch2o_record_entity.dart';
import 'package:formaldehyde_detection/pages/device_manager/state.dart';
import 'package:formaldehyde_detection/state/global_logic.dart';
import 'package:formaldehyde_detection/utils/toast_util.dart';
import 'package:formaldehyde_detection/utils/websocket_util.dart';
import 'package:get/get.dart';

class DeviceManagerLogic extends GetxController {
  final DeviceManagerState state = DeviceManagerState();
  final GlobalLogic globalLogic = Get.find<GlobalLogic>();

  final websocket = WebSocketUtil();
  final clientApi = ClientApi();

  void initTimer() {
    // 初始化定时器
    state.refreshTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      // 刷新设备状态
      loadDevices();
    });
  }

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

  Color getStatusColor(double concentration) {
    if (concentration > 400) {
      return Colors.red;
    } else if (concentration > 300) {
      return Colors.pinkAccent;
    } else if (concentration > 200) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  void deleteDevice(String userId, String database) async {
    try {
      // 调用API删除设备
      await clientApi.deleteUserToAuthenticator(
        userId: userId,
        authenticator: database,
      );

      // 从全局状态中移除设备
      final globalLogic = Get.find<GlobalLogic>();
      globalLogic.state.devices.removeWhere((d) => d.userId == userId);
      globalLogic.update();

      ToastUtil.okToastNoContent('设备已删除');
    } catch (e) {
      ToastUtil.errorToastNoContent('删除设备时发生错误');
    }
  }

  Future<bool> registerDevice({
    required String userId,
    required String password,
    required String authenticator,
    required bool isSuperuser,
    required String address,
  }) async {
    final success = await clientApi.registerClient(
      userId: userId,
      password: password,
      authenticator: authenticator,
      isSuperuser: isSuperuser,
      address: address,
    );

    if (success) {
      ToastUtil.okToastNoContent('设备注册成功');
      return true;
    } else {
      ToastUtil.errorToastNoContent('设备注册失败');
    }
    return false;
  }

  Future<void> loadAuthenticators() async {
    final result = await clientApi.getAuthenticators();
    state.authenticators.value = result;
    update();
  }
}
