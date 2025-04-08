import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'logic.dart';
import 'state.dart';

class DeviceDetailPage extends StatelessWidget {
  DeviceDetailPage({super.key});

  final DeviceDetailLogic logic = Get.put(DeviceDetailLogic());
  final DeviceDetailState state = Get.find<DeviceDetailLogic>().state;

  @override
  Widget build(BuildContext context) {
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
                      child: SfRadialGauge(
                        axes: [
                          RadialAxis(
                            minimum: 0,
                            maximum: 0.5,
                            interval: 0.1,
                            ranges: [
                              GaugeRange(
                                startValue: 0,
                                endValue: 0.08,
                                color: Colors.green,
                              ),
                              GaugeRange(
                                startValue: 0.08,
                                endValue: 0.2,
                                color: Colors.orange,
                              ),
                              GaugeRange(
                                startValue: 0.2,
                                endValue: 0.5,
                                color: Colors.red,
                              ),
                            ],
                            pointers: [
                              NeedlePointer(
                                value: 0.15, // 示例数据，实际替换为您的数据
                                enableAnimation: true,
                              ),
                            ],
                            annotations: [
                              GaugeAnnotation(
                                widget: Text(
                                  '0.15',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                angle: 85,
                                positionFactor: 0.5,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildStatusIndicator(context),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                          context,
                          '最高浓度',
                          '0.18',
                          Icons.arrow_upward,
                          Colors.red,
                        ),
                        _buildStatItem(
                          context,
                          '平均浓度',
                          '0.12',
                          Icons.trending_flat,
                          Colors.orange,
                        ),
                        _buildStatItem(
                          context,
                          '最低浓度',
                          '0.08',
                          Icons.arrow_downward,
                          Colors.green,
                        ),
                      ],
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
  Widget _buildStatusIndicator(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '轻度污染',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.orange,
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
