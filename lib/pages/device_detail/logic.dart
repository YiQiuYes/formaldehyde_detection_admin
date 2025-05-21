import 'package:formaldehyde_detection/api/client_api.dart';
import 'package:formaldehyde_detection/api/mock_api.dart';
import 'package:formaldehyde_detection/entity/device_entity.dart';
import 'package:get/get.dart';

import 'state.dart';

class DeviceDetailLogic extends GetxController {
  final DeviceDetailState state = DeviceDetailState();

  final clientApi = ClientApi();
  final mockApi = MockApi();

  /// 获取甲醛浓度
  /// [return] 甲醛浓度
  double getFormaldehydeConcentration(
    DeviceEntity device,
    List<DeviceEntity> devices,
  ) {
    return devices.firstWhere((element) {
          return element.clientId == device.clientId;
        }).concentration /
        1000.0;
  }

  /// 加载今日统计数据
  void loadTodayStatistics(int clientId) async {
    final res = await clientApi.clientTodayStatistic(clientId: clientId);
    if (res != null) {
      state.ch2oTodayStatistic.value = res;
      update();
    }
  }

  /// 模拟数据
  /// [device] 设备
  /// [type] 模拟类型
  void simulateData(DeviceEntity device, String type) {
    switch (type) {
      case 'safe':
        mockApi.mockSafe(device.userId);
        break;
      case 'warn':
        mockApi.mockWarn(device.userId);
        break;
      case 'danger':
        mockApi.mockDanger(device.userId);
        break;
      case 'close':
        mockApi.close(device.userId);
        break;
    }
  }
}
