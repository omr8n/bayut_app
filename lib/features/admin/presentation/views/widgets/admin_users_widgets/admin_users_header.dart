import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_graduation/core/language/app_localizations.dart';

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
    final local = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.all(16.w),
      color: Colors.white,
      child: Column(
        children: [
          // Search Field
          TextField(
            onChanged: widget.onSearchChanged,
            decoration: InputDecoration(
              hintText: local.search_user_hint,
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
                _buildFilterChip(local.all, null),
                SizedBox(width: 8.w),
                _buildFilterChip(local.active, 'active'),
                SizedBox(width: 8.w),
                _buildFilterChip(local.frozen_label, 'frozen'),
                SizedBox(width: 8.w),
                _buildFilterChip(local.banned_user, 'banned'),
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
