import 'package:flutter/material.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';

import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';

class PropertyDetailsMainInfo extends StatelessWidget {
  final PropertyEntity property;
  const PropertyDetailsMainInfo({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildDetailItem(
            context,
            Icons.meeting_room_outlined,
            '${property.totalRooms ?? 0}',
            AppLocalizations.of(context)!.translate(LangKeys.roomsCount),
          ),
          _buildDetailItem(
            context,
            Icons.bathroom_outlined,
            '${property.bathrooms ?? 0}',
            AppLocalizations.of(context)!.translate(LangKeys.bathroomsCount),
          ),
          _buildDetailItem(
            context,
            Icons.square_foot,
            '${property.area.toInt()}',
            AppLocalizations.of(context)!.translate(LangKeys.areaUnit),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(BuildContext context, IconData icon, String value, String label, {Color? color}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Icon(icon, color: color ?? (isDark ? Colors.white70 : AppColors.primary), size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
          ),
        ),
      ],
    );
  }
}
