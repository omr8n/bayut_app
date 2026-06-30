import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/enums/property_enums.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/on_boarding/presentation/manager/on_boarding_cubit.dart';

class PropertyTypeStep extends StatelessWidget {
  const PropertyTypeStep({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnBoardingCubit, OnBoardingState>(
      builder: (context, state) {
        final List<PropertyType> types = PropertyType.values;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Text(
                AppLocalizations.of(
                  context,
                )!.translate(LangKeys.whatPropertyTypeLookFor),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 30),
              // Grid of Property Types from your Enums
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.9,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemCount: types.length,
                  itemBuilder: (context, index) {
                    final type = types[index];
                    final isSelected = state.propertyType == type;
                    return _buildTypeCircle(
                      title: type.localizedName(context),
                      icon: _getPropertyIcon(type),
                      isSelected: isSelected,
                      onTap: () =>
                          context.read<OnBoardingCubit>().setPropertyType(type),
                    );
                  },
                ),
              ),
              _buildBottomActionButtons(context, state.propertyType != null),
            ],
          ),
        );
      },
    );
  }

  IconData _getPropertyIcon(PropertyType type) {
    switch (type) {
      case PropertyType.buildings:
        return Icons.domain_outlined;
      case PropertyType.housesAndApartments:
        return Icons.apartment_outlined;
      case PropertyType.underConstruction:
        return Icons.construction_outlined;
      case PropertyType.villas:
        return Icons.home_outlined;
      case PropertyType.shops:
        return Icons.store_outlined;
      case PropertyType.mallShops:
        return Icons.local_mall_outlined;
      case PropertyType.lands:
        return Icons.landscape_outlined;
      case PropertyType.farms:
        return Icons.agriculture_outlined;
      case PropertyType.pools:
        return Icons.pool_outlined;
      case PropertyType.clinics:
        return Icons.medical_services_outlined;
      case PropertyType.warehouses:
        return Icons.warehouse_outlined;
      case PropertyType.halls:
        return Icons.event_seat_outlined;
      case PropertyType.offices:
        return Icons.work_outline;
      case PropertyType.workshops:
        return Icons.build_circle_outlined;
    }
  }

  Widget _buildTypeCircle({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : Colors.white,
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.grey.shade200,
                width: 1.5,
              ),
            ),
            child: Icon(
              icon,
              size: 28,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ],
      ),
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
              onPressed: () => context.read<OnBoardingCubit>().previousStep(),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primary, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                AppLocalizations.of(context)!.translate(LangKeys.back),
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
