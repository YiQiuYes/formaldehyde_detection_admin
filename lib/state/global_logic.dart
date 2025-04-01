import 'dart:convert';

import 'package:formaldehyde_detection/state/user_data.dart';
import 'package:formaldehyde_detection/utils/storage_util.dart';
import 'package:get/get.dart';

import 'global_state.dart';

class GlobalLogic extends GetxController {
  final GlobalState state = GlobalState();

  void init() {
    // 初始化用户数据
    String? userDataStr = StorageUtil.getString(GlobalState.storageUserData);
    if (userDataStr != null) {
      state.userData.value = UserData.fromJson(jsonDecode(userDataStr));
    }
  }

  bool getLoginState() {
    return state.userData.value.isLogin;
  }

  void setLoginState(bool isLogin) {
    state.userData.value.isLogin = isLogin;
    StorageUtil.setString(
      GlobalState.storageUserData,
      jsonEncode(state.userData.value.toJson()),
    );
  }

  String? getToken() {
    return state.userData.value.token;
  }

  void setToken(String token) {
    state.userData.value.token = token;
    StorageUtil.setString(
      GlobalState.storageUserData,
      jsonEncode(state.userData.value.toJson()),
    );
  }

  String? getRefreshToken() {
    return state.userData.value.refreshToken;
  }

  void setRefreshToken(String refreshToken) {
    state.userData.value.refreshToken = refreshToken;
    StorageUtil.setString(
      GlobalState.storageUserData,
      jsonEncode(state.userData.value.toJson()),
    );
  }
}
