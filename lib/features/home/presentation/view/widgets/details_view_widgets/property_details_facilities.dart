import 'package:flutter/material.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/utils/colors.dart';

class PropertyDetailsFacilities extends StatelessWidget {
  final List<String> facilities;
  const PropertyDetailsFacilities({super.key, required this.facilities});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: facilities
          .map((f) => Chip(
                label: Text(
                  localizations.translate(f),
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87,
                  ),
                ),
                avatar: const Icon(Icons.check_circle, size: 16, color: AppColors.success),
                backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppColors.darkSurface : Colors.white,
                side: BorderSide(color: Theme.of(context).brightness == Brightness.dark ? Colors.white24 : Colors.grey.shade200),
              ))
          .toList(),
    );
  }
}
