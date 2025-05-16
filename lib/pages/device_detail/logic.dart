import 'package:formaldehyde_detection/api/client_api.dart';
import 'package:formaldehyde_detection/entity/device_entity.dart';
import 'package:get/get.dart';

import 'state.dart';

class DeviceDetailLogic extends GetxController {
  final DeviceDetailState state = DeviceDetailState();

  final clientApi = ClientApi();

  /// 获取甲醛浓度
  /// [return] 甲醛浓度
  double getFormaldehydeConcentration(
    DeviceEntity device,
    List<DeviceEntity> devices,
  ) {
    return devices.firstWhere((element) {
      return element.clientId == device.clientId;
    }).concentration / 1000.0;
  }

  /// 加载今日统计数据
  void loadTodayStatistics(int clientId) async {
    final res = await clientApi.clientTodayStatistic(clientId: clientId);
    if (res != null) {
      state.ch2oTodayStatistic.value = res;
      update();
    }
  }
}
