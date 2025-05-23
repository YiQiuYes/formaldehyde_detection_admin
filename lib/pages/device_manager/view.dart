import 'package:flutter/material.dart';
import 'package:formaldehyde_detection/entity/device_entity.dart';
import 'package:formaldehyde_detection/pages/route_config.dart';
import 'package:formaldehyde_detection/state/global_logic.dart';
import 'package:formaldehyde_detection/utils/toast_util.dart';
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
  }

  @override
  void dispose() {
    logic.closeWebSocket(); // 关闭 WebSocket 连接
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
      floatingActionButton: FloatingActionButton(
        onPressed: _showRegisterDialog,
        child: const Icon(Icons.add),
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
      onLongPress: () => _showActionDialog(device), // 修改长按事件处理
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
                      '浓度 ${(device.concentration / 1000).toStringAsFixed(2)} mg/m³',
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
                  color: logic.getStatusColor(device),
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
          TextButton(onPressed: () => Get.back(), child: const Text('取消')),
          TextButton(
            onPressed: () {
              Get.back();
              logic.deleteDevice(device.userId, device.databaseName); // 调用删除逻辑
            },
            child: const Text('删除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // 新增设备注册对话框
  Future<void> _showRegisterDialog() async {
    final formKey = GlobalKey<FormState>();
    String userId = '';
    String password = '';
    String? selectedAuthenticator; // 改为存储选中值
    RxBool isSuperuser = false.obs;
    String address = '';
    double safeValue = 0.50;
    double warnValue = 1.00;
    double dangerValue = 2.00;

    // 初始化加载认证器列表
    await logic.loadAuthenticators();

    if (state.authenticators.isEmpty) {
      ToastUtil.errorToastNoContent('未找到可用的认证器');
      return;
    }

    Get.dialog(
      AlertDialog(
        title: const Text('注册新设备'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: '用户ID'),
                  onSaved: (v) => userId = v ?? '',
                  validator: (v) => v?.isEmpty ?? true ? '必填字段' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: '密码'),
                  obscureText: true,
                  onSaved: (v) => password = v ?? '',
                  validator: (v) => v?.isEmpty ?? true ? '必填字段' : null,
                ),
                Obx(() {
                  if (state.authenticators.isEmpty) {
                    return const CircularProgressIndicator();
                  }
                  return DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: '认证器'),
                    borderRadius: BorderRadius.circular(12),
                    value: selectedAuthenticator,
                    items:
                        state.authenticators.map((authenticator) {
                          return DropdownMenuItem(
                            value: authenticator,
                            child: Text(authenticator),
                          );
                        }).toList(),
                    onChanged: (value) => selectedAuthenticator = value,
                    validator: (v) => v == null ? '请选择认证器' : null,
                  );
                }),
                TextFormField(
                  decoration: const InputDecoration(labelText: '设备地址'),
                  onSaved: (v) => address = v ?? '',
                  validator: (v) => v?.isEmpty ?? true ? '必填字段' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: '安全值 (mg/m³)'),
                  keyboardType: TextInputType.number,
                  initialValue: '0.50',
                  onSaved:
                      (v) => safeValue = double.tryParse(v ?? '0.50') ?? 0.50,
                  validator: (v) => logic.validateThreshold(v),
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: '警告值 (mg/m³)'),
                  keyboardType: TextInputType.number,
                  initialValue: '1.00',
                  onSaved:
                      (v) => warnValue = double.tryParse(v ?? '1.00') ?? 1.00,
                  validator: (v) => logic.validateThreshold(v),
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: '危险值 (mg/m³)'),
                  keyboardType: TextInputType.number,
                  initialValue: '2.00',
                  onSaved:
                      (v) => dangerValue = double.tryParse(v ?? '2.00') ?? 2.00,
                  validator: (v) => logic.validateThreshold(v),
                ),
                Row(
                  children: [
                    const Text('超级用户'),
                    Obx(
                      () => Checkbox(
                        value: isSuperuser.value,
                        onChanged: (v) => isSuperuser.value = v ?? false,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('取消')),
          TextButton(
            onPressed: () async {
              if (selectedAuthenticator == null) {
                ToastUtil.errorToastNoContent('请选择认证器');
                return;
              }

              if (formKey.currentState?.validate() ?? false) {
                formKey.currentState?.save();
                final success = await logic.registerDevice(
                  userId: userId,
                  password: password,
                  authenticator: selectedAuthenticator!,
                  isSuperuser: isSuperuser.value,
                  address: address,
                  safe: safeValue,
                  warn: warnValue,
                  danger: dangerValue,
                );
                if (success) {
                  Get.back();
                  logic.loadDevices(); // 刷新设备列表
                }
              }
            },
            child: const Text('注册'),
          ),
        ],
      ),
    );
  }

  // 新增操作选择对话框
  void _showActionDialog(DeviceEntity device) {
    Get.dialog(
      AlertDialog(
        title: Text('设备操作 - ${device.address}'),
        content: const Text('请选择要执行的操作'),
        actions: [
          // 取消
          TextButton(onPressed: () => Get.back(), child: const Text('取消')),
          TextButton(
            onPressed: () {
              Get.back();
              _showUpdateDialog(device); // 打开修改对话框
            },
            child: const Text('修改信息'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              _showDeleteDialog(device); // 原有删除逻辑
            },
            child: const Text('删除设备', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // 新增设备修改对话框
  void _showUpdateDialog(DeviceEntity device) {
    final formKey = GlobalKey<FormState>();
    String address = device.address ?? '';
    RxBool isSuperuser = device.isSuperuser.obs;
    String password = '';
    double safeValue = device.safe;
    double warnValue = device.warn;
    double dangerValue = device.danger;

    Get.dialog(
      AlertDialog(
        title: const Text('修改设备信息'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: '密码'),
                  obscureText: true,
                  onSaved: (v) => password = v ?? '',
                  validator: (v) => v?.isEmpty ?? true ? '必填字段' : null,
                ),
                TextFormField(
                  initialValue: address,
                  decoration: const InputDecoration(labelText: '设备地址'),
                  onSaved: (v) => address = v ?? '',
                  validator: (v) => v?.isEmpty ?? true ? '必填字段' : null,
                ),
                TextFormField(
                  initialValue: safeValue.toString(),
                  decoration: const InputDecoration(labelText: '安全值 (mg/m³)'),
                  keyboardType: TextInputType.number,
                  onSaved:
                      (v) => safeValue = double.tryParse(v ?? '0.50') ?? 0.50,
                  validator: (v) => logic.validateThreshold(v),
                ),
                TextFormField(
                  initialValue: warnValue.toString(),
                  decoration: const InputDecoration(labelText: '警告值 (mg/m³)'),
                  keyboardType: TextInputType.number,
                  onSaved:
                      (v) => warnValue = double.tryParse(v ?? '1.00') ?? 1.00,
                  validator: (v) => logic.validateThreshold(v),
                ),
                TextFormField(
                  initialValue: dangerValue.toString(),
                  decoration: const InputDecoration(labelText: '危险值 (mg/m³)'),
                  keyboardType: TextInputType.number,
                  onSaved:
                      (v) => dangerValue = double.tryParse(v ?? '2.00') ?? 2.00,
                  validator: (v) => logic.validateThreshold(v),
                ),
                Obx(
                  () => CheckboxListTile(
                    title: const Text('超级用户'),
                    value: isSuperuser.value,
                    onChanged: (v) => isSuperuser.value = v ?? false,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('取消')),
          TextButton(
            onPressed: () async {
              if (formKey.currentState?.validate() ?? false) {
                formKey.currentState?.save();
                final success = await logic.updateDevice(
                  device,
                  newAddress: address,
                  newIsSuperuser: isSuperuser.value,
                  newPassword: password,
                  safe: safeValue,
                  warn: warnValue,
                  danger: dangerValue,
                );
                if (success) {
                  Get.back();
                  device.safe = safeValue;
                  device.warn = warnValue;
                  device.danger = dangerValue;
                  ToastUtil.okToastNoContent('设备信息已更新');
                  logic.loadDevices();
                } else {
                  ToastUtil.okToastNoContent('更新设备信息时发生错误');
                }
              }
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }
}
