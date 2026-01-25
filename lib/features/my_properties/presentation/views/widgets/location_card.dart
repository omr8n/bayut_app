import 'package:flutter/material.dart';
import 'package:test_graduation/core/widgets/custom_text_form_field.dart';

class LocationCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildDropdownField(
              'المحافظة',
              Icons.map_outlined,
              selectedGovernorate,
              governorates,
              onGovernorateChanged,
            ),
            const SizedBox(height: 16),
            CustomTextFormField(
              controller: locationController,
              textAlign: TextAlign.right,
              labelText: 'المدينة أو المنطقة',
              hintText: 'مثال: المزة',
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
