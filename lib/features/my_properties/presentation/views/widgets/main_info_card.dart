import 'package:flutter/material.dart';
import 'package:test_graduation/core/models/property_model.dart';
import 'package:test_graduation/core/utils/strings_ar.dart';
import 'package:test_graduation/core/widgets/custom_text_form_field.dart';
import 'package:test_graduation/core/widgets/type_chip.dart';

class MainInfoCard extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController priceController;
  final FocusNode priceNode;
  final String selectedCurrency;
  final Function(String?) onCurrencyChanged;
  final ListingType selectedListingType;
  final Function(ListingType) onListingTypeChanged;
  final PropertyType selectedPropertyType;
  final Function(PropertyType) onPropertyTypeChanged;

  const MainInfoCard({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.priceController,
    required this.priceNode,
    required this.selectedCurrency,
    required this.onCurrencyChanged,
    required this.selectedListingType,
    required this.onListingTypeChanged,
    required this.selectedPropertyType,
    required this.onPropertyTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextFormField(
              controller: titleController,
              textAlign: TextAlign.right,
              labelText: 'اسم العقار',
              prefixIcon: Icons.title,
            ),
            const SizedBox(height: 16),
            CustomTextFormField(
              controller: descriptionController,
              textAlign: TextAlign.right,
              labelText: 'وصف العقار',
              maxLines: 3,
              prefixIcon: Icons.description,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomTextFormField(
                    controller: priceController,
                    focusNode: priceNode,
                    textAlign: TextAlign.right,
                    labelText: 'السعر',
                    prefixIcon: Icons.attach_money,
                    keyboardType: TextInputType.number,
                    suffixText:
                        priceNode.hasFocus || priceController.text.isNotEmpty
                        ? selectedCurrency
                        : null,
                  ),
                ),
                const SizedBox(width: 8),
                _buildCurrencySelector(),
              ],
            ),
            const SizedBox(height: 24),
            const Text('الغرض', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TypeChip(
                    label: AppStrings.forSale,
                    isSelected: selectedListingType == ListingType.sale,
                    onTap: () => onListingTypeChanged(ListingType.sale),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TypeChip(
                    label: AppStrings.forRent,
                    isSelected: selectedListingType == ListingType.rent,
                    onTap: () => onListingTypeChanged(ListingType.rent),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'نوع العقار',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: PropertyType.values
                  .map(
                    (type) => TypeChip(
                      label: type.arabicName,
                      isSelected: selectedPropertyType == type,
                      onTap: () => onPropertyTypeChanged(type),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencySelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedCurrency,
              items: [r'$', 'ل.س', 'AED']
                  .map(
                    (curr) => DropdownMenuItem(value: curr, child: Text(curr)),
                  )
                  .toList(),
              onChanged: onCurrencyChanged,
            ),
          ),
          const Icon(Icons.sync, color: Colors.grey, size: 20),
        ],
      ),
    );
  }
}
