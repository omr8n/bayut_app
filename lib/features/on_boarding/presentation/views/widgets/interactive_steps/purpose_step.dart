import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/enums/property_enums.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/on_boarding/presentation/manager/on_boarding_cubit.dart';

class PurposeStep extends StatelessWidget {
  const PurposeStep({super.key});

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
                )!.translate(LangKeys.lookForSaleOrRent),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 50),
              _buildPillOption(
                context,
                title: ListingType.rent.localizedName(context),
                isSelected: state.listingType == ListingType.rent,
                onTap: () => context.read<OnBoardingCubit>().setListingType(
                  ListingType.rent,
                ),
              ),
              const SizedBox(height: 16),
              _buildPillOption(
                context,
                title: ListingType.sale.localizedName(context),
                isSelected: state.listingType == ListingType.sale,
                onTap: () => context.read<OnBoardingCubit>().setListingType(
                  ListingType.sale,
                ),
              ),
              const Spacer(),
              _buildBottomActionButtons(context, state.listingType != null),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPillOption(
    BuildContext context, {
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(50),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary.withValues(alpha: 0.1)
            : Colors.white,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: isSelected ? AppColors.primary : Colors.grey.shade200,
          width: 1.2,
        ),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          color: isSelected ? AppColors.primary : AppColors.textSecondary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        ),
      ),
    ),
  );

  Widget _buildBottomActionButtons(BuildContext context, bool canNext) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 55,
            child: OutlinedButton(
              onPressed: () => context.read<OnBoardingCubit>().nextStep(),
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
                  ? () => context.read<OnBoardingCubit>().nextStep()
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.primary.withValues(
                  alpha: 0.3,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: Text(
                AppLocalizations.of(context)!.translate(LangKeys.next),
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
