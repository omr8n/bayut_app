import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:test_graduation/core/constants/app_constants.dart';
import 'package:test_graduation/core/enums/property_enums.dart';
import 'package:test_graduation/core/routing/app_routes.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/core/widgets/search_field_widget.dart';
import 'package:test_graduation/core/widgets/type_chip.dart';
import 'package:test_graduation/features/search/presentation/veiw/widgets/build_check_box.dart';
import 'package:test_graduation/features/search/presentation/veiw/widgets/build_counter_row.dart';
import 'package:test_graduation/features/search/presentation/veiw/widgets/build_section.dart';
import '../../manager/search_cubit/search_cubit.dart';
import '../widgets/filter_section_title.dart';
import '../widgets/filter_buttons.dart';

import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';

class FilterForm extends StatefulWidget {
  final PropertyType? selectedPropertyType;
  final ListingType? selectedListingType;
  final double? minPrice, maxPrice, minArea, maxArea;
  final String? selectedGovernorate;
  final int? minRooms, minBedrooms, minBathrooms, floorNumber;
  final bool? isLicensed, hasInstallment, isFeatured;

  final void Function({
    PropertyType? propertyType,
    ListingType? listingType,
    double? minPrice,
    double? maxPrice,
    double? minArea,
    double? maxArea,
    String? governorate,
    int? minRooms,
    int? minBedrooms,
    int? minBathrooms,
    int? floorNumber,
    bool? isLicensed,
    bool? hasInstallment,
    bool? isFeatured,
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
    this.minRooms,
    this.minBedrooms,
    this.minBathrooms,
    this.floorNumber,
    this.isLicensed,
    this.hasInstallment,
    this.isFeatured,
    required this.onApplyFilters,
  });

  @override
  State<FilterForm> createState() => _FilterFormState();
}

class _FilterFormState extends State<FilterForm> {
  PropertyType? propertyType;
  ListingType? listingType;
  String? governorate;
  int? minRooms, minBedrooms, minBathrooms, floorNumber;
  bool? isLicensed, hasInstallment, isFeatured;

  RangeValues _priceRange = const RangeValues(0, 5000000000);
  RangeValues _areaRange = const RangeValues(0, 5000);

