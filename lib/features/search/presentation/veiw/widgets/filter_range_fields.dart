import 'package:flutter/material.dart';
import 'package:test_graduation/core/utils/strings_ar.dart';
import 'package:test_graduation/core/widgets/custom_text_form_field.dart';

class FilterRangeFields extends StatelessWidget {
  final TextEditingController minController;
  final TextEditingController maxController;

  const FilterRangeFields({
    super.key,
    required this.minController,
    required this.maxController,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomTextFormField(
            controller: minController,
            hintText: AppStrings.minPrice,
            textAlign: TextAlign.right,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: CustomTextFormField(
            controller: maxController,
            hintText: AppStrings.maxPrice,
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }
}
