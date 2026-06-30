import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_graduation/core/enums/property_enums.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/home/presentation/view/widgets/details_view_widgets/report_bottom_sheet.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';

class PropertyDetailsHeader extends StatelessWidget {
  final PropertyEntity property;
  final NumberFormat format;

  const PropertyDetailsHeader({
    super.key,
    required this.property,
    required this.format,
  });

  @override
  Widget build(BuildContext context) {
    final isAr = AppLocalizations.of(context)!.isEnLocale == false;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. صف الشارات (Badges) + زر الإبلاغ
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildBadge(
                    context,
                    property.listingType.localizedName(context),
                    property.listingType == ListingType.sale
                        ? AppColors.success
                        : AppColors.primary,
                  ),
                  if (property.isLicensed)
                    _buildBadge(
                      context,
                      AppLocalizations.of(
                            context,
                          )?.translate(LangKeys.licensedProperty) ??
                          'عقار مرخص',
                      AppColors.success,
                      icon: Icons.check_circle,
                    ),
                  _buildBadge(
                    context,
                    property.type.localizedName(context),
                    isDark ? Colors.white : AppColors.primary,
                    isLight: true,
                  ),
                ],
              ),
            ),

            // زر الإبلاغ الأنيق
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => ReportBottomSheet(property: property),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: isDark ? 0.2 : 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.error.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.report_gmailerrorred_rounded,
                      size: 16,
                      color: AppColors.error,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      AppLocalizations.of(context)!.translate(LangKeys.report),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // 2. السعر
        SizedBox(
          width: double.infinity,
          child: Text(
            '${format.format(property.price)} ${AppLocalizations.of(context)?.translate(property.currency.trim().toLowerCase()) ?? property.currency}',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : AppColors.primary,
            ),
            textAlign: isAr ? TextAlign.right : TextAlign.left,
          ),
        ),

        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildBadge(
    BuildContext context,
    String text,
    Color color, {
    IconData? icon,
    bool isLight = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(
          alpha: Theme.of(context).brightness == Brightness.dark ? 0.2 : 0.1,
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 14,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : color,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : color,
            ),
          ),
        ],
      ),
    );
  }
}
