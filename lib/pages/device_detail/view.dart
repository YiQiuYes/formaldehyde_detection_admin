import 'package:flutter/material.dart';
import 'package:formaldehyde_detection/entity/device_entity.dart';
import 'package:formaldehyde_detection/state/global_logic.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'logic.dart';
import 'state.dart';

class DeviceDetailPage extends StatelessWidget {
  DeviceDetailPage({super.key});

  final DeviceDetailLogic logic = Get.put(DeviceDetailLogic());
  final DeviceDetailState state = Get.find<DeviceDetailLogic>().state;

  final DeviceEntity device = Get.arguments as DeviceEntity;

  @override
  Widget build(BuildContext context) {
    logic.loadTodayStatistics(device.clientId!);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '甲醛浓度监测',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 仪表盘卡片
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Text(
                      '当前甲醛浓度 mg/m³',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 250,
                      child: GetBuilder<GlobalLogic>(
                        builder: (globalLogic) {
                          final concentration = logic
                              .getFormaldehydeConcentration(
                                device,
                                globalLogic.state.devices,
                              );
                          return SfRadialGauge(
                            enableLoadingAnimation: true,
                            axes: [
                              RadialAxis(
                                minimum: 0,
                                maximum: device.danger,
                                interval: (device.danger - device.safe) / 4,
                                ranges: [
                                  GaugeRange(
                                    startValue: 0,
                                    endValue: device.safe,
                                    color: Colors.green,
                                  ),
                                  GaugeRange(
                                    startValue: device.safe,
                                    endValue: device.warn,
                                    color: Colors.orange,
                                  ),
                                  GaugeRange(
                                    startValue: device.warn,
                                    endValue: device.danger,
                                    color: Colors.red,
                                  ),
                                ],
                                pointers: [
                                  NeedlePointer(
                                    value: concentration,
                                    enableAnimation: true,
                                  ),
                                ],
                                annotations: [
                                  GaugeAnnotation(
                                    widget: Text(
                                      concentration.toStringAsFixed(2),
                                      style: Theme.of(
                                        context,
                                      ).textTheme.headlineMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    angle: 85,
                                    positionFactor: 0.5,
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    GetBuilder<GlobalLogic>(
                      builder: (globalLogic) {
                        final concentration = logic
                            .getFormaldehydeConcentration(
                              device,
                              globalLogic.state.devices,
                            );
                        return _buildStatusIndicator(context, concentration, device);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // 数据统计卡片
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '今日数据统计',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          '单位: mg/m³',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    GetBuilder<DeviceDetailLogic>(
                      builder: (logic) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatItem(
                              context,
                              '最高浓度',
                              (state.ch2oTodayStatistic.value.max / 1000)
                                  .toStringAsFixed(2),
                              Icons.arrow_upward,
                              Colors.red,
                            ),
                            _buildStatItem(
                              context,
                              '平均浓度',
                              (state.ch2oTodayStatistic.value.avg / 1000)
                                  .toStringAsFixed(2),
                              Icons.trending_flat,
                              Colors.orange,
                            ),
                            _buildStatItem(
                              context,
                              '最低浓度',
                              (state.ch2oTodayStatistic.value.min / 1000)
                                  .toStringAsFixed(2),
                              Icons.arrow_downward,
                              Colors.green,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建状态指示器
  ///
  /// [context] 上下文
  /// [return] 状态指示器
  Widget _buildStatusIndicator(BuildContext context, double concentration, DeviceEntity device) {
    String tip = '良好';
    Color color = Colors.green;
    if (concentration > device.warn) {
      tip = '重度污染';
      color = Colors.red;
    } else if (concentration > device.safe) {
      tip = '中度污染';
      color = Colors.pinkAccent;
    } else {
      tip = '空气良好';
      color = Colors.green;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          tip,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  /// 构建统计项
  ///
  /// [context] 上下文
  /// [title] 标题
  /// [value] 值
  /// [icon] 图标
  /// [color] 颜色
  /// [return] 统计项
  Widget _buildStatItem(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(title, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
