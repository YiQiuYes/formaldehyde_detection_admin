import 'package:flutter/cupertino.dart';
import 'package:formaldehyde_detection/utils/logger_util.dart';
import 'package:get/get.dart';

import '../../utils/toast_util.dart';
import 'state.dart';

class LoginLogic extends GetxController {
  final LoginState state = LoginState();

  @override
  void dispose() {
    // 释放资源
    state.usernameController.dispose();
    state.passwordController.dispose();
    super.dispose();
  }

  void login(BuildContext context) {
    String username = state.usernameController.text;
    String password = state.passwordController.text;

    // 验证用户名和密码
    if (username.isEmpty || password.isEmpty) {
      ToastUtil.errorToast('用户名和密码不能为空', context);
      return;
    }
  }
}
