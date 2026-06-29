import 'package:flutter/material.dart';
import 'package:test_graduation/core/models/admin_stats_model.dart';
import 'growth_analysis/growth_analysis_card.dart';

class MainComparisonChart extends StatelessWidget {
  final AdminStats stats;

  const MainComparisonChart({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return GrowthAnalysisCard(stats: stats);
  }
}
