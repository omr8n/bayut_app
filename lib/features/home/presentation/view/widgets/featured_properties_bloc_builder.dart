import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:test_graduation/core/cubits/property_cubit/property_cubit.dart';
import 'package:test_graduation/core/data/mock_data.dart';

import 'featuerd_properties.dart';

class FeaturedPropertiesBlocBuilder extends StatelessWidget {
  const FeaturedPropertiesBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PropertyCubit, PropertyState>(
      builder: (context, state) {
        if (state is PropertySuccess) {
          if (state.featuredProperties.isEmpty) {
            // إذا لم يوجد مميز، نخفي القسم تماماً
            return const SliverToBoxAdapter(child: SizedBox.shrink());
          }
          // عرض العقارات المميزة الحقيقية
          return SliverToBoxAdapter(
            child: FeaturedProperties(properties: state.featuredProperties),
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
