import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import 'package:test_graduation/core/enums/property_enums.dart';

class AdminPropertiesStats extends StatelessWidget {
  const AdminPropertiesStats({super.key, required this.properties});

  final List<PropertyEntity> properties;

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final forSale = properties.where((p) => p.listingType == ListingType.sale).length;
    final forRent = properties.where((p) => p.listingType == ListingType.rent).length;
    final featured = properties.where((p) => p.isFeatured || p.premiumStatus == PremiumStatus.active).length;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(context, local.total_label, '${properties.length}', Theme.of(context).brightness == Brightness.dark ? Colors.white : const Color(0xFF1E4C9A)),
          _buildStatItem(context, local.for_sale, '$forSale', const Color(0xFF2E7D32)),
          _buildStatItem(context, local.for_rent, '$forRent', const Color(0xFF0288D1)),
          _buildStatItem(context, local.featured_label, '$featured', AppColors.primary),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value, Color color) {
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
            color: Theme.of(context).brightness == Brightness.dark ? AppColors.textSecondaryDark : AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
