import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/cubits/property_cubit/property_cubit.dart';
import 'package:test_graduation/features/home/presentation/view/widgets/recent_properties.dart';
import 'empty_state.dart';
import 'search_results_count.dart';

class SearchScreenBlocBuilder extends StatelessWidget {
  const SearchScreenBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PropertyCubit, PropertyState>(
      builder: (context, state) {
        if (state is PropertyLoading) {
          return const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is PropertyFailure) {
          return SliverFillRemaining(
            child: Center(child: Text(state.errMessage, style: const TextStyle(color: Colors.red))),
          );
        }

        if (state is PropertySuccess) {
          final properties = state.properties;

          if (properties.isEmpty) {
            return const SliverFillRemaining(
              child: EmptyState(),
            );
          }

          return MultiSliver(
            children: [
              SliverToBoxAdapter(
                child: SearchResultsCount(count: properties.length),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 8)),
              RecentProperties(properties: properties),
            ],
          );
        }

        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }
}

// ويدجت داخلي لجمع السليفرز بانسجام
class MultiSliver extends StatelessWidget {
  final List<Widget> children;
  const MultiSliver({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(slivers: children);
  }
}