  final TextEditingController _minPriceCtrl = TextEditingController();
  final TextEditingController _maxPriceCtrl = TextEditingController();
  final TextEditingController _minAreaCtrl = TextEditingController();
  final TextEditingController _maxAreaCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initFields();
    });
  }

  void _initFields() {
    setState(() {
      propertyType = widget.selectedPropertyType;
      listingType = widget.selectedListingType;
      governorate = widget.selectedGovernorate ?? LangKeys.all;
      isLicensed = widget.isLicensed;
      hasInstallment = widget.hasInstallment;
      isFeatured = widget.isFeatured;
      minRooms = widget.minRooms;
      minBedrooms = widget.minBedrooms;
      minBathrooms = widget.minBathrooms;
      floorNumber = widget.floorNumber;

      _priceRange = RangeValues(
        widget.minPrice ?? 0,
        widget.maxPrice ?? 5000000000,
      );
      _areaRange = RangeValues(widget.minArea ?? 0, widget.maxArea ?? 5000);

      _updateControllers();
    });
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
    final locale = AppLocalizations.of(context)!;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          BuildSection(
            title: locale.translate(LangKeys.listingType),
            icon: Icons.campaign_rounded,
            children: [
              Row(
                children: [
                  _buildTypeOption(locale.translate(LangKeys.sale), ListingType.sale),
                  const SizedBox(width: 12),
                  _buildTypeOption(locale.translate(LangKeys.rent), ListingType.rent),
                ],
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Stack(
              children: [
                SearchFieldWidget(
                  controller: TextEditingController(
                    text: (governorate == null ||
                            governorate == LangKeys.all ||
                            governorate == 'الكل' ||
                            governorate == 'All')
                        ? locale.translate(LangKeys.searchHere)
                        : (AppConstants.governorates.contains(governorate)
                            ? locale.translate(governorate!)
                            : governorate),
                  ),
                  readOnly: true,
                ),
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () async {
                      // 💡 ننتظر الموقع المختار عند العودة
                      final selectedLocation =
                          await context.push<String>(AppRoutes.locationSearchPage);
                      if (selectedLocation != null) {
                        setState(() {
                          governorate = selectedLocation;
                        });
                      }
                    },
                    child: const SizedBox.expand(),
                  ),
                ),
              ],
            ),
          ),

          BuildSection(
            title: locale.translate(LangKeys.propertyType),
            icon: Icons.home_work_rounded,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: PropertyType.values
                    .map(
                      (type) => TypeChip(
                        label: type.localizedName(context),
                        isSelected: propertyType == type,
                        onTap: () => setState(() => propertyType = type),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
          BuildSection(
            title: '${locale.translate(LangKeys.priceRange)} (${locale.translate(LangKeys.currencyLira)})',
            icon: Icons.monetization_on_rounded,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? Colors.blue.withOpacity(0.1) : Colors.blue.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      '${format.format(_priceRange.start)} - ${format.format(_priceRange.end)}',
                      style: TextStyle(
                        color: isDark ? Colors.blue.shade300 : Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    RangeSlider(
                      values: _priceRange,
                      min: 0,
                      max: 5000000000,
                      divisions: 100,
                      activeColor: AppColors.primary,
                      inactiveColor: isDark ? Colors.white12 : Colors.grey.shade300,
                      onChanged: (v) {
                        setState(() {
                          _priceRange = v;
                          _updateControllers();
                        });
                      },
                    ),
                    _buildManualInputRow(
                      _minPriceCtrl,
                      _maxPriceCtrl,
                      (s, e) => setState(() => _priceRange = RangeValues(s, e)),
                      5000000000,
                      true,
                    ),
                  ],
                ),
              ),
            ],
          ),

          BuildSection(
            title: '${locale.translate(LangKeys.areaRange)} (${locale.translate(LangKeys.areaUnit)})',
            icon: Icons.architecture_rounded,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? Colors.blue.withOpacity(0.1) : Colors.blue.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      '${_areaRange.start.toInt()} - ${_areaRange.end.toInt()} ${locale.translate(LangKeys.areaUnit)}',
                      style: TextStyle(
                        color: isDark ? Colors.blue.shade300 : Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    RangeSlider(
                      values: _areaRange,
                      min: 0,
                      max: 5000,
                      divisions: 50,
                      activeColor: AppColors.primary,
                      inactiveColor: isDark ? Colors.white12 : Colors.grey.shade300,
                      onChanged: (v) {
                        setState(() {
                          _areaRange = v;
                          _updateControllers();
                        });
                      },
                    ),
                    _buildManualInputRow(
                      _minAreaCtrl,
                      _maxAreaCtrl,
                      (s, e) => setState(() => _areaRange = RangeValues(s, e)),
                      5000,
                      false,
                    ),
                  ],
                ),
              ),
            ],
          ),

          BuildSection(
            title: locale.translate(LangKeys.roomsAndBaths),
            icon: Icons.king_bed_rounded,
            children: [
              BuildCounterRow(
                title: locale.translate(LangKeys.roomsCount),
                value: minRooms,
                onSelect: (v) => setState(() => minRooms = v),
              ),
              const SizedBox(height: 12),
              BuildCounterRow(
                title: locale.translate(LangKeys.bathroomsCount),
                value: minBathrooms,
                onSelect: (v) => setState(() => minBathrooms = v),
              ),
            ],
          ),

          BuildSection(
            title: locale.translate(LangKeys.additionalOptions),
            icon: Icons.stars_rounded,
            children: [
              BuildCheckBox(
                title: locale.translate(LangKeys.featuredOnly),
                icon: Icons.auto_awesome,
                color: Colors.orange,
                value: isFeatured,
                onChanged: (v) => setState(() => isFeatured = v),
              ),
              BuildCheckBox(
                title: locale.translate(LangKeys.licensedProperty),
                icon: Icons.verified_rounded,
                color: AppColors.primary,
                value: isLicensed,
                onChanged: (v) => setState(() => isLicensed = v),
              ),
              BuildCheckBox(
                title: locale.translate(LangKeys.installmentAvailable),
                icon: Icons.account_balance_wallet_rounded,
                color: Colors.green,
                value: hasInstallment,
                onChanged: (v) => setState(() => hasInstallment = v),
              ),
            ],
          ),

          const SizedBox(height: 40),
          // 🔥 استدعاء دالة التصفير الكاملة من الكيوبيت
          FilterButtons(onReset: _resetAll, onApply: _apply),
        ],
      ),
    );
  }

  void _resetAll() {
    // 1. تصفير الكيوبيت (الخزنة المركزية)
    context.read<SearchCubit>().resetSessionFilters();
    // 2. تصفير الواجهة المحلية يدوياً لضمان التحديث اللحظي
    setState(() {
      propertyType = null;
      listingType = null;
      governorate = LangKeys.all;
      minRooms = null;
      minBedrooms = null;
      minBathrooms = null;
      floorNumber = null;
      isLicensed = null;
      hasInstallment = null;
      isFeatured = null;

      _priceRange = const RangeValues(0, 5000000000);
      _areaRange = const RangeValues(0, 5000);
      _updateControllers();
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
      governorate: (governorate == LangKeys.all || governorate == 'الكل' || governorate == null) ? null : governorate,
      minRooms: minRooms,
      minBedrooms: minBedrooms,
      minBathrooms: minBathrooms,
      floorNumber: floorNumber,
      isLicensed: isLicensed,
      hasInstallment: hasInstallment,
      isFeatured: isFeatured,
    );
  }

  Widget _buildTypeOption(String label, ListingType type) {
    return Expanded(
      child: TypeChip(
        label: label,
        isSelected: listingType == type,
        onTap: () => setState(() => listingType = type),
      ),
    );
  }

  Widget _buildManualInputRow(
    TextEditingController min,
    TextEditingController max,
    Function(double, double) onManualChange,
    double maxLimit,
    bool isPrice,
  ) {
    final locale = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: min,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: locale.translate(LangKeys.from),
              border: const OutlineInputBorder(),
            ),
            onChanged: (v) {
              double val = double.tryParse(v) ?? 0;
              if (val <= (isPrice ? _priceRange.end : _areaRange.end)) {
                onManualChange(val, isPrice ? _priceRange.end : _areaRange.end);
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(locale.translate(LangKeys.to)),
        ),
        Expanded(
          child: TextField(
            controller: max,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: locale.translate(LangKeys.to),
              border: const OutlineInputBorder(),
            ),
            onChanged: (v) {
              double val = double.tryParse(v) ?? maxLimit;
              if (val >= (isPrice ? _priceRange.start : _areaRange.start)) {
                onManualChange(
                  isPrice ? _priceRange.start : _areaRange.start,
                  val,
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
