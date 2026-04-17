import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/core/constants/app_constants.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/routing/app_routes.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/on_boarding/presentation/manager/on_boarding_cubit.dart';

class LocationStep extends StatelessWidget {
  const LocationStep({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnBoardingCubit, OnBoardingState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 60),
              Text(
                AppLocalizations.of(
                  context,
                )!.translate(LangKeys.whichAreasInterestedIn),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 50),
              Expanded(
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: AppConstants.governorates.map((loc) {
                    final bool isSelected = state.selectedLocations.contains(
                      loc,
                    );
                    return FilterChip(
                      label: Text(AppLocalizations.of(context)!.translate(loc)),
                      selected: isSelected,
                      onSelected: (_) =>
                          context.read<OnBoardingCubit>().toggleLocation(loc),
                      selectedColor: AppColors.primary.withOpacity(0.2),
                      checkmarkColor: AppColors.primary,
                    );
                  }).toList(),
                ),
              ),
              const Spacer(),
              _buildBottomActionButtons(
                context,
                state.selectedLocations.isNotEmpty,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomActionButtons(BuildContext context, bool canNext) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 55,
            child: OutlinedButton(
              onPressed: () async {
                // 🔥 حفظ التفضيلات حتى عند التخطي
                await context.read<OnBoardingCubit>().completeOnBoarding();
                if (context.mounted) {
                  GoRouter.of(context).pushReplacement(AppRoutes.mainScreen);
                }
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primary, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                AppLocalizations.of(context)!.translate(LangKeys.skip),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: canNext
                  ? () async {
                      // 🔥 حفظ التفضيلات المختارة والذهاب للرئيسية
                      await context
                          .read<OnBoardingCubit>()
                          .completeOnBoarding();
                      if (context.mounted) {
                        GoRouter.of(
                          context,
                        ).pushReplacement(AppRoutes.mainScreen);
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.primary.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: Text(
                AppLocalizations.of(
                  context,
                )!.translate(LangKeys.startExploring),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
