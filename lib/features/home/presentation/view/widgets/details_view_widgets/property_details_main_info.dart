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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildDetailItem(
            Icons.meeting_room_outlined,
            '${property.totalRooms ?? 0}',
            AppLocalizations.of(context)!.translate(LangKeys.roomsCount),
          ),
          _buildDetailItem(
            Icons.bathroom_outlined,
            '${property.bathrooms ?? 0}',
            AppLocalizations.of(context)!.translate(LangKeys.bathroomsCount),
          ),
          _buildDetailItem(
            Icons.square_foot,
            '${property.area.toInt()}',
            AppLocalizations.of(context)!.translate(LangKeys.areaUnit),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String value, String label, {Color? color}) {
    return Column(
      children: [
        Icon(icon, color: color ?? AppColors.primary, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
