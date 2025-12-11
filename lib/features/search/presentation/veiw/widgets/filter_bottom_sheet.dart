import 'package:flutter/material.dart';
import 'package:test_graduation/core/models/property_model.dart';
import 'filter_form.dart';

class FilterBottomSheet extends StatelessWidget {
  final PropertyType? selectedPropertyType;
  final ListingType? selectedListingType;
  final double? minPrice;
  final double? maxPrice;
  final double? minArea;
  final double? maxArea;

  final void Function({
    PropertyType? propertyType,
    ListingType? listingType,
    double? minPrice,
    double? maxPrice,
    double? minArea,
    double? maxArea,
  })
  onApplyFilters;

  const FilterBottomSheet({
    super.key,
    this.selectedPropertyType,
    this.selectedListingType,
    this.minPrice,
    this.maxPrice,
    this.minArea,
    this.maxArea,
    required this.onApplyFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: FilterForm(
        selectedListingType: selectedListingType,
        selectedPropertyType: selectedPropertyType,
        minPrice: minPrice,
        maxPrice: maxPrice,
        minArea: minArea,
        maxArea: maxArea,
        onApplyFilters: onApplyFilters,
      ),
    );
  }
}
