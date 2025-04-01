import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';
import 'state.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final LoginLogic logic = Get.put(LoginLogic());
  final LoginState state = Get.find<LoginLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 提示信息
          Padding(
            padding: const EdgeInsets.only(top: 100, left: 30),
            child: Text(
              '欢迎使用设备管理系统',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          // 用户名输入框
          Padding(
            padding: const EdgeInsets.only(top: 70, left: 30, right: 30),
            child: TextField(
              controller: state.usernameController,
              decoration: InputDecoration(
                labelText: '用户名',
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
              ),
            ),
          ),
          // 密码输入框
          Padding(
            padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
            child: TextField(
              controller: state.passwordController,
              decoration: InputDecoration(
                labelText: '密码',
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
              ),
              obscureText: true,
            ),
          ),
          // 登录按钮
          Padding(
            padding: const EdgeInsets.only(top: 35, left: 30, right: 30),
            child: FloatingActionButton(
              onPressed: () {
                // 登录逻辑
                logic.login();
              },
              child: Text('登录', style: TextStyle(fontSize: 17)),
            ),
          ),
        ],
      ),
    );
  }
}
