import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/core/constants/app_constants.dart';
import 'package:test_graduation/core/routing/app_routes.dart';
import 'package:test_graduation/core/services/secure_storage_singleton.dart'; // 🔥 استخدام SecureStorage حصراً
import 'package:test_graduation/core/services/shared_preferences_singleton.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/on_boarding/presentation/manager/on_boarding_cubit.dart';

class LocationStep extends StatefulWidget {
  const LocationStep({super.key});

  @override
  State<LocationStep> createState() => _LocationStepState();
}

class _LocationStepState extends State<LocationStep> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnBoardingCubit, OnBoardingState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Center(
                child: Column(
                  children: [
                    Text(
                      'ما المواقع التي تفضلها؟',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'يمكنك اختيار عدة محافظات مفضلة',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: AppColors.greyBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: const InputDecoration(
                    hintText: 'ابحث عن محافظة سورية...',
                    prefixIcon: Icon(Icons.search, color: AppColors.primary),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Chips
              if (state.selectedLocations.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: state.selectedLocations.map((location) {
                    return Chip(
                      label: Text(
                        location,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      deleteIcon: const Icon(
                        Icons.close,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      onDeleted: () => context
                          .read<OnBoardingCubit>()
                          .toggleLocation(location),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(color: AppColors.primary),
                      ),
                    );
                  }).toList(),
                ),
              const SizedBox(height: 24),
              const Text(
                'المحافظات الأكثر بحثاً',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              // List
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: AppConstants.governorates
                        .where((gov) => gov.contains(searchController.text))
                        .map((location) {
                          final isSelected = state.selectedLocations.contains(
                            location,
                          );
                          return InkWell(
                            onTap: () => context
                                .read<OnBoardingCubit>()
                                .toggleLocation(location),
                            borderRadius: BorderRadius.circular(15),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary.withOpacity(0.1)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.grey.shade200,
                                  width: 1.2,
                                ),
                              ),
                              child: Text(
                                location,
                                style: TextStyle(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.textSecondary,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        })
                        .toList(),
                  ),
                ),
              ),
              _buildBottomActionButtons(
                context,
                state.selectedLocations.length,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomActionButtons(BuildContext context, int count) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30, top: 20),
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
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'رجوع',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 18,
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
              onPressed: () async {
                // 🔥 التحديث النهائي: حفظ حالة المشاهدة في التخزين المشفر
                Prefs.setBool('isOnBoardingSeen', true);

                // الانتقال فوراً للرئيسية
                if (context.mounted) {
                  GoRouter.of(context).pushReplacement(AppRoutes.mainScreen);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                count > 0 ? 'عرض $count نتائج' : 'تخطي',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
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
