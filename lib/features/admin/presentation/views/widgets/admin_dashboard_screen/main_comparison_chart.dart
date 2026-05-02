import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:test_graduation/core/models/admin_stats_model.dart';

class MainComparisonChart extends StatelessWidget {
  final AdminStats stats;

  const MainComparisonChart({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 24, 24, 20),
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E293B).withOpacity(0.05),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
        border: Border.all(color: Colors.white, width: 1),
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
                  const Text(
                    "تحليل النمو التراكمي",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "مقارنة أداء المستخدمين والعقارات",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blueGrey[300],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              _buildSimpleLegend(),
            ],
          ),
          const SizedBox(height: 32),
          AspectRatio(
            aspectRatio: 1.7,
            child: LineChart(
              LineChartData(
                lineTouchData: LineTouchData(
                  handleBuiltInTouches: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (spot) => const Color(0xFF1E293B),
                    tooltipBorderRadius: BorderRadius.circular(12),
                    tooltipPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        return LineTooltipItem(
                          '${spot.barIndex == 0 ? "المستخدمين" : "العقارات"}\n',
                          const TextStyle(color: Colors.white70, fontSize: 10),
                          children: [
                            TextSpan(
                              text: spot.y.toInt().toString(),
                              style: TextStyle(
                                color: spot.bar.color,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        );
                      }).toList();
                    },
                  ),
                  getTouchedSpotIndicator: (barData, spotIndexes) {
                    return spotIndexes.map((index) {
                      return TouchedSpotIndicatorData(
                        FlLine(
                          color: barData.color?.withOpacity(0.1),
                          strokeWidth: 4,
                        ),
                        FlDotData(
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 4,
                              color: Colors.white,
                              strokeWidth: 3,
                              strokeColor: barData.color ?? Colors.blue,
                            );
                          },
                        ),
                      );
                    }).toList();
                  },
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.blueGrey.withOpacity(0.05),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index >= 0 && index < stats.userGrowth.length) {
                          bool isStart = index == 0;
                          bool isEnd = index == stats.userGrowth.length - 1;
                          bool isMid =
                              index == (stats.userGrowth.length / 2).floor();

                          if (isStart || isEnd || isMid) {
                            return SideTitleWidget(
                              meta: meta,
                              space: 10,
                              child: Text(
                                stats.userGrowth[index].label,
                                style: TextStyle(
                                  color: Colors.blueGrey[300],
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        if (value == meta.min ||
                            value == meta.max ||
                            (meta.max > 0 &&
                                value % (meta.max / 2).ceil() == 0)) {
                          return Text(
                            value.toInt().toString(),
                            style: TextStyle(
                              color: Colors.blueGrey[200],
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  _buildLine(stats.userGrowth, const Color(0xFF6366F1)),
                  _buildLine(stats.propertyGrowth, const Color(0xFF10B981)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleLegend() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FD),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _legendBullet(const Color(0xFF6366F1), "المستخدمين"),
          const SizedBox(width: 16),
          _legendBullet(const Color(0xFF10B981), "العقارات"),
        ],
      ),
    );
  }

  Widget _legendBullet(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.blueGrey[700],
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  LineChartBarData _buildLine(List<ChartDataPoint> data, Color color) {
    return LineChartBarData(
      spots: data
          .asMap()
          .entries
          .map((e) => FlSpot(e.key.toDouble(), e.value.value.toDouble()))
          .toList(),
      isCurved: true,
      curveSmoothness: 0.35,
      color: color,
      barWidth: 4,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color.withOpacity(0.12),
            color.withOpacity(0.02),
            color.withOpacity(0),
          ],
          stops: const [0, 0.8, 1],
        ),
      ),
    );
  }
}
