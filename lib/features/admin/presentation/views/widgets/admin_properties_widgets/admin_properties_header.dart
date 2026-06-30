import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:test_graduation/core/enums/property_enums.dart';

import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/utils/colors.dart';

class AdminPropertiesHeader extends StatefulWidget {
  const AdminPropertiesHeader({
    super.key,
    required this.onFilterChanged,
    required this.onSearchChanged,
    required this.onExtraFilterChanged,
  });

  final Function(ListingType?) onFilterChanged;
  final Function(String) onSearchChanged;
  final Function(String)
  onExtraFilterChanged; // 🔥 Premium requests and trend filter

  @override
  State<AdminPropertiesHeader> createState() => _AdminPropertiesHeaderState();
}

class _AdminPropertiesHeaderState extends State<AdminPropertiesHeader> {
  ListingType? selectedType;
  String? selectedExtraFilter;

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.only(
        bottom: 20.h,
        left: 16.w,
        right: 16.w,
        top: 10.h,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkBackground
            : const Color(0xFF1E4C9A), // Standard Royal Blue
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20,
              ),
              const Spacer(),
              Text(
                local.manage_properties,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              const SizedBox(width: 20),
            ],
          ),
          SizedBox(height: 15.h),
          // Search bar with transparency
          TextField(
            onChanged: widget.onSearchChanged,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: local.search_property_hint,
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: .6)),
              prefixIcon: const Icon(Icons.search, color: Colors.white70),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.r),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 0.h),
            ),
          ),
          SizedBox(height: 15.h),

          // Original filters (All, For Sale, For Rent)
          Row(
            children: [
              Expanded(child: _buildFilterChip(local.all, null)),
              SizedBox(width: 8.w),
              Expanded(
                child: _buildFilterChip(local.for_sale, ListingType.sale),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _buildFilterChip(local.for_rent, ListingType.rent),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // Extra filters (Premium Requests, Currently Featured, Trend)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildExtraFilterChip(local.all, local.all),
                SizedBox(width: 8.w),
                _buildExtraFilterChip(
                  local.premium_requests,
                  local.premium_requests,
                ),
                SizedBox(width: 8.w),
                _buildExtraFilterChip(
                  local.currently_featured,
                  local.currently_featured,
                ),
                SizedBox(width: 8.w),
                _buildExtraFilterChip(local.trend_leaders, local.trend_leaders),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, ListingType? type) {
    bool isSelected = selectedType == type;
    return GestureDetector(
      onTap: () {
        setState(() => selectedType = type);
        widget.onFilterChanged(type);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: isSelected ? const Color(0xFF1E4C9A) : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildExtraFilterChip(String label, String value) {
    bool isSelected =
        (selectedExtraFilter ?? AppLocalizations.of(context)!.all) == value;
    return GestureDetector(
      onTap: () {
        setState(() => selectedExtraFilter = value);
        widget.onExtraFilterChanged(value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.amber
              : Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20.r),
          border: isSelected ? null : Border.all(color: Colors.white24),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.black87 : Colors.white70,
          ),
        ),
      ),
    );
  }
}
