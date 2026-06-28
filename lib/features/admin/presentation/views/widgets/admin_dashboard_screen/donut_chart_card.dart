import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:test_graduation/core/language/app_localizations.dart';

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
    final local = AppLocalizations.of(context)!;
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
      local.featured_label: color,
      local.normal_label: color.withOpacity(0.12),
      local.sale: color,
      local.rent: color.withOpacity(0.12),
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
                    Text(
                      local.total_label,
                      style: const TextStyle(
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
                            _translateKey(e.key, local),
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

  String _translateKey(String key, AppLocalizations local) {
    final k = key.toLowerCase().trim();
    switch (k) {
      case 'active':
        return local.active;
      case 'sold':
        return local.sold;
      case 'pending':
        return local.status_pending;
      case 'installment':
      case 'on_installment':
      case 'oninstallment':
      case 'underinstallment':
        return local.under_installment;
      case 'rented':
        return local.rented;
      case 'villas':
        return local.villas;
      case 'buildings':
        return local.buildings;
      case 'houses_and_apartments':
      case 'housesandapartments':
        return local.houses_and_apartments;
      case 'under_construction':
      case 'underconstruction':
        return local.under_construction;
      case 'shops':
        return local.shops;
      case 'mall_shops':
        return local.mall_shops;
      case 'lands':
        return local.lands;
      case 'farms':
        return local.farms;
      case 'pools':
        return local.pools;
      case 'clinics':
        return local.clinics;
      case 'warehouses':
        return local.warehouses;
      case 'halls':
        return local.halls;
      case 'offices':
        return local.offices;
      case 'workshops':
        return local.workshops;
      case 'user':
        return local.user_label;
      case 'admin':
        return local.admins;
      case 'featured':
        return local.featured_label;
      case 'normal':
        return local.normal_label;
      case 'sale':
        return local.sale;
      case 'rent':
        return local.rent;
      default:
        return key;
    }
  }
}
