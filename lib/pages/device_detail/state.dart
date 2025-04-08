import 'package:formaldehyde_detection/entity/ch2o_today_statistic_entity.dart';
import 'package:get/get.dart';

class DeviceDetailState {
  Rx<Ch2oTodayStatisticEntity> ch2oTodayStatistic =
      Rx<Ch2oTodayStatisticEntity>(
        Ch2oTodayStatisticEntity(max: 0, min: 0, avg: 0),
      );

  DeviceDetailState() {
    ///Initialize variables
  }
}
