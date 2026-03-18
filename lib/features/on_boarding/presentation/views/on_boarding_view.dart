import 'package:flutter/material.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/on_boarding/presentation/views/widgets/on_boarding_body.dart';

class OnBoardingView extends StatelessWidget {
  const OnBoardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: OnBoardingBody(),
    );
  }
}
