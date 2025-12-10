import 'package:flutter/material.dart';
import 'package:test_graduation/core/data/mock_data.dart';
import 'package:test_graduation/core/utils/strings_ar.dart';
import 'package:test_graduation/features/home/presentation/view/properties_list_view.dart';
import 'package:test_graduation/features/home/presentation/view/widgets/properties_header.dart';
import 'package:test_graduation/features/home/presentation/view/widgets/recent_properties.dart';

class RecentPropertiesSection extends StatelessWidget {
  const RecentPropertiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        PropertiesHeader(
          title: AppStrings.recentProperties,
          onViewAll: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PropertiesListScreen(
                  title: AppStrings.recentProperties,
                  properties: MockData.properties,
                ),
              ),
            );
          },
        ),
        // قائمة العقارات المميزة
        const RecentProperties(),
        // FeaturedProperties(),
      ]),
    );
  }
}
