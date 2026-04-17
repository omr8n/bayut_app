import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import 'package:test_graduation/core/enums/property_enums.dart';

class AdminPropertiesStats extends StatelessWidget {
  const AdminPropertiesStats({super.key, required this.properties});

  final List<PropertyEntity> properties;

  @override
  Widget build(BuildContext context) {
    final forSale = properties.where((p) => p.listingType == ListingType.sale).length;
    final forRent = properties.where((p) => p.listingType == ListingType.rent).length;
    final featured = properties.where((p) => p.isFeatured).length;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade100, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('الإجمالي', '${properties.length}', const Color(0xFF1E4C9A)),
          _buildStatItem('للبيع', '$forSale', const Color(0xFF2E7D32)),
          _buildStatItem('للإيجار', '$forRent', const Color(0xFF0288D1)),
          _buildStatItem('مميز', '$featured', const Color(0xFFFBC02D)),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
