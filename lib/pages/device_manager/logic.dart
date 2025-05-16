import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:formaldehyde_detection/api/client_api.dart';
import 'package:formaldehyde_detection/entity/ch2o_record_entity.dart';
import 'package:formaldehyde_detection/entity/device_entity.dart';
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

  Color getStatusColor(DeviceEntity device) {
    double concentration = device.concentration / 1000;
    if (concentration > device.warn) {
      return Colors.red;
    } else if (concentration > device.safe) {
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
    required double safe,
    required double warn,
    required double danger,
  }) async {
    final success = await clientApi.registerClient(
      userId: userId,
      password: password,
      authenticator: authenticator,
      isSuperuser: isSuperuser,
      address: address,
      safe: safe,
      warn: warn,
      danger: danger,
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

  Future<bool> updateDevice(
    DeviceEntity device, {
    required String newAddress,
    required bool newIsSuperuser,
    required String newPassword,
    required double safe,
    required double warn,
    required double danger,
  }) async {
    final success = await clientApi.updateDevice(
      authenticator: device.databaseName,
      username: device.userId,
      newAddress: newAddress,
      newIsSuperuser: newIsSuperuser,
      newPassword: newPassword,
      safe: safe,
      warn: warn,
      danger: danger,
    );

    if (success) {
      ToastUtil.okToastNoContent('设备信息已更新');
      return true;
    }
    return false;
  }

  String? validateThreshold(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入阈值';
    }
    final numValue = num.tryParse(value);
    if (numValue == null || numValue < 0) {
      return '请输入有效的阈值';
    }
    return null;
  }
}
