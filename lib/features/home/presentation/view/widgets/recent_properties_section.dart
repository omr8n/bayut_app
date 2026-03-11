import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:test_graduation/core/utils/strings_ar.dart';
import 'package:test_graduation/features/home/presentation/view/widgets/properties_header.dart';
import 'package:test_graduation/features/home/presentation/view/widgets/recent_property_bloc_builder.dart';

class RecentPropertiesSection extends StatelessWidget {
  const RecentPropertiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiSliver(
      children: [
        SliverToBoxAdapter(
          child: PropertiesHeader(
            title: AppStrings.recentProperties,
            onViewAll: () {
              // منطق عرض الكل
            },
          ),
        ),
        // 🔥 نظيفة تماماً ولا تسبب أي تعارض
        const RecentPropertyBlocBuilder(
          // group: PropertyGroup.recent,
        ),
      ],
    );
  }
}
