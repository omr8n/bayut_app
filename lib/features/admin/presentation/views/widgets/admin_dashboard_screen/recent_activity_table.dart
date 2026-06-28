import 'package:flutter/material.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/models/admin_stats_model.dart';

class RecentActivityTable extends StatelessWidget {
  final AdminStats stats;

  const RecentActivityTable({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15),
        ],
      ),
      child: Column(
        children: [
          _buildRow(
            local.new_users,
            stats.daily.newUsers.toString(),
            const Color(0xFF6366F1),
          ),
          _buildRow(
            local.added_properties,
            stats.daily.newProperties.toString(),
            const Color(0xFF10B981),
          ),
          _buildRow(
            local.sales_transactions,
            stats.daily.soldProperties.toString(),
            const Color(0xFFF59E0B),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String title, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }
}
