import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:test_graduation/core/cubits/property_cubit/property_cubit.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/routing/app_routes.dart';
import 'featured_properties_bloc_builder.dart';
import 'properties_header.dart';

class FeatuerdPropertiesSection extends StatelessWidget {
  const FeatuerdPropertiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return MultiSliver(
      children: [
        SliverToBoxAdapter(
          child: PropertiesHeader(
            title: localizations.translate(LangKeys.featuredProperties),
            onViewAll: () {
              final state = context.read<PropertyCubit>().state;
              if (state is PropertySuccess) {
                GoRouter.of(context).push(
                  AppRoutes.propertiesListScreen,
                  extra: {
                    'title': localizations.translate(LangKeys.featuredProperties),
                    'properties': state.featuredProperties,
                  },
                );
              }
            },
          ),
        ),
        const FeaturedPropertiesBlocBuilder(),
      ],
    );
  }
}
