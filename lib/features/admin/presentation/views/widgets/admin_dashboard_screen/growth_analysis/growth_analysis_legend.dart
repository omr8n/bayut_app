import 'package:flutter/material.dart';
import 'package:test_graduation/core/language/app_localizations.dart';

class GrowthAnalysisLegend extends StatelessWidget {
  final int totalUsers;
  final int totalProperties;

  const GrowthAnalysisLegend({
    super.key,
    required this.totalUsers,
    required this.totalProperties,
  });

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _legendBullet(
          context,
          const Color(0xFF10B981),
          "${local.properties_label} ($totalProperties)",
        ),
        const SizedBox(width: 16),
        _legendBullet(
          context,
          const Color(0xFF6366F1),
          "${local.users_label} ($totalUsers)",
        ),
      ],
    );
  }

  Widget _legendBullet(BuildContext context, Color color, String label) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.white70 : const Color(0xFF64748B),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
      ],
    );
  }
}
