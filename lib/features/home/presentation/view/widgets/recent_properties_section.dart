import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:test_graduation/core/cubits/property_cubit/property_cubit.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/routing/app_routes.dart';
import 'package:test_graduation/features/home/presentation/view/widgets/properties_header.dart';
import 'package:test_graduation/features/home/presentation/view/widgets/recent_property_bloc_builder.dart';

class RecentPropertiesSection extends StatelessWidget {
  const RecentPropertiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return BlocBuilder<PropertyCubit, PropertyState>(
      builder: (context, state) {
        return MultiSliver(
          children: [
            SliverToBoxAdapter(
              child: PropertiesHeader(
                title: localizations.translate(LangKeys.recentProperties),
                onViewAll: () {
                  if (state is PropertySuccess) {
                    GoRouter.of(context).push(
                      AppRoutes.propertiesListScreen,
                      extra: {
                        'title': localizations.translate(LangKeys.recentProperties),
                        'properties': state.recentProperties,
                      },
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
