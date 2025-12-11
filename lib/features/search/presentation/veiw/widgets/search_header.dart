import 'package:flutter/material.dart';
import 'package:test_graduation/core/widgets/search_bar_widget.dart';
import 'package:test_graduation/core/widgets/filter_widget.dart';
import 'package:test_graduation/core/models/property_model.dart';
import 'package:test_graduation/features/search/presentation/veiw/widgets/filter_bottom_sheet.dart';

class SearchHeader extends StatelessWidget {
  const SearchHeader({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onApply,
    required this.selectedPropertyType,
    required this.selectedListingType,
    required this.minPrice,
    required this.maxPrice,
    required this.minArea,
    required this.maxArea,
  });

  final TextEditingController controller;
  final void Function(String) onChanged;

  final void Function({
    PropertyType? propertyType,
    ListingType? listingType,
    double? minPrice,
    double? maxPrice,
    double? minArea,
    double? maxArea,
  })
  onApply;

  final PropertyType? selectedPropertyType;
  final ListingType? selectedListingType;
  final double? minPrice;
  final double? maxPrice;
  final double? minArea;
  final double? maxArea;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SearchBarWidget(
        controller: controller,
        onChanged: onChanged,
        onFilterTap: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            builder: (_) {
              return FilterBottomSheet(
                selectedPropertyType: selectedPropertyType,
                selectedListingType: selectedListingType,
                minPrice: minPrice,
                maxPrice: maxPrice,
                minArea: minArea,
                maxArea: maxArea,
                onApplyFilters: onApply,
              );
            },
          );
        },
      ),
    );
  }
}
