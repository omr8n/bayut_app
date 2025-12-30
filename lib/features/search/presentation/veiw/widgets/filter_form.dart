import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_graduation/core/models/property_model.dart';
import 'package:test_graduation/core/widgets/type_chip.dart';
import '../widgets/filter_section_title.dart';
import '../widgets/filter_buttons.dart';

class FilterForm extends StatefulWidget {
  final PropertyType? selectedPropertyType;
  final ListingType? selectedListingType;
  final double? minPrice;
  final double? maxPrice;
  final double? minArea;
  final double? maxArea;
  final String? selectedGovernorate;
  final String? selectedFinishType;
  final String? selectedOwnershipType;
  final int? minRooms;
  final int? minBathrooms;
  final bool? isLicensed;
  final bool? hasInstallment;

  final void Function({
    PropertyType? propertyType,
    ListingType? listingType,
    double? minPrice,
    double? maxPrice,
    double? minArea,
    double? maxArea,
    String? governorate,
    String? finishType,
    String? ownershipType,
    int? minRooms,
    int? minBathrooms,
    bool? isLicensed,
    bool? hasInstallment,
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
    this.selectedGovernorate,
    this.selectedFinishType,
    this.selectedOwnershipType,
    this.minRooms,
    this.minBathrooms,
    this.isLicensed,
    this.hasInstallment,
    required this.onApplyFilters,
  });

  @override
  State<FilterForm> createState() => _FilterFormState();
}

class _FilterFormState extends State<FilterForm> {
  PropertyType? propertyType;
  ListingType? listingType;
  String? governorate;
  String? finishType;

  RangeValues _priceRange = const RangeValues(0, 5000000000);
  RangeValues _areaRange = const RangeValues(0, 5000);

  final TextEditingController _minPriceCtrl = TextEditingController();
  final TextEditingController _maxPriceCtrl = TextEditingController();
  final TextEditingController _minAreaCtrl = TextEditingController();
  final TextEditingController _maxAreaCtrl = TextEditingController();

  int? minRooms;
  int? minBathrooms;
  bool? isLicensed;
  bool? hasInstallment;

  @override
  void initState() {
    super.initState();
    propertyType = widget.selectedPropertyType;
    listingType = widget.selectedListingType;
    governorate = widget.selectedGovernorate ?? 'الكل';
    finishType = widget.selectedFinishType ?? 'الكل';
    isLicensed = widget.isLicensed;
    hasInstallment = widget.hasInstallment;
    minRooms = widget.minRooms;
    minBathrooms = widget.minBathrooms;

    _priceRange = RangeValues(
      widget.minPrice ?? 0,
      widget.maxPrice ?? 5000000000,
    );
    _areaRange = RangeValues(widget.minArea ?? 0, widget.maxArea ?? 5000);

    _updateControllers();
  }

  void _updateControllers() {
    _minPriceCtrl.text = _priceRange.start.toInt().toString();
    _maxPriceCtrl.text = _priceRange.end.toInt().toString();
    _minAreaCtrl.text = _areaRange.start.toInt().toString();
    _maxAreaCtrl.text = _areaRange.end.toInt().toString();
  }

