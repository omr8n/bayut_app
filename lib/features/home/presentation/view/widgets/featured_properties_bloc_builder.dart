import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:test_graduation/core/cubits/property_cubit/property_cubit.dart';
import 'package:test_graduation/core/data/mock_data.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';

import 'featuerd_properties.dart';
import 'promotion_fallback_card.dart';

class FeaturedPropertiesBlocBuilder extends StatelessWidget {
  const FeaturedPropertiesBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PropertyCubit, PropertyState>(
      builder: (context, state) {
        if (state is PropertySuccess) {
          // دمج القوائم مع حذف التكرار (إذا كان العقار تريند ومميز بنفس الوقت)
          final Map<String, PropertyEntity> combinedMap = {};

          for (var p in state.featuredProperties) {
            combinedMap[p.id] = p;
          }
          for (var p in state.trendingProperties) {
            combinedMap[p.id] = p;
          }

          final allFeatured = combinedMap.values.toList();

          if (allFeatured.isEmpty) {
            // 🔥 إذا لم يوجد مميز أو تريند، نعرض الكارد الأزرق "المنقذ"
            return SliverToBoxAdapter(
              child: PromotionFallbackCard(
                onTap: () {
                  // هنا يمكن توجيه المستخدم لصفحة "عقاراتي" لطلب التميز
                },
              ),
            );
          }
          // عرض العقارات المميزة والتريند
          return SliverToBoxAdapter(
            child: FeaturedProperties(properties: allFeatured),
          );
        } else {
          // 🔥 تحميل هيكلي (Skeleton) للعقارات المميزة
          return SliverToBoxAdapter(
            child: Skeletonizer(
              enabled: true,
              child: FeaturedProperties(
                properties: MockData.properties
                    .where((p) => p.isFeatured)
                    .take(2)
                    .toList(),
              ),
            ),
          );
        }
      },
    );
  }
}
