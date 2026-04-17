import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/core/enums/property_enums.dart';

class AdminPropertiesHeader extends StatefulWidget {
  const AdminPropertiesHeader({super.key, required this.onFilterChanged, required this.onSearchChanged});
  
  final Function(ListingType?) onFilterChanged;
  final Function(String) onSearchChanged;

  @override
  State<AdminPropertiesHeader> createState() => _AdminPropertiesHeaderState();
}

class _AdminPropertiesHeaderState extends State<AdminPropertiesHeader> {
  ListingType? selectedType;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 25.h, left: 16.w, right: 16.w, top: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1E4C9A), // اللون الأزرق الملكي الموحد
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
      child: Column(
        children: [
          // شريط البحث بتصميم الشفافية (نفس صور المستخدمين)
          TextField(
            textAlign: TextAlign.right,
            onChanged: widget.onSearchChanged,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: '...ابحث عن عقار',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
              prefixIcon: const Icon(Icons.search, color: Colors.white70),
              filled: true,
              fillColor: Colors.white.withOpacity(0.15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.r),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 0.h),
            ),
          ),
          SizedBox(height: 15.h),
          
          // الفلاتر الأصلية (الكل، للبيع، للإيجار) - مع الحفاظ على ListingType
          Row(
            children: [
              Expanded(child: _buildFilterChip('الكل', null)),
              SizedBox(width: 8.w),
              Expanded(child: _buildFilterChip('للبيع', ListingType.sale)),
              SizedBox(width: 8.w),
              Expanded(child: _buildFilterChip('للإيجار', ListingType.rent)),
            ],
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
}
