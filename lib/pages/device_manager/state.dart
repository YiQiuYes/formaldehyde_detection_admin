import 'package:get/get.dart';

class DeviceManagerState {
  // 设备列表数据
  RxList<Device> devices = List<Device>.empty().obs;

  DeviceManagerState() {
    ///Initialize variables
  }
}

// 设备实体类
class Device {
  final String address;
  final bool isOnline;
  final double concentration;

  Device({
    required this.address,
    required this.isOnline,
    required this.concentration,
  });
}
