import 'package:flutter/material.dart';
import 'package:test_graduation/core/models/property_model.dart';
import 'package:test_graduation/core/utils/strings_ar.dart';
import 'package:test_graduation/core/widgets/type_chip.dart';

class FilterTypeChips extends StatelessWidget {
  final ListingType? listingType;
  final Function(ListingType type) onSelect;

  const FilterTypeChips({
    super.key,
    required this.listingType,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TypeChip(
            label: AppStrings.forSale,
            isSelected: listingType == ListingType.sale,
            onTap: () => onSelect(ListingType.sale),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TypeChip(
            label: AppStrings.forRent,
            isSelected: listingType == ListingType.rent,
            onTap: () => onSelect(ListingType.rent),
          ),
        ),
      ],
    );
  }
}

class PropertyTypeChips extends StatelessWidget {
  final PropertyType? current;
  final Function(PropertyType type) onSelect;

  const PropertyTypeChips({
    super.key,
    required this.current,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: PropertyType.values
          .map(
            (type) => TypeChip(
              label: type.arabicName,
              isSelected: current == type,
              onTap: () => onSelect(type),
            ),
          )
          .toList(),
    );
  }
}
