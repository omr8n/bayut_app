import 'package:flutter/material.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/widgets/custom_text_form_field.dart';

class LocationCard extends StatefulWidget {
  final String selectedGovernorate;
  final List<String> governorates;
  final Function(String?) onGovernorateChanged;
  final TextEditingController locationController;

  const LocationCard({
    super.key,
    required this.selectedGovernorate,
    required this.governorates,
    required this.onGovernorateChanged,
    required this.locationController,
  });

  @override
  State<LocationCard> createState() => _LocationCardState();
}

class _LocationCardState extends State<LocationCard> {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildDropdownField(
              locale.translate(LangKeys.governorate),
              Icons.location_city,
              widget.selectedGovernorate,
              widget.governorates,
              widget.onGovernorateChanged,
              locale,
            ),
            const SizedBox(height: 16),
            CustomTextFormField(
              controller: widget.locationController,
              textAlign: locale.isEnLocale ? TextAlign.left : TextAlign.right,
              labelText: locale.translate(LangKeys.city),
              hintText: locale.translate(LangKeys.mezzehExample),
              prefixIcon: Icons.business_outlined,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField(
    String label,
    IconData icon,
    String value,
    List<String> items,
    Function(String?) onChanged,
    AppLocalizations locale,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: items
          .map(
            (String val) => DropdownMenuItem<String>(
              value: val,
              alignment:
                  locale.isEnLocale
                      ? AlignmentDirectional.centerStart
                      : AlignmentDirectional.centerEnd,
              child: Text(
                locale.translate(val),
                textAlign: locale.isEnLocale ? TextAlign.left : TextAlign.right,
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}
