import 'package:flutter/material.dart';
import 'package:test_graduation/core/models/property_model.dart';
import '../widgets/filter_section_title.dart';
import '../widgets/filter_type_chips.dart';
import '../widgets/filter_range_fields.dart';
import '../widgets/filter_buttons.dart';

class FilterForm extends StatefulWidget {
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

  const FilterForm({
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
  State<FilterForm> createState() => _FilterFormState();
}

class _FilterFormState extends State<FilterForm> {
  PropertyType? propertyType;
  ListingType? listingType;

  final minPriceController = TextEditingController();
  final maxPriceController = TextEditingController();
  final minAreaController = TextEditingController();
  final maxAreaController = TextEditingController();

  @override
  void initState() {
    super.initState();

    propertyType = widget.selectedPropertyType;
    listingType = widget.selectedListingType;

    _init(minPriceController, widget.minPrice);
    _init(maxPriceController, widget.maxPrice);
    _init(minAreaController, widget.minArea);
    _init(maxAreaController, widget.maxArea);
  }

  void _init(TextEditingController ctrl, double? value) {
    if (value != null) ctrl.text = value.toInt().toString();
  }

  @override
  void dispose() {
    minPriceController.dispose();
    maxPriceController.dispose();
    minAreaController.dispose();
    maxAreaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // نوع الإعلان
        const FilterSectionTitle(title: 'نوع الإعلان'),
        FilterTypeChips(
          listingType: listingType,
          onSelect: (type) =>
              setState(() => listingType = type as ListingType?),
        ),

        const SizedBox(height: 20),

        // نوع العقار
        const FilterSectionTitle(title: 'نوع العقار'),
        PropertyTypeChips(
          current: propertyType,
          onSelect: (p) => setState(() => propertyType = p as PropertyType?),
        ),

        const SizedBox(height: 20),

        // نطاق السعر
        const FilterSectionTitle(title: 'نطاق السعر'),
        FilterRangeFields(
          minController: minPriceController,
          maxController: maxPriceController,
        ),

        const SizedBox(height: 20),

        // نطاق المساحة
        const FilterSectionTitle(title: 'نطاق المساحة'),
        FilterRangeFields(
          minController: minAreaController,
          maxController: maxAreaController,
        ),

        const SizedBox(height: 24),

        // Apply / Reset Buttons
        FilterButtons(onReset: _reset, onApply: _apply),
      ],
    );
  }

  // --------------------- Logic -----------------------

  void _reset() {
    setState(() {
      propertyType = null;
      listingType = null;
      minPriceController.clear();
      maxPriceController.clear();
      minAreaController.clear();
      maxAreaController.clear();
    });
  }

  void _apply() {
    widget.onApplyFilters(
      propertyType: propertyType,
      listingType: listingType,
      minPrice: _num(minPriceController),
      maxPrice: _num(maxPriceController),
      minArea: _num(minAreaController),
      maxArea: _num(maxAreaController),
    );
    Navigator.pop(context);
  }

  double? _num(TextEditingController c) {
    if (c.text.trim().isEmpty) return null;
    return double.tryParse(c.text.trim());
  }
}
