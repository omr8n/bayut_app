import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/routing/app_routes.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import 'package:test_graduation/features/profile/presentation/manager/rating_cubit/rating_cubit.dart';
import 'package:test_graduation/features/profile/presentation/manager/rating_cubit/rating_state.dart';

class SellerHeader extends StatelessWidget {
  final PropertyEntity property;

  const SellerHeader({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // زر العقارات
              GestureDetector(
                onTap: () {
                  GoRouter.of(context).push(
                    AppRoutes.sellerPropertiesView,
                    extra: {
                      'sellerId': property.sellerId,
                      'sellerName': property.sellerName,
                    },
                  );
                },
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE3F2FD),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.home,
                        color: Color(0xFF0D47A1),
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      locale.translate(LangKeys.myProperties),
                      style: const TextStyle(
                        color: Color(0xFF0D47A1),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // 🔥 قسم بيانات المعلن والتقييم المتوسط
              Expanded(
                child: Column(
                  children: [
                    Text(
                      property.sellerName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      locale.translate(property.sellerJoinDate),
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 10),

                    // 🎯 طلبك: حساب وعرض المتوسط الحسابي للتقييمات
                    BlocBuilder<RatingCubit, RatingState>(
                      builder: (context, state) {
                        double average = 0.0;
                        int totalReviews = 0;

                        if (state is RatingsLoaded &&
                            state.ratings.isNotEmpty) {
                          totalReviews = state.ratings.length;
                          double sum = 0;
                          for (var r in state.ratings) {
                            sum += r.rating;
                          }
                          average = sum / totalReviews;
                        } else {
                          average = property
                              .sellerRating; // القيمة الافتراضية إذا لم يوجد تقييمات
                        }

                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  average.toStringAsFixed(1),
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Row(
                                  children: List.generate(
                                    5,
                                    (index) => Icon(
                                      index < average.floor()
                                          ? Icons.star_rounded
                                          : Icons.star_border_rounded,
                                      color: AppColors.primary,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '${locale.translate(LangKeys.sellerRatingCount)} ($totalReviews)',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),

              // الصورة الشخصية
              CircleAvatar(
                radius: 45,
                backgroundColor: const Color(0xFFE3F2FD),
                backgroundImage: property.sellerImage != null
                    ? NetworkImage(property.sellerImage!)
                    : null,
                child: property.sellerImage == null
                    ? Text(
                        property.sellerName[0],
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
