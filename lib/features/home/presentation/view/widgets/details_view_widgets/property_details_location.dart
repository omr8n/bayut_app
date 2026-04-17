import 'package:flutter/material.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';

class PropertyDetailsLocation extends StatelessWidget {
  final PropertyEntity property;
  const PropertyDetailsLocation({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.location_on, color: Colors.green, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '${localizations.translate(property.governorate)}${localizations.isEnLocale ? ', ' : ' - '}${property.city}\n${property.location}',
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
