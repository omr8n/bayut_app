import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:test_graduation/core/utils/strings_ar.dart';
import 'featured_properties_bloc_builder.dart'; // 🔥 استدعاء الودجت الجديد
import 'properties_header.dart';

class FeatuerdPropertiesSection extends StatelessWidget {
  const FeatuerdPropertiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiSliver(
      children: [
        SliverToBoxAdapter(
          child: PropertiesHeader(
            title: AppStrings.featuredProperties,
            onViewAll: () {},
          ),
        ),
        // 🔥 وضع الـ Builder في Sliver خاص به ليعرض السلايدر الأفقي بأمان
        const SliverToBoxAdapter(child: FeaturedPropertiesBlocBuilder()),
      ],
    );
  }
}
