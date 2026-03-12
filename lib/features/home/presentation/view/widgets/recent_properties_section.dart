import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:test_graduation/core/cubits/property_cubit/property_cubit.dart';
import 'package:test_graduation/core/utils/strings_ar.dart';
import 'package:test_graduation/features/home/presentation/view/properties_list_view.dart';
import 'package:test_graduation/features/home/presentation/view/widgets/properties_header.dart';

import 'package:test_graduation/features/home/presentation/view/widgets/recent_property_bloc_builder.dart';

class RecentPropertiesSection extends StatelessWidget {
  const RecentPropertiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PropertyCubit, PropertyState>(
      builder: (context, state) {
        return MultiSliver(
          children: [
            SliverToBoxAdapter(
              child: PropertiesHeader(
                title: AppStrings.recentProperties,
                onViewAll: () {
                  if (state is PropertySuccess) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PropertiesListScreen(
                          title: AppStrings.recentProperties,
                          properties:
                              state.recentProperties, // 🔥 بيانات حقيقية
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            const RecentPropertyBlocBuilder(),
          ],
        );
      },
    );
  }
}
