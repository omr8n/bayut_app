import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:test_graduation/core/cubits/property_cubit/property_cubit.dart';
import 'package:test_graduation/core/data/mock_data.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';

import 'recent_properties.dart';

class RecentPropertyBlocBuilder extends StatelessWidget {
  const RecentPropertyBlocBuilder({super.key, this.searchController});

  final TextEditingController? searchController;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return BlocBuilder<PropertyCubit, PropertyState>(
      builder: (context, state) {
        if (state is PropertySuccess) {
          if (state.recentProperties.isEmpty) {
            return SliverToBoxAdapter(
              child: Center(
                child: Text(localizations.translate(LangKeys.noProperties)),
              ),
            );
          }
          return RecentProperties(properties: state.recentProperties);
        } else {
          // 🔥 التصحيح: استخدام Skeletonizer.sliver لأن الودجت بداخل Viewport يتوقع Slivers
          return Skeletonizer.sliver(
            enabled: true,
            child: RecentProperties(
              properties: MockData.properties.take(3).toList(),
            ),
          );
        }
      },
    );
  }
}
