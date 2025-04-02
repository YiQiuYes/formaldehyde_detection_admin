import 'package:flutter/material.dart';
import 'package:formaldehyde_detection/pages/dash_board/view.dart';
import 'package:formaldehyde_detection/pages/device_manager/view.dart';
import 'package:formaldehyde_detection/pages/person/view.dart';
import 'package:get/get.dart';

import 'logic.dart';
import 'state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeLogic logic = Get.put(HomeLogic());
  final HomeState state = Get.find<HomeLogic>().state;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: state.pageController,
        onPageChanged: (index) {
          setState(() {
            state.currentIndex.value = index;
          });
        },
        children: [
          // 第一个页面 - 数据面板
          DashBoardPage(),
          // 第二个页面 - 设备管理
          DeviceManagerPage(),
          // 第三个页面 - 个人中心
          PersonPage(),
        ],
      ),
      bottomNavigationBar: GetBuilder<HomeLogic>(
        builder: (logic) {
          return NavigationBar(
            selectedIndex: state.currentIndex.value,
            onDestinationSelected: (index) {
              setState(() {
                state.currentIndex.value = index;
                state.pageController.jumpToPage(index);
              });
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: '数据面板',
              ),
              NavigationDestination(
                icon: Icon(Icons.devices_outlined),
                selectedIcon: Icon(Icons.devices),
                label: '设备管理',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outlined),
                selectedIcon: Icon(Icons.person),
                label: '个人中心',
              ),
            ],
          );
        }
      ),
    );
  }
}