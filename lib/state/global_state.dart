import 'package:formaldehyde_detection/entity/device_entity.dart';
import 'package:formaldehyde_detection/state/user_data.dart';
import 'package:get/get.dart';

class GlobalState {
  static final String storageUserData = "globalUserData";
  Rx<UserData> userData =
      UserData(
        isLogin: false,
        token: null,
        refreshToken: null,
        userName: null,
      ).obs;
  // 设备列表数据
  RxList<DeviceEntity> devices = List<DeviceEntity>.empty().obs;
}
