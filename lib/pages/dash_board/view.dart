import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';
import 'state.dart';

class DashBoardPage extends StatelessWidget {
  DashBoardPage({super.key});

  final DashBoardLogic logic = Get.put(DashBoardLogic());
  final DashBoardState state = Get.find<DashBoardLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
