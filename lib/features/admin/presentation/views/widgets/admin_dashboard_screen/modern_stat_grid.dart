import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/core/models/admin_stats_model.dart';
import 'package:test_graduation/core/routing/app_routes.dart';
import 'modern_stat_card.dart';

import 'package:test_graduation/core/language/app_localizations.dart';

class ModernStatGrid extends StatelessWidget {
  final AdminStats stats;

  const ModernStatGrid({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    double calculateTrend(List<ChartDataPoint> growth) {
      if (growth.length < 2) return 0;
      return growth.last.value - growth[growth.length - 2].value;
    }

    double userTrend = calculateTrend(stats.userGrowth);
    double propTrend = calculateTrend(stats.propertyGrowth);
    double revenueTrend = calculateTrend(stats.revenueGrowth);

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.05,
      children: [
        ModernStatCard(
          title: local.total_users_label,
          value: stats.totalUsers.toString(),
          trend: userTrend >= 0 ? "+${userTrend.toInt()}" : "${userTrend.toInt()}",
          isUp: userTrend >= 0,
          icon: Icons.people_alt_rounded,
          color: const Color(0xFF6366F1),
          data: stats.userGrowth,
          onTap: () => context.pushNamed(AppRoutes.adminUsers),
        ),
        ModernStatCard(
          title: local.total_properties_label,
          value: stats.totalProperties.toString(),
          trend: propTrend >= 0 ? "+${propTrend.toInt()}" : "${propTrend.toInt()}",
          isUp: propTrend >= 0,
          icon: Icons.home_rounded,
          color: const Color(0xFF3B82F6),
          data: stats.propertyGrowth,
          onTap: () => context.pushNamed(AppRoutes.adminProperties),
        ),
        ModernStatCard(
          title: local.active_reports,
          value: stats.pendingReports.toString(),
          trend: stats.pendingReports > 0 ? local.urgent : local.stable,
          isUp: stats.pendingReports == 0,
          icon: Icons.warning_amber_rounded,
          color: const Color(0xFFEF4444),
          onTap: () => context.pushNamed(AppRoutes.adminReports),
        ),
        ModernStatCard(
          title: local.estimated_revenue,
          value: "${stats.yearly.totalRevenue.toInt()} ${local.currency_lira}",
          trend: revenueTrend >= 0 ? "+${revenueTrend.toInt()}" : "${revenueTrend.toInt()}",
          isUp: revenueTrend >= 0,
          icon: Icons.monetization_on_rounded,
          color: const Color(0xFF10B981),
          data: stats.revenueGrowth,
        ),
      ],
    );
  }
}
