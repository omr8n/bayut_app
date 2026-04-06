import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/core/utils/strings_ar.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';

class PropertyDetailsInstallment extends StatelessWidget {
  final PropertyEntity property;
  final NumberFormat format;

  const PropertyDetailsInstallment({
    super.key,
    required this.property,
    required this.format,
  });

  @override
  Widget build(BuildContext context) {
    if (!property.hasInstallment) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24.h),
        _buildSectionTitle(AppStrings.installmentAvailable),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.primary.withOpacity(0.1)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInstallmentItem(
                    AppStrings.downPayment,
                    '${format.format(property.downPayment ?? 0)} ${property.currency}',
                    Icons.payments_outlined,
                  ),
                  _buildInstallmentItem(
                    AppStrings.monthlyInstallment,
                    '${format.format(property.monthlyInstallment ?? 0)} ${property.currency}',
                    Icons.calendar_month_outlined,
                  ),
                ],
              ),
              Divider(height: 24.h, color: AppColors.primary.withOpacity(0.1)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInstallmentItem(
                    AppStrings.installmentDuration,
                    '${property.installmentDuration ?? 0} ${AppStrings.months}',
                    Icons.timer_outlined,
                  ),
                ],
              ),
              if (property.installmentNotes != null && property.installmentNotes!.isNotEmpty) ...[
                Divider(height: 24.h, color: AppColors.primary.withOpacity(0.1)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, size: 20.sp, color: AppColors.primary),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.installmentNotes,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            property.installmentNotes!,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Text(
        title,
        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInstallmentItem(String label, String value, IconData icon) {
    return Expanded(
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20.sp, color: AppColors.primary),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
