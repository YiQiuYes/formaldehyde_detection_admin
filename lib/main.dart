import 'package:flutter/material.dart';
import 'package:formaldehyde_detection/pages/route_config.dart';
import 'package:formaldehyde_detection/state/global_logic.dart';
import 'package:formaldehyde_detection/utils/storage_util.dart';
import 'package:get/get.dart';

Future<void> main() async {
  // 首先注册组件
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化本地存储
  await StorageUtil.init();

  // 初始化全局逻辑
  final logic = Get.put(GlobalLogic());
  logic.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '设备管理',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      getPages: RouteConfig.getPages,
      initialRoute: RouteConfig.home,
    );
  }
}