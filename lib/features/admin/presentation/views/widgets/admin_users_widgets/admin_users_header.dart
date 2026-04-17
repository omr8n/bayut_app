import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminUsersHeader extends StatefulWidget {
  const AdminUsersHeader({
    super.key,
    required this.onSearchChanged,
    required this.onFilterChanged,
  });

  final Function(String) onSearchChanged;
  final Function(String?) onFilterChanged;

  @override
  State<AdminUsersHeader> createState() => _AdminUsersHeaderState();
}

class _AdminUsersHeaderState extends State<AdminUsersHeader> {
  String? selectedStatus;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      color: Colors.white,
      child: Column(
        children: [
          // Search Field
          TextField(
            textAlign: TextAlign.right,
            onChanged: widget.onSearchChanged,
            decoration: InputDecoration(
              hintText: 'ابحث عن مستخدم بالاسم أو البريد...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
          ),
          SizedBox(height: 12.h),
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('الكل', null),
                SizedBox(width: 8.w),
                _buildFilterChip('نشط', 'active'),
                SizedBox(width: 8.w),
                _buildFilterChip('مجمد', 'frozen'),
                SizedBox(width: 8.w),
                _buildFilterChip('محظور', 'banned'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String? status) {
    bool isSelected = selectedStatus == status;
    return GestureDetector(
      onTap: () {
        setState(() => selectedStatus = status);
        widget.onFilterChanged(status);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E4C9A) : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? const Color(0xFF1E4C9A) : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 12.sp,
          ),
        ),
      ),
    );
  }
}
