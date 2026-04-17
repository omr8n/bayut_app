import 'package:flutter/material.dart';
import 'package:test_graduation/core/utils/colors.dart';

class AdminPropertiesSearchBar extends StatelessWidget {
  const AdminPropertiesSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.background,
      child: TextField(
        textAlign: TextAlign.right,
        onChanged: (value) {
          // TODO: Implement search logic in Cubit
        },
        decoration: InputDecoration(
          hintText: 'ابحث عن عقار...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
