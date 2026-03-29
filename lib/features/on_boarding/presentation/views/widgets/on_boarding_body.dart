import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/on_boarding/data/models/on_boarding_model.dart';
import 'package:test_graduation/features/on_boarding/presentation/manager/on_boarding_cubit.dart';
import 'package:test_graduation/features/on_boarding/presentation/views/widgets/page_view_item.dart';

class OnBoardingBody extends StatefulWidget {
  const OnBoardingBody({super.key});

  @override
  State<OnBoardingBody> createState() => _OnBoardingBodyState();
}

class _OnBoardingBodyState extends State<OnBoardingBody> {
  late PageController pageController;
  int currentIndex = 0;

  final List<OnBoardingModel> onBoardingData = [
    OnBoardingModel(
      image: 'assets/images/address_map.png',
      title: 'ابحث عن منزلك المثالي',
      description: 'اكتشف آلاف العقارات المتاحة للبيع والإيجار في أفضل المواقع في سوريا.',
    ),
    OnBoardingModel(
      image: 'assets/images/rounded_map.png',
      title: 'خريطة تفاعلية ذكية',
      description: 'استخدم الخريطة للعثور على العقارات القريبة منك وتصفح المرافق المحيطة بسهولة.',
    ),
    OnBoardingModel(
      image: 'assets/images/successful.png',
      title: 'تواصل مباشر وسريع',
      description: 'تواصل مع المعلنين مباشرة عبر الاتصال أو الواتساب بضغطة زر واحدة.',
    ),
  ];

  @override
  void initState() {
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: pageController,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemCount: onBoardingData.length,
                itemBuilder: (context, index) {
                  return PageViewItem(
                    onBoardingModel: onBoardingData[index],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 50, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Dots Indicator using your Primary color
                  Row(
                    children: List.generate(
                      onBoardingData.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 6),
                        height: 8,
                        width: currentIndex == index ? 28 : 8,
                        decoration: BoxDecoration(
                          color: currentIndex == index ? AppColors.primary : Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  // Action Button using your Primary color
                  currentIndex == onBoardingData.length - 1
                      ? ElevatedButton(
                          onPressed: () {
                            context.read<OnBoardingCubit>().nextStep();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 5,
                            shadowColor: AppColors.primary.withOpacity(0.4),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                          ),
                          child: const Text(
                            'ابدأ الآن',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            pageController.nextPage(
                              duration: const Duration(milliseconds: 600),
                              curve: Curves.fastOutSlowIn,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.white),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
