import 'package:flutter/material.dart';
import 'package:test_graduation/core/utils/colors.dart';

class OnBoardingProgressBar extends StatelessWidget {
  final int currentStep; // 0, 1, 2
  const OnBoardingProgressBar({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: List.generate(3, (index) {
          bool isActive = index <= currentStep;
          return Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }
}
