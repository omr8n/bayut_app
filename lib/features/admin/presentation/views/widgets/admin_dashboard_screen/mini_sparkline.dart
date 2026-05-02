import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:test_graduation/core/models/admin_stats_model.dart';

class MiniSparkline extends StatelessWidget {
  final Color color;
  final List<ChartDataPoint> data;

  const MiniSparkline({super.key, required this.color, required this.data});

  @override
  Widget build(BuildContext context) {
    final spots = data.length > 6
        ? data
            .sublist(data.length - 6)
            .asMap()
            .entries
            .map((e) => FlSpot(e.key.toDouble(), e.value.value))
            .toList()
        : data
            .asMap()
            .entries
            .map((e) => FlSpot(e.key.toDouble(), e.value.value))
            .toList();

    return SizedBox(
      height: 35,
      width: 70,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineTouchData: const LineTouchData(enabled: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.4,
              color: color,
              barWidth: 2.5,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [color.withOpacity(0.15), color.withOpacity(0)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
