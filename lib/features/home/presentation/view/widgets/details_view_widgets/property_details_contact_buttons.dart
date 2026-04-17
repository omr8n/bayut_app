import 'package:flutter/material.dart';
import 'package:test_graduation/core/helper/property_actions.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';

import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';

class PropertyDetailsContactButtons extends StatelessWidget {
  final PropertyEntity property;
  const PropertyDetailsContactButtons({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => PropertyActions.makeCall(property.phone),
                icon: const Icon(Icons.phone),
                label: Text(
                  AppLocalizations.of(context)!.translate(LangKeys.call),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () =>
                    PropertyActions.sendWhatsApp(property.whatsapp),
                icon: const Icon(Icons.chat),
                label: Text(
                  AppLocalizations.of(context)!.translate(LangKeys.whatsapp),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366),
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
