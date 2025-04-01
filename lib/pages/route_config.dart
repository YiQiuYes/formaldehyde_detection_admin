import 'package:formaldehyde_detection/pages/auth_middle_ware.dart';
import 'package:formaldehyde_detection/pages/home/view.dart';
import 'package:formaldehyde_detection/pages/login/view.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class RouteConfig {
  static const String home = "/home";
  static const String login = "/login";

  static final List<GetPage> getPages = [
    GetPage(name: login, page: () => LoginPage()),
    GetPage(
      name: home,
      page: () => HomePage(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}
