import 'package:flutter/material.dart';
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
                    textAlign: TextAlign.right,
                    labelText: 'عمر البناء',
                    prefixIcon: Icons.calendar_today,
                    keyboardType: TextInputType.number,
                    suffixText:
                        ageNode.hasFocus ||
                            buildingAgeController.text.isNotEmpty
                        ? 'سنة'
                        : null,
                    hintText: ageNode.hasFocus ? '' : 'اتركه فارغاً للجديد',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildDropdownField(
                    'نوع الكسوة',
                    Icons.format_paint,
                    selectedFinishType,
                    finishTypes,
                    onFinishTypeChanged,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDropdownField(
                    'نوع الملكية',
                    Icons.assignment,
                    selectedOwnershipType,
                    ownershipTypes,
                    onOwnershipTypeChanged,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDropdownField(
              'الاتجاه والإطلالة',
              Icons.explore,
              selectedDirection,
              directions,
              onDirectionChanged,
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CheckboxListTile(
                title: const Text(
                  'العقار مرخص (رخصة بناء)',
                  style: TextStyle(fontSize: 14),
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
                color: Colors.amber.withOpacity(0.05),
              ),
              child: SwitchListTile(
                title: const Text(
                  'تمييز العقار (إعلان ممول)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
                subtitle: const Text(
                  'سيظهر في قسم العقارات المميزة بالصفحة الرئيسية',
                  style: TextStyle(fontSize: 11),
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
              alignment: AlignmentDirectional.centerEnd,
              child: Text(val, textAlign: TextAlign.right),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}
