import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/cubits/property_cubit/property_cubit.dart';
import 'featuerd_properties.dart';

class FeaturedPropertiesBlocBuilder extends StatelessWidget {
  const FeaturedPropertiesBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PropertyCubit, PropertyState>(
      builder: (context, state) {
        if (state is PropertySuccess) {
          if (state.featuredProperties.isEmpty) {
            return const SizedBox.shrink(); // لا تظهر شيئاً إذا كانت القائمة فارغة
          }
          // 🔥 عرض السلايدر الأفقي بالبيانات المجلوبة من الكيوبيت
          return FeaturedProperties(properties: state.featuredProperties);
        } else if (state is PropertyLoading) {
          // إظهار شكل تحميل أنيق يتناسب مع حجم السلايدر
          return const SizedBox(
            height: 300,
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (state is PropertyFailure) {
          return SizedBox(
            height: 300,
            child: Center(child: Text(state.errMessage)),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
