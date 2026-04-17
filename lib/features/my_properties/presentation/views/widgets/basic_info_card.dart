import 'package:flutter/material.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/widgets/custom_text_form_field.dart';

class BasicInfoCard extends StatelessWidget {
  final TextEditingController buildingAgeController;
  final FocusNode ageNode;
  final String selectedFinishType;
  final List<String> finishTypes;
  final Function(String?) onFinishTypeChanged;
  final String selectedOwnershipType;
  final List<String> ownershipTypes;
  final Function(String?) onOwnershipTypeChanged;
  final String selectedDirection;
  final List<String> directions;
  final Function(String?) onDirectionChanged;
  final bool isLicensed;
  final Function(bool?) onLicensedChanged;
  final bool isFeatured;
  final Function(bool?) onFeaturedChanged;

  const BasicInfoCard({
    super.key,
    required this.buildingAgeController,
    required this.ageNode,
    required this.selectedFinishType,
    required this.finishTypes,
    required this.onFinishTypeChanged,
    required this.selectedOwnershipType,
    required this.ownershipTypes,
    required this.onOwnershipTypeChanged,
    required this.selectedDirection,
    required this.directions,
    required this.onDirectionChanged,
    required this.isLicensed,
    required this.onLicensedChanged,
    required this.isFeatured,
    required this.onFeaturedChanged,
  });

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomTextFormField(
                    controller: buildingAgeController,
                    focusNode: ageNode,
                    textAlign: locale.isEnLocale ? TextAlign.left : TextAlign.right,
                    labelText: locale.translate(LangKeys.buildingAge),
                    prefixIcon: Icons.calendar_today,
                    keyboardType: TextInputType.number,
                    suffixText:
                        ageNode.hasFocus ||
                            buildingAgeController.text.isNotEmpty
                        ? locale.translate(LangKeys.year)
                        : null,
                    hintText: ageNode.hasFocus ? '' : locale.translate(LangKeys.leaveEmptyForNew),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildDropdownField(
                    locale.translate(LangKeys.finishType),
                    Icons.format_paint,
                    selectedFinishType,
                    finishTypes,
                    onFinishTypeChanged,
                    locale,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDropdownField(
                    locale.translate(LangKeys.ownershipType),
                    Icons.assignment,
                    selectedOwnershipType,
                    ownershipTypes,
                    onOwnershipTypeChanged,
                    locale,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDropdownField(
              locale.translate(LangKeys.directionAndView),
              Icons.explore,
              selectedDirection,
              directions,
              onDirectionChanged,
              locale,
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CheckboxListTile(
                title: Text(
                  locale.translate(LangKeys.licensedPropertyQuestion),
                  style: const TextStyle(fontSize: 14),
                ),
                value: isLicensed,
                secondary: const Icon(
                  Icons.assignment_turned_in_outlined,
                  color: Colors.blue,
                ),
                onChanged: onLicensedChanged,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.amber.shade200),
                borderRadius: BorderRadius.circular(8),
                color: Colors.amber.withValues(alpha: 0.05),
              ),
              child: SwitchListTile(
                title: Text(
                  locale.translate(LangKeys.featureProperty),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
                subtitle: Text(
                  locale.translate(LangKeys.featuredDescription),
                  style: const TextStyle(fontSize: 11),
                ),
                value: isFeatured,
                secondary: const Icon(Icons.stars, color: Colors.amber),
                onChanged: onFeaturedChanged,
              ),
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
