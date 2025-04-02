import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';
import 'state.dart';

class PersonPage extends StatelessWidget {
  PersonPage({Key? key}) : super(key: key);

  final PersonLogic logic = Get.put(PersonLogic());
  final PersonState state = Get.find<PersonLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
