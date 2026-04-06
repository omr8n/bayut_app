import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_graduation/core/enums/property_enums.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';

class DashboardActivityTimeline extends StatelessWidget {
  final PropertyEntity property;

  const DashboardActivityTimeline({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    final history = property.statusHistory.reversed.toList();
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: history.isEmpty
          ? const Center(child: Text('لا يوجد سجل حركات مسجل بعد'))
          : ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: history.length,
              separatorBuilder: (_, __) => const SizedBox(height: 20),
              itemBuilder: (context, index) {
                final item = history[index];
                final status = PropertyStatus.values.firstWhere(
                  (e) => e.name == item['status'],
                  orElse: () => PropertyStatus.active,
                );
                final date = item['timestamp'] != null 
                    ? DateTime.parse(item['timestamp']) 
                    : DateTime.now();
                final reason = item['reason'] as String?;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: _getStatusColor(status),
                            shape: BoxShape.circle,
                          ),
                        ),
                        if (index != history.length - 1)
                          Container(width: 2, height: 40, color: Colors.grey.shade200),
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
                                status.arabicName,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              Text(
                                DateFormat('yyyy/MM/dd').format(date),
                                style: const TextStyle(color: Colors.grey, fontSize: 11),
                              ),
                            ],
                          ),
                          if (reason != null && reason.isNotEmpty)
                            Text(
                              reason,
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }

  Color _getStatusColor(PropertyStatus status) {
    switch (status) {
      case PropertyStatus.active: return AppColors.primary;
      case PropertyStatus.sold: return Colors.redAccent;
      case PropertyStatus.underInstallment: return Colors.orange;
    }
  }
}
