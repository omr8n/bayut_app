import 'package:flutter/material.dart';
import '../models/property_model.dart';
import '../utils/colors.dart';
import '../utils/strings_ar.dart';

// نافذة الفلترة
class FilterWidget extends StatefulWidget {
  final PropertyType? selectedPropertyType;
  final ListingType? selectedListingType;
  final double? minPrice;
  final double? maxPrice;
  final double? minArea;
  final double? maxArea;
  final Function({
    PropertyType? propertyType,
    ListingType? listingType,
    double? minPrice,
    double? maxPrice,
    double? minArea,
    double? maxArea,
  })
  onApplyFilters;

  const FilterWidget({
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
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  PropertyType? _selectedPropertyType;
  ListingType? _selectedListingType;
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();
  final TextEditingController _minAreaController = TextEditingController();
  final TextEditingController _maxAreaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedPropertyType = widget.selectedPropertyType;
    _selectedListingType = widget.selectedListingType;
    if (widget.minPrice != null) {
      _minPriceController.text = widget.minPrice!.toInt().toString();
    }
    if (widget.maxPrice != null) {
      _maxPriceController.text = widget.maxPrice!.toInt().toString();
    }
    if (widget.minArea != null) {
      _minAreaController.text = widget.minArea!.toInt().toString();
    }
    if (widget.maxArea != null) {
      _maxAreaController.text = widget.maxArea!.toInt().toString();
    }
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    _minAreaController.dispose();
    _maxAreaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // العنوان
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                AppStrings.filters,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // نوع الإعلان
          const Text(
            'نوع الإعلان',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildChip(
                  AppStrings.forSale,
                  _selectedListingType == ListingType.sale,
                  () => setState(() => _selectedListingType = ListingType.sale),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildChip(
                  AppStrings.forRent,
                  _selectedListingType == ListingType.rent,
                  () => setState(() => _selectedListingType = ListingType.rent),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // نوع العقار
          const Text(
            AppStrings.propertyType,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: PropertyType.values.map((type) {
              return _buildChip(
                type.arabicName,
                _selectedPropertyType == type,
                () => setState(() => _selectedPropertyType = type),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // نطاق السعر
          const Text(
            AppStrings.priceRange,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  _minPriceController,
                  AppStrings.minPrice,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  _maxPriceController,
                  AppStrings.maxPrice,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // نطاق المساحة
          const Text(
            AppStrings.areaRange,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTextField(_minAreaController, AppStrings.minArea),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(_maxAreaController, AppStrings.maxArea),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // الأزرار
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _clearFilters,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'إعادة تعيين',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _applyFilters,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'تطبيق',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.error,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textLight, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }

  void _clearFilters() {
    setState(() {
      _selectedPropertyType = null;
      _selectedListingType = null;
      _minPriceController.clear();
      _maxPriceController.clear();
      _minAreaController.clear();
      _maxAreaController.clear();
    });
  }

  void _applyFilters() {
    widget.onApplyFilters(
      propertyType: _selectedPropertyType,
      listingType: _selectedListingType,
      minPrice: _minPriceController.text.isEmpty
          ? null
          : double.tryParse(_minPriceController.text),
      maxPrice: _maxPriceController.text.isEmpty
          ? null
          : double.tryParse(_maxPriceController.text),
      minArea: _minAreaController.text.isEmpty
          ? null
          : double.tryParse(_minAreaController.text),
      maxArea: _maxAreaController.text.isEmpty
          ? null
          : double.tryParse(_maxAreaController.text),
    );
    Navigator.pop(context);
  }
}
