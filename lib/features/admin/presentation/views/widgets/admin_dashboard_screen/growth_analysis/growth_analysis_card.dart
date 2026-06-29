import 'package:flutter/material.dart';
import 'package:test_graduation/core/models/admin_stats_model.dart';
import 'growth_analysis_header.dart';
import 'growth_analysis_legend.dart';
import 'growth_analysis_chart.dart';

class GrowthAnalysisCard extends StatelessWidget {
  final AdminStats stats;

  const GrowthAnalysisCard({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
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
          const GrowthAnalysisHeader(),
          const SizedBox(height: 24),
          GrowthAnalysisLegend(
            totalUsers: stats.totalUsers,
            totalProperties: stats.totalProperties,
          ),
          const SizedBox(height: 32),
          GrowthAnalysisChart(
            userGrowth: stats.userGrowth,
            propertyGrowth: stats.propertyGrowth,
          ),
        ],
      ),
    );
  }
}
