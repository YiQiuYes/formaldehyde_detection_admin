import 'package:flutter/material.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('设备管理')),
      body: GetBuilder<DeviceManagerLogic>(
        builder: (logic) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.devices.length,
            itemBuilder: (content, index) {
              final device = state.devices[index];
              return _buildDeviceItem(device, context);
            },
          );
        },
      ),
    );
  }

  Widget _buildDeviceItem(Device device, BuildContext context) {
    return Card(
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
                    device.isOnline
                        ? Theme.of(context).colorScheme.primaryContainer
                        : Theme.of(context).colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                device.isOnline ? Icons.wifi : Icons.wifi_off,
                color:
                    device.isOnline
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
                    device.address,
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
                color:
                    device.concentration > 0.1
                        ? Theme.of(context).colorScheme.errorContainer
                        : Theme.of(context).colorScheme.tertiaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.circle,
                color: device.concentration > 0.1 ? Colors.red : Colors.green,
                size: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
