import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_graduation/core/utils/colors.dart';

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
      width: 170.w,
      height: 240.h,
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsetsDirectional.only(end: 12.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              Theme.of(context).brightness == Brightness.dark ? 0.2 : 0.02,
            ),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 110.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 38.r,
                    startDegreeOffset: -90,
                    sections: data.entries.map((e) {
                      final key = e.key.toLowerCase().trim();
                      return PieChartSectionData(
                        color: statusColors[key] ?? color.withOpacity(0.3),
                        value: e.value.toDouble(),
                        radius: 10.r,
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
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : const Color(0xFF1E293B),
                        fontFamily: 'Cairo',
                      ),
                    ),
                    Text(
                      local.total_label,
                      style: TextStyle(
                        fontSize: 9.sp,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.textSecondaryDark
                            : Colors.grey.shade400,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          Column(
            children: data.entries.map((e) {
              final key = e.key.toLowerCase().trim();
              final percentage = total > 0
                  ? (e.value / total * 100).toStringAsFixed(0)
                  : "0";
              return Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Row(
                  children: [
                    Container(
                      width: 7.w,
                      height: 7.w,
                      decoration: BoxDecoration(
                        color: statusColors[key] ?? color.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      percentage == "0" ? "0%" : "$percentage%",
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : const Color(0xFF1E293B),
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _translateKey(e.key, local),
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.textSecondaryDark
                            : Colors.grey.shade400,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
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
