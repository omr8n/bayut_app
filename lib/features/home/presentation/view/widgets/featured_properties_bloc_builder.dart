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
            return const SliverToBoxAdapter(child: SizedBox.shrink());
          }
          return SliverToBoxAdapter(
            child: FeaturedProperties(properties: state.featuredProperties),
          );
        } else if (state is PropertyFailure) {
          return SliverToBoxAdapter(
            child: SizedBox(
              height: 300,
              child: Center(child: Text(state.errMessage)),
            ),
          );
        } else {
          // 🔥 التصحيح: استخدام Skeletonizer (العادي) لأن الأب هو SliverToBoxAdapter (يتوقع Box)
          return SliverToBoxAdapter(
            child: Skeletonizer(
              enabled: true,
              child: FeaturedProperties(
                properties: MockData.properties.take(2).toList(),
              ),
            ),
          );
        }
      },
    );
  }
}
