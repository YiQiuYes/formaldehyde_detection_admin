import 'package:formaldehyde_detection/api/user_api.dart';
import 'package:formaldehyde_detection/pages/route_config.dart';
import 'package:get/get.dart';

import '../../state/global_logic.dart';
import '../../utils/toast_util.dart';
import 'state.dart';

class LoginLogic extends GetxController {
  final LoginState state = LoginState();

  final userApi = UserApi();

  @override
  void dispose() {
    // 释放资源
    state.usernameController.dispose();
    state.passwordController.dispose();
    super.dispose();
  }

  void login() {
    String username = state.usernameController.text;
    String password = state.passwordController.text;

    // 验证用户名和密码
    if (username.isEmpty || password.isEmpty) {
      ToastUtil.errorToastNoContent('用户名和密码不能为空');
      return;
    }

    // 调用登录接口
    userApi.login(username: username, password: password).then((value) {
      if (value != null) {
        ToastUtil.okToastNoContent('登录成功');
        // 保存用户信息
        final logic = Get.find<GlobalLogic>();
        logic.setLoginState(true);
        logic.setToken(value.token!);
        logic.setRefreshToken(value.refreshToken!);

        Get.toNamed(RouteConfig.home);
      } else {
        ToastUtil.errorToastNoContent('登录失败');
      }
    });
  }
}
