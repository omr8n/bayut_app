import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DonutChartCard extends StatelessWidget {
  final String title;
  final Map<String, int> data;
  final Color color;

  const DonutChartCard({
    super.key,
    required this.title,
    required this.data,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    int total = data.values.fold(0, (sum, item) => sum + item);

    final Map<String, Color> statusColors = {
      'sold': const Color(0xFF10B981),
      'active': const Color(0xFF3B82F6),
      'pending': const Color(0xFFF59E0B),
      'rented': const Color(0xFF6366F1),
      'installment': const Color(0xFF06B6D4),
      'on_installment': const Color(0xFF06B6D4),
      'oninstallment': const Color(0xFF06B6D4),
      'underinstallment': const Color(0xFF06B6D4),
      'مميزة': color,
      'عادية': color.withOpacity(0.12),
      'بيع': color,
      'إيجار': color.withOpacity(0.12),
    };

    return Container(
      width: 220,
      height: 280,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 15),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const Spacer(),
          SizedBox(
            height: 100,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 4,
                    centerSpaceRadius: 35,
                    sections: data.entries.map((e) {
                      final key = e.key.toLowerCase().trim();
                      return PieChartSectionData(
                        color: statusColors[key] ?? color.withOpacity(0.3),
                        value: e.value.toDouble(),
                        radius: 12,
                        showTitle: false,
                      );
                    }).toList(),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "$total",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const Text(
                      "إجمالي",
                      style: TextStyle(
                        fontSize: 8,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 80),
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: data.entries.map((e) {
                  final key = e.key.toLowerCase().trim();
                  final percentage = total > 0
                      ? (e.value / total * 100).toStringAsFixed(0)
                      : "0";
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: statusColors[key] ?? color.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            _translateKey(e.key),
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.blueGrey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          "$percentage%",
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _translateKey(String key) {
    final k = key.toLowerCase().trim();
    switch (k) {
      case 'active':
        return 'نشط';
      case 'sold':
        return 'تم البيع';
      case 'pending':
        return 'قيد الانتظار';
      case 'installment':
      case 'on_installment':
      case 'oninstallment':
      case 'underinstallment':
        return 'قيد التقسيط';
      case 'rented':
        return 'مؤجر';
      case 'villas':
        return 'فيلات';
      case 'buildings':
        return 'عمارات';
      case 'housesandapartments':
        return 'بيوت وشقق';
      case 'user':
        return 'مستخدم';
      case 'admin':
        return 'مسؤول';
      case 'مميزة':
        return 'مميزة';
      case 'عادية':
        return 'عادية';
      case 'بيع':
        return 'بيع';
      case 'إيجار':
        return 'إيجار';
      default:
        return key;
    }
  }
}
