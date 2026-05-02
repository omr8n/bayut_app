import 'package:flutter/material.dart';
import 'package:test_graduation/core/models/admin_stats_model.dart';

class RecentActivityTimeline extends StatelessWidget {
  final AdminStats stats;

  const RecentActivityTimeline({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final activities = [
      {
        'title': 'مستخدمين جدد',
        'value': stats.daily.newUsers.toString(),
        'color': Colors.orange,
        'icon': Icons.person_add_rounded,
        'subtitle': 'انضموا للمنصة اليوم'
      },
      {
        'title': 'عقارات مضافة',
        'value': stats.daily.newProperties.toString(),
        'color': Colors.blue,
        'icon': Icons.add_home_work_rounded,
        'subtitle': 'تم إدراجها حديثاً'
      },
      {
        'title': 'عمليات بيع',
        'value': stats.daily.soldProperties.toString(),
        'color': Colors.green,
        'icon': Icons.verified_rounded,
        'subtitle': 'عقارات تم بيعها بنجاح'
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: List.generate(activities.length, (index) {
          final item = activities[index];
          final bool isLast = index == activities.length - 1;

          return IntrinsicHeight(
            child: Row(
              children: [
                Column(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: (item['color'] as Color).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        item['icon'] as IconData,
                        color: item['color'] as Color,
                        size: 20,
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                (item['color'] as Color).withOpacity(0.5),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item['title'] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: (item['color'] as Color).withOpacity(0.05),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: (item['color'] as Color).withOpacity(0.1)),
                            ),
                            child: Text(
                              item['value'] as String,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: item['color'] as Color,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        item['subtitle'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blueGrey[300],
                        ),
                      ),
                      if (!isLast) const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