  @override
  void dispose() {
    _minPriceCtrl.dispose();
    _maxPriceCtrl.dispose();
    _minAreaCtrl.dispose();
    _maxAreaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final format = NumberFormat('#,###');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FilterSectionTitle(title: 'نوع الإعلان'),
        Row(
          children: [
            Expanded(
              child: TypeChip(
                label: 'للبيع',
                isSelected: listingType == ListingType.sale,
                onTap: () => setState(() => listingType = ListingType.sale),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TypeChip(
                label: 'للإيجار',
                isSelected: listingType == ListingType.rent,
                onTap: () => setState(() => listingType = ListingType.rent),
              ),
            ),
          ],
        ),

        const SizedBox(height: 25),
        const FilterSectionTitle(title: 'السعر (ل.س)'),
        Text(
          '${format.format(_priceRange.start)} - ${format.format(_priceRange.end)}',
          style: const TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        RangeSlider(
          values: _priceRange,
          min: 0,
          max: 5000000000,
          divisions: 100,
          onChanged: (v) => setState(() {
            _priceRange = v;
            _updateControllers();
          }),
        ),
        _buildRangeInputFields(
          _minPriceCtrl,
          _maxPriceCtrl,
          'أقل سعر',
          'أعلى سعر',
          (start, end) {
            setState(() => _priceRange = RangeValues(start, end));
          },
          5000000000,
        ),

        const SizedBox(height: 25),
        const FilterSectionTitle(title: 'المساحة (م²)'),
        Text(
          '${_areaRange.start.toInt()} - ${_areaRange.end.toInt()} م²',
          style: const TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        RangeSlider(
          values: _areaRange,
          min: 0,
          max: 5000,
          divisions: 50,
          onChanged: (v) => setState(() {
            _areaRange = v;
            _updateControllers();
          }),
        ),
        _buildRangeInputFields(
          _minAreaCtrl,
          _maxAreaCtrl,
          'أقل مساحة',
          'أعلى مساحة',
          (start, end) {
            setState(() => _areaRange = RangeValues(start, end));
          },
          5000,
        ),

        const SizedBox(height: 25),
        const FilterSectionTitle(title: 'نوع العقار'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: PropertyType.values
              .map(
                (type) => TypeChip(
                  label: type.arabicName,
                  isSelected: propertyType == type,
                  onTap: () => setState(() => propertyType = type),
                ),
              )
              .toList(),
        ),

        const SizedBox(height: 25),
        const FilterSectionTitle(title: 'الغرف والحمامات'),
        _buildCounterRow(
          'عدد الغرف',
          minRooms,
          (v) => setState(() => minRooms = v),
        ),
        _buildCounterRow(
          'عدد الحمامات',
          minBathrooms,
          (v) => setState(() => minBathrooms = v),
        ),

        const SizedBox(height: 25),
        const FilterSectionTitle(title: 'الموقع والمواصفات'),
        _buildDropdown(
          'المحافظة',
          [
            'الكل',
            'دمشق',
            'ريف دمشق',
            'حلب',
            'حمص',
            'حماة',
            'اللاذقية',
            'طرطوس',
          ],
          governorate,
          (val) => setState(() => governorate = val),
        ),
        const SizedBox(height: 12),
        _buildDropdown(
          'نوع الكسوة',
          ['الكل', 'سوبر ديلوكس', 'ديلوكس', 'عادي', 'قديم'],
          finishType,
          (val) => setState(() => finishType = val),
        ),

        const SizedBox(height: 25),
        const FilterSectionTitle(title: 'خيارات إضافية'),
        CheckboxListTile(
          title: const Text('عقار مرخص'),
          value: isLicensed ?? false,
          onChanged: (v) => setState(() => isLicensed = v),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
        CheckboxListTile(
          title: const Text('متاح بالتقسيط'),
          value: hasInstallment ?? false,
          onChanged: (v) => setState(() => hasInstallment = v),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),

        const SizedBox(height: 30),
        FilterButtons(onReset: _reset, onApply: _apply),
      ],
    );
  }

  Widget _buildRangeInputFields(
    TextEditingController min,
    TextEditingController max,
    String minHint,
    String maxHint,
    Function(double, double) onManualChange,
    double maxLimit,
  ) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: min,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: minHint,
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
            ),
            onChanged: (v) {
              double val = double.tryParse(v) ?? 0;
              if (val <= double.parse(max.text))
                onManualChange(val, double.parse(max.text));
            },
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text('إلى'),
        ),
        Expanded(
          child: TextField(
            controller: max,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: maxHint,
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
            ),
            onChanged: (v) {
              double val = double.tryParse(v) ?? maxLimit;
              if (val >= double.parse(min.text))
                onManualChange(double.parse(min.text), val);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCounterRow(String title, int? value, Function(int?) onSelect) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 8),
        Row(
          children: [0, 1, 2, 3, 4, 5].map((i) {
            bool isSelected = (value == i) || (i == 0 && value == null);
            String label = i == 0 ? 'الكل' : (i == 5 ? '+5' : '$i');
            return Expanded(
              child: GestureDetector(
                onTap: () => onSelect(i == 0 ? null : i),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue : Colors.white,
                    border: Border.all(
                      color: isSelected ? Colors.blue : Colors.grey.shade300,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> items,
    String? value,
    Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: items
          .map(
            (s) => DropdownMenuItem(
              value: s,
              alignment: AlignmentDirectional.centerEnd,
              child: Text(s),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }

  void _reset() {
    setState(() {
      propertyType = null;
      listingType = null;
      governorate = 'الكل';
      finishType = 'الكل';
      _priceRange = const RangeValues(0, 5000000000);
      _areaRange = const RangeValues(0, 5000);
      _updateControllers();
      minRooms = null;
      minBathrooms = null;
      isLicensed = null;
      hasInstallment = null;
    });
  }

  void _apply() {
    widget.onApplyFilters(
      propertyType: propertyType,
      listingType: listingType,
      minPrice: _priceRange.start,
      maxPrice: _priceRange.end,
      minArea: _areaRange.start,
      maxArea: _areaRange.end,
      governorate: governorate == 'الكل' ? null : governorate,
      finishType: finishType == 'الكل' ? null : finishType,
      minRooms: minRooms,
      minBathrooms: minBathrooms,
      isLicensed: isLicensed,
      hasInstallment: hasInstallment,
    );
    Navigator.pop(context);
  }
}
