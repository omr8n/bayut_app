import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/models/admin_stats_model.dart';

class MainComparisonChart extends StatelessWidget {
  final AdminStats stats;

  const MainComparisonChart({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    local.growth_analysis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    local.performance_comparison,
                    style: TextStyle(fontSize: 11, color: Colors.blueGrey[300]),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.show_chart_rounded, color: Colors.blue, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 220,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: _calculateMax(stats),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => const Color(0xFF1E293B),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${rodIndex == 0 ? local.users_label : local.properties_label}\n',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                        children: [
                          TextSpan(
                            text: rod.toY.toInt().toString(),
                            style: const TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        int idx = value.toInt();
                        if (idx >= 0 && idx < stats.userGrowth.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Text(
                              stats.userGrowth[idx].label,
                              style: TextStyle(
                                color: Colors.blueGrey[200],
                                fontWeight: FontWeight.bold,
                                fontSize: 9,
                              ),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                      reservedSize: 35,
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(stats.userGrowth.length, (i) {
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: stats.userGrowth[i].value,
                        color: const Color(0xFF6366F1),
                        width: 6,
                        borderRadius: BorderRadius.circular(10),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: _calculateMax(stats),
                          color: const Color(0xFFF1F5F9),
                        ),
                      ),
                      BarChartRodData(
                        toY: stats.propertyGrowth[i].value,
                        color: const Color(0xFF10B981),
                        width: 6,
                        borderRadius: BorderRadius.circular(10),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: _calculateMax(stats),
                          color: const Color(0xFFF1F5F9),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _legendBullet(const Color(0xFF6366F1), local.users_label),
              const SizedBox(width: 24),
              _legendBullet(const Color(0xFF10B981), local.properties_label),
            ],
          ),
        ],
      ),
    );
  }

  double _calculateMax(AdminStats stats) {
    double maxU = 0;
    for (var d in stats.userGrowth) {
      if (d.value > maxU) maxU = d.value;
    }
    double maxP = 0;
    for (var d in stats.propertyGrowth) {
      if (d.value > maxP) maxP = d.value;
    }
    return (maxU > maxP ? maxU : maxP) * 1.2 + 5;
  }

  Widget _legendBullet(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
