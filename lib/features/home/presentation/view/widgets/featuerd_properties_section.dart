import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:test_graduation/core/cubits/property_cubit/property_cubit.dart';
import 'package:test_graduation/core/utils/strings_ar.dart';
import 'package:test_graduation/features/home/presentation/view/properties_list_view.dart';
import 'featured_properties_bloc_builder.dart';
import 'properties_header.dart';

class FeatuerdPropertiesSection extends StatelessWidget {
  const FeatuerdPropertiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔥 استخدام BlocBuilder فقط للحصول على البيانات عند ضغط "عرض الكل"
    return BlocBuilder<PropertyCubit, PropertyState>(
      builder: (context, state) {
        return MultiSliver(
          children: [
            SliverToBoxAdapter(
              child: PropertiesHeader(
                title: AppStrings.featuredProperties,
                onViewAll: () {
                  if (state is PropertySuccess) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PropertiesListScreen(
                          title: AppStrings.featuredProperties,
                          properties: state.featuredProperties, // 🔥 بيانات حقيقية من Firebase
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            const SliverToBoxAdapter(
              child: FeaturedPropertiesBlocBuilder(),
            ),
          ],
        );
      },
    );
  }
}
