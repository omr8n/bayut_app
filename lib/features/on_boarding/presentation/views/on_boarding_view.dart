import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/on_boarding/presentation/manager/on_boarding_cubit.dart';
import 'package:test_graduation/features/on_boarding/presentation/views/widgets/on_boarding_body.dart';
import 'package:test_graduation/features/on_boarding/presentation/views/widgets/interactive_steps/purpose_step.dart';
import 'package:test_graduation/features/on_boarding/presentation/views/widgets/interactive_steps/property_type_step.dart';
import 'package:test_graduation/features/on_boarding/presentation/views/widgets/interactive_steps/location_step.dart';
import 'package:test_graduation/features/on_boarding/presentation/views/widgets/on_boarding_progress_bar.dart';

class OnBoardingView extends StatelessWidget {
  const OnBoardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnBoardingCubit(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: BlocBuilder<OnBoardingCubit, OnBoardingState>(
            builder: (context, state) {
              if (state.step == OnBoardingStep.intro) return const SizedBox.shrink();
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: OnBoardingProgressBar(currentStep: _getStepIndex(state.step)),
                ),
              );
            },
          ),
        ),
        body: BlocBuilder<OnBoardingCubit, OnBoardingState>(
          builder: (context, state) {
            switch (state.step) {
              case OnBoardingStep.intro:
                return const OnBoardingBody();
              case OnBoardingStep.purpose:
                return const PurposeStep();
              case OnBoardingStep.propertyType:
                return const PropertyTypeStep();
              case OnBoardingStep.location:
                return const LocationStep();
            }
          },
        ),
      ),
    );
  }

  int _getStepIndex(OnBoardingStep step) {
    switch (step) {
      case OnBoardingStep.purpose:
        return 0;
      case OnBoardingStep.propertyType:
        return 1;
      case OnBoardingStep.location:
        return 2;
      default:
        return 0;
    }
  }
}
