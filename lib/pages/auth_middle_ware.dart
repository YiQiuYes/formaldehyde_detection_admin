import 'package:flutter/cupertino.dart';
import 'package:formaldehyde_detection/pages/route_config.dart';
import 'package:get/get.dart';

import '../state/global_logic.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final logic = Get.find<GlobalLogic>();

    if (!logic.getLoginState()) {
      return RouteSettings(name: RouteConfig.login);
    }

    return null;
  }
}
