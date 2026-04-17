import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartsScreen extends StatelessWidget {
  const ChartsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Charts & Analytics"),
        centerTitle: true,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===================== TITLE =====================
            const Text(
              "إحصائيات عامة",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // ===================== BAR CHART CARD =====================
            _chartCard(
              title: "المبيعات الشهرية",
              child: SizedBox(
                height: 220,
                child: BarChart(
                  BarChartData(
                    borderData: FlBorderData(show: false),
                    gridData: const FlGridData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: true),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (v, meta) {
                            const labels = [
                              "ينا",
                              "فبر",
                              "مار",
                              "أبر",
                              "ماي",
                              "يون",
                            ];
                            return Text(labels[v.toInt()]);
                          },
                        ),
                      ),
                    ),
                    barGroups: List.generate(6, (i) {
                      return BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: (i + 1) * 15.0,
                            width: 14,
                            color: Colors.blue,
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ===================== PIE CHART CARD =====================
            _chartCard(
              title: "توزيع المنتجات حسب الفئة",
              child: SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 45,
                    sections: [
                      PieChartSectionData(
                        title: 'أجهزة',
                        value: 40,
                        color: Colors.orange,
                        titleStyle: const TextStyle(color: Colors.white),
                      ),
                      PieChartSectionData(
                        title: 'ملابس',
                        value: 25,
                        color: Colors.blue,
                        titleStyle: const TextStyle(color: Colors.white),
                      ),
                      PieChartSectionData(
                        title: 'أثاث',
                        value: 20,
                        color: Colors.green,
                        titleStyle: const TextStyle(color: Colors.white),
                      ),
                      PieChartSectionData(
                        title: 'أخرى',
                        value: 15,
                        color: Colors.purple,
                        titleStyle: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ===================== LINE CHART CARD =====================
            _chartCard(
              title: "معدل الزيارات خلال الأسبوع",
              child: SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (v, meta) {
                            const days = ["س", "أ", "ث", "ر", "خ", "ج", "س"];
                            return Text(days[v.toInt()]);
                          },
                        ),
                      ),
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: true),
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        isCurved: true,
                        color: Colors.red,
                        barWidth: 3,
                        dotData: const FlDotData(show: false),
                        spots: [
                          const FlSpot(0, 10),
                          const FlSpot(1, 18),
                          const FlSpot(2, 5),
                          const FlSpot(3, 22),
                          const FlSpot(4, 15),
                          const FlSpot(5, 25),
                          const FlSpot(6, 20),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ===================== CARD WRAPPER =====================
  Widget _chartCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
