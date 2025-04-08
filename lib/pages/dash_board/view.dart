import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';
import 'state.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({super.key});

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  final DashBoardLogic logic = Get.put(DashBoardLogic());
  final DashBoardState state = Get.find<DashBoardLogic>().state;

  @override
  void initState() {
    super.initState();
    logic.refreshDeviceStatus();
    logic.initTimer(); // 启动刷新定时器
  }

  @override
  void dispose() {
    state.refreshTimer.cancel(); // 取消定时器
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '设备状态总览',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 新增设备状态卡片
            _buildDeviceStatusCards(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  /// 构建设备状态卡片
  /// [context] 上下文
  /// [return] 设备状态卡片
  Widget _buildDeviceStatusCards(BuildContext context) {
    return GetBuilder<DashBoardLogic>(
      builder: (logic) {
        return Row(
          children: [
            Expanded(
              child: _buildStatusCard(
                context: context,
                icon: Icons.wifi_find_rounded,
                title: "在线设备",
                value: "${state.onlineDevices}",
                unit: "台",
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatusCard(
                context: context,
                icon: Icons.storage_rounded,
                title: "设备总量",
                value: "${state.totalDevices}",
                unit: "台",
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        );
      }
    );
  }

  Widget _buildStatusCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    required String unit,
    required Color color,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withValues(alpha: 0.15),
              color.withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, size: 32, color: color),
            ),
            const SizedBox(height: 20),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: value,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  TextSpan(
                    text: " $unit",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
