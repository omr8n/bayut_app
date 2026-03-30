import 'package:flutter/material.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';

class PropertyDetailsLocation extends StatelessWidget {
  final PropertyEntity property;
  const PropertyDetailsLocation({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.location_on, color: AppColors.secondary, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '${property.governorate} - ${property.city}\n${property.location}',
            style: const TextStyle(fontSize: 15, color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }
}
