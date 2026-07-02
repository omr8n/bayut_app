import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import 'package:test_graduation/features/my_properties/presentation/manager/my_properties_cubit.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_settings_cubit/admin_settings_cubit.dart';

class PromotionSheet extends StatefulWidget {
  final PropertyEntity property;
  const PromotionSheet({super.key, required this.property});

  @override
  State<PromotionSheet> createState() => _PromotionSheetState();
}

class _PromotionSheetState extends State<PromotionSheet> {
  int _selectedPackage = 1;
  @override
  Widget build(BuildContext context) {
    final config = context.read<AdminSettingsCubit>().currentConfig;
    final String currency = config?.baseCurrency ?? 'ل.س';
    final double weeklyPrice = config?.weeklyFeaturedPrice ?? 5000.0;
    final double monthlyPrice = config?.monthlyFeaturedPrice ?? 15000.0;
    final locale = AppLocalizations.of(context)!;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? Colors.white24 : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            locale.translate(LangKeys.featureProperty),
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          SizedBox(height: 32.h),
          _buildPackageItem(
            0,
            locale.translate(LangKeys.weeklyPackage),
            weeklyPrice.toStringAsFixed(0),
            currency,
            Icons.bolt_rounded,
            Colors.blue,
          ),
          SizedBox(height: 16.h),
          _buildPackageItem(
            1,
            locale.translate(LangKeys.monthlyPackage),
            monthlyPrice.toStringAsFixed(0),
            currency,
            Icons.stars_rounded,
            Colors.amber.shade700,
          ),
          SizedBox(height: 32.h),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showConfirmPaymentDialog(
                context,
                _selectedPackage == 0 ? weeklyPrice : monthlyPrice,
                _selectedPackage == 0 ? 7 : 30, // 🔥 تمرير عدد الأيام
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: Size(double.infinity, 55.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r),
              ),
            ),
            child: Text(
              locale.translate(LangKeys.payNow),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageItem(
    int index,
    String title,
    String price,
    String currency,
    IconData icon,
    Color color,
  ) {
    bool isSelected = _selectedPackage == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => setState(() => _selectedPackage = index),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: isDark ? 0.15 : 0.05)
              : (isDark ? AppColors.darkSurface : Colors.white),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected
                ? color
                : (isDark ? Colors.white10 : Colors.grey.shade200),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    price,
                    style: TextStyle(
                      color: isDark && !isSelected ? Colors.white70 : color,
                      fontWeight: FontWeight.w900,
                      fontSize: 18.sp,
                    ),
                  ),
                  Text(
                    currency,
                    style: TextStyle(
                      color: isDark && !isSelected ? Colors.white54 : color,
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              icon,
              color: isDark && !isSelected ? Colors.white38 : color,
              size: 28.sp,
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmPaymentDialog(
    BuildContext context,
    double amount,
    int days,
  ) {
    showDialog(
      context: context,
      builder: (context) => _ConfirmPaymentDialog(
        property: widget.property,
        amount: amount,
        days: days,
      ),
    );
  }
}

class _ConfirmPaymentDialog extends StatefulWidget {
  final PropertyEntity property;
  final double amount;
  final int days; // 🔥 جديد
  const _ConfirmPaymentDialog({
    required this.property,
    required this.amount,
    required this.days,
  });

  @override
  State<_ConfirmPaymentDialog> createState() => _ConfirmPaymentDialogState();
}

class _ConfirmPaymentDialogState extends State<_ConfirmPaymentDialog> {
  int _selectedMethod = 0;
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AlertDialog(
      backgroundColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.r)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            locale.translate(LangKeys.confirmPayment),
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          SizedBox(height: 24.h),
          _buildMethodTile(0, locale.translate(LangKeys.syrianBankCard)),
          _buildMethodTile(1, locale.translate(LangKeys.cashMethod)),
          SizedBox(height: 24.h),
          Row(
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  locale.translate(LangKeys.cancel),
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.grey.shade600,
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<MyPropertiesCubit>().requestPromotion(
                      widget.property,
                      amount: widget.amount, // 🔥 تمرير المبلغ الفعلي من الإعدادات
                      days: widget.days, // 🔥 تمرير عدد الأيام
                    );
                    Navigator.pop(context); // إغلاق دايالوج التأكيد
                    _showSuccessDialog(
                      context,
                    ); // 🔥 إظهار رسالة النجاح الجمالية
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    locale.translate(LangKeys.payNow),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMethodTile(int index, String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return RadioListTile(
      value: index,
      groupValue: _selectedMethod,
      activeColor: AppColors.primary,
      onChanged: (val) => setState(() => _selectedMethod = val as int),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 13.sp,
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: TweenAnimationBuilder(
                  duration: const Duration(seconds: 1),
                  tween: Tween<double>(begin: 0, end: 1),
                  builder: (context, double value, child) {
                    return Transform.translate(
                      offset: Offset(0, -20 * (1 - value)),
                      child: Opacity(
                        opacity: value,
                        child: const Icon(
                          Icons.rocket_launch_rounded,
                          color: Colors.green,
                          size: 60,
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                locale.promotion_success_title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                locale.promotion_processing_msg,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: isDark ? Colors.white70 : Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 32.h),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close success dialog
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context); // Close Confirm Payment dialog
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: Size(double.infinity, 50.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  locale.translate(LangKeys.doneAction),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
