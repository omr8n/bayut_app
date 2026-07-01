import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_graduation/core/enums/property_enums.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';

import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import 'package:test_graduation/features/my_properties/presentation/views/widgets/dashboard_widgets/promotion_sheet.dart';

class PropertyPromotionButton extends StatelessWidget {
  final PropertyEntity property;
  final bool isFullWidth;

  const PropertyPromotionButton({
    super.key,
    required this.property,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Define colors and text based on status
    Color baseColor;
    List<Color> gradientColors;
    String label;
    IconData icon;
    bool isEnabled;
    List<BoxShadow> shadows;

    switch (property.premiumStatus) {
      case PremiumStatus.pending:
        baseColor = const Color(0xFF0288D1); // Sky Blue
        gradientColors = [const Color(0xFF03A9F4), const Color(0xFF0288D1)];
        label = locale.translate(LangKeys.promotionPending);
        icon = Icons.hourglass_top_rounded;
        isEnabled = false;
        shadows = [
          BoxShadow(
            color: baseColor.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ];
        break;
      case PremiumStatus.active:
        baseColor = const Color(0xFFFFA000); // Amber/Gold
        gradientColors = [const Color(0xFFFFC107), const Color(0xFFFFA000)];
        label = locale.translate(LangKeys.featuredPropertyLabel);
        icon = Icons.stars_rounded;
        isEnabled = false;
        shadows = [
          BoxShadow(
            color: baseColor.withValues(alpha: 0.4),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ];
        break;
      case PremiumStatus.rejected:
        baseColor = const Color(0xFFD32F2F); // Red
        gradientColors = [const Color(0xFFEF5350), const Color(0xFFD32F2F)];
        label = locale.translate(LangKeys.promotionRejected);
        icon = Icons.new_releases_rounded;
        isEnabled = true;
        shadows = [
          BoxShadow(
            color: baseColor.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ];
        break;
      default:
        baseColor = const Color(0xFF512DA8); // Indigo/Purple
        gradientColors = [const Color(0xFF673AB7), const Color(0xFF512DA8)];
        label = locale.translate(LangKeys.promotionRequest);
        icon = Icons.auto_awesome_rounded;
        isEnabled = true;
        shadows = [
          BoxShadow(
            color: baseColor.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ];
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? () => _showPromotionDialog(context) : null,
          borderRadius: BorderRadius.circular(15.r),
          child: Container(
            width: isFullWidth ? double.infinity : null,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isEnabled
                    ? gradientColors
                    : gradientColors.map((c) => c.withValues(alpha: 0.6)).toList(),
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15.r),
              boxShadow: isEnabled ? shadows : [],
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 18.sp),
                SizedBox(width: 8.w),
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (property.premiumStatus == PremiumStatus.active) ...[
                  SizedBox(width: 4.w),
                  Icon(Icons.auto_awesome, color: Colors.white.withValues(alpha: 0.8), size: 12.sp),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPromotionDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PromotionSheet(property: property),
    );
  }
}
