import 'package:formaldehyde_detection/state/user_data.dart';
import 'package:get/get.dart';

class GlobalState {
  static final String storageUserData = "globalUserData";
  Rx<UserData> userData =
      UserData(isLogin: false, token: null, refreshToken: null).obs;
}
