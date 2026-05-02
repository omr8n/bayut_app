import 'package:flutter/material.dart';
import 'package:test_graduation/core/models/admin_stats_model.dart';

class RecentActivityTable extends StatelessWidget {
  final AdminStats stats;

  const RecentActivityTable({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 15),
        ],
      ),
      child: Column(
        children: [
          _buildActivityRow(
            "مستخدمين جدد",
            stats.daily.newUsers.toString(),
            Colors.orange,
            Icons.person_add_rounded,
          ),
          const Divider(height: 1),
          _buildActivityRow(
            "عقارات مضافة",
            stats.daily.newProperties.toString(),
            Colors.blue,
            Icons.add_home_work_rounded,
          ),
          const Divider(height: 1),
          _buildActivityRow(
            "عمليات بيع",
            stats.daily.soldProperties.toString(),
            Colors.green,
            Icons.verified_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityRow(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
    );
  }
}
