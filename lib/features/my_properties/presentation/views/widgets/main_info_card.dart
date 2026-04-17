import 'package:flutter/material.dart';
import 'package:test_graduation/core/constants/app_constants.dart';
import 'package:test_graduation/core/enums/property_enums.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
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
    final locale = AppLocalizations.of(context)!;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextFormField(
              controller: titleController,
              textAlign: locale.isEnLocale ? TextAlign.left : TextAlign.right,
              labelText: locale.translate(LangKeys.propertyTitle),
              prefixIcon: Icons.title,
            ),
            const SizedBox(height: 16),
            CustomTextFormField(
              controller: descriptionController,
              textAlign: locale.isEnLocale ? TextAlign.left : TextAlign.right,
              labelText: locale.translate(LangKeys.propertyDescription),
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
                    textAlign: locale.isEnLocale ? TextAlign.left : TextAlign.right,
                    labelText: locale.translate(LangKeys.price),
                    prefixIcon: Icons.attach_money,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                _buildCurrencySelector(context),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              locale.translate(LangKeys.purpose),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TypeChip(
                    label: locale.translate(LangKeys.sale),
                    isSelected: selectedListingType == ListingType.sale,
                    onTap: () => onListingTypeChanged(ListingType.sale),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TypeChip(
                    label: locale.translate(LangKeys.rent),
                    isSelected: selectedListingType == ListingType.rent,
                    onTap: () => onListingTypeChanged(ListingType.rent),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              locale.translate(LangKeys.propertyType),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: PropertyType.values
                  .map((type) => TypeChip(
                        label: type.localizedName(context),
                        isSelected: selectedPropertyType == type,
                        onTap: () => onPropertyTypeChanged(type),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencySelector(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
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
              value:
                  AppConstants.currencies.contains(selectedCurrency)
                      ? selectedCurrency
                      : AppConstants.currencies.first,
              items:
                  AppConstants.currencies
                      .map(
                        (curr) => DropdownMenuItem(
                          value: curr,
                          child: Text(locale.translate(curr)),
                        ),
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
