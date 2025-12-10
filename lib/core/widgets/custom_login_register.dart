import 'package:flutter/material.dart';
import 'package:test_graduation/core/utils/colors.dart';

class CustomLoginRegister extends StatelessWidget {
  const CustomLoginRegister({
    super.key,
    required this.title,
    required this.titleButton,
    this.onPressed,
  });
  final String title;
  final String titleButton;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title, style: TextStyle(color: AppColors.textSecondary)),
        TextButton(
          onPressed: onPressed,
          child: Text(
            titleButton,
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
