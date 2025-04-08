import 'package:flutter/material.dart';
import 'package:formaldehyde_detection/entity/device_entity.dart';
import 'package:formaldehyde_detection/pages/route_config.dart';
import 'package:formaldehyde_detection/state/global_logic.dart';
import 'package:get/get.dart';

import 'logic.dart';
import 'state.dart';

class DeviceManagerPage extends StatefulWidget {
  const DeviceManagerPage({super.key});

  @override
  State<DeviceManagerPage> createState() => _DeviceManagerPageState();
}

class _DeviceManagerPageState extends State<DeviceManagerPage> {
  final DeviceManagerLogic logic = Get.put(DeviceManagerLogic());
  final DeviceManagerState state = Get.find<DeviceManagerLogic>().state;

  @override
  void initState() {
    super.initState();
    logic.loadDevices(); // 加载设备数据
    logic.initWebSocket();
    logic.initTimer(); // 启动刷新定时器
  }

  @override
  void dispose() {
    logic.closeWebSocket(); // 关闭 WebSocket 连接
    state.refreshTimer?.cancel(); // 取消定时器
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '设备管理',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: GetBuilder<GlobalLogic>(
        builder: (logic) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: logic.state.devices.length,
            itemBuilder: (content, index) {
              final device = logic.state.devices[index];
              return _buildDeviceItem(device, context);
            },
          );
        },
      ),
    );
  }

  Widget _buildDeviceItem(DeviceEntity device, BuildContext context) {
    return InkWell(
      onTap: () {
        // 跳转到设备详情页面
        Get.toNamed(RouteConfig.deviceDetail, arguments: device);
      },
      onLongPress: () => _showDeleteDialog(device),  // 添加长按事件
      borderRadius: BorderRadius.circular(12),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          height: 80, // 固定卡片高度
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color:
                      device.connected
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  device.connected ? Icons.wifi : Icons.wifi_off,
                  color:
                      device.connected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outline,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      device.address ?? '',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '浓度 ${device.concentration.toStringAsFixed(2)} mg/m³',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.circle,
                  color: logic.getStatusColor(device.concentration),
                  size: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 新增删除确认对话框方法
  void _showDeleteDialog(DeviceEntity device) {
    Get.dialog(
      AlertDialog(
        title: const Text('删除设备'),
        content: Text('确定要删除设备 ${device.address} 吗？'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              logic.deleteDevice(device.userId, device.databaseName);  // 调用删除逻辑
            },
            child: const Text('删除', style: TextStyle(color: Colors.red)),
          ),
        ],
      )
    );
  }
}
