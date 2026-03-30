import 'package:flutter/material.dart';
import 'package:test_graduation/core/utils/colors.dart';

class PropertyDetailsFacilities extends StatelessWidget {
  final List<String> facilities;
  const PropertyDetailsFacilities({super.key, required this.facilities});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: facilities
          .map((f) => Chip(
                label: Text(f, style: const TextStyle(fontSize: 12)),
                avatar: const Icon(Icons.check_circle, size: 16, color: AppColors.success),
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.grey.shade200),
              ))
          .toList(),
    );
  }
}
