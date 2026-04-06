import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_graduation/core/enums/property_enums.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import 'package:test_graduation/features/my_properties/presentation/manager/my_properties_cubit.dart';

class DashboardStatsGrid extends StatelessWidget {
  final PropertyEntity property;

  const DashboardStatsGrid({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _StatCard(
          title: 'إجمالي المشاهدات',
          value: '${property.views}',
          icon: Icons.visibility_rounded,
          color: AppColors.primary,
        ),
        _StatCard(
          title: 'الحالة الحالية',
          value: property.status.arabicName,
          icon: Icons.info_outline_rounded,
          color: _getStatusColor(property.status),
        ),
        _StatCard(
          title: 'نوع العقار',
          value: property.type.name,
          icon: Icons.home_work_rounded,
          color: Colors.blue,
        ),
        _StatCard(
          title: 'حالة التميز',
          value: property.isFeatured ? 'عقار مميز' : 'عادي',
          icon: property.isFeatured
              ? Icons.star_rounded
              : Icons.star_border_rounded,
          color: Colors.amber.shade700,
          onTap: () =>
              context.read<MyPropertiesCubit>().toggleFeatured(property),
        ),
      ],
    );
  }

  Color _getStatusColor(PropertyStatus status) {
    switch (status) {
      case PropertyStatus.active:
        return AppColors.primary;
      case PropertyStatus.sold:
        return Colors.redAccent;
      case PropertyStatus.underInstallment:
        return Colors.orange;
    }
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 22),
            SizedBox(height: 8.h),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              title,
              style: TextStyle(fontSize: 10.sp, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
