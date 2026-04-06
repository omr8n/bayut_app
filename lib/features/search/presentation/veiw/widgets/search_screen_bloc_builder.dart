import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:test_graduation/core/data/mock_data.dart';
import 'package:test_graduation/features/home/presentation/view/widgets/recent_properties.dart';
import '../../manager/search_cubit/search_cubit.dart'; // 🔥
import 'empty_state.dart';
import 'search_results_count.dart';

class SearchScreenBlocBuilder extends StatelessWidget {
  const SearchScreenBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔥 التعديل: الاستماع لـ SearchCubit المستقل
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        if (state is SearchSuccess) {
          final properties = state.properties;

          if (properties.isEmpty) {
            return const SliverFillRemaining(
              hasScrollBody: false,
              child: EmptyState(),
            );
          }

          return SliverMainAxisGroup(
            slivers: [
              SliverToBoxAdapter(
                child: SearchResultsCount(count: properties.length),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 8)),
              RecentProperties(properties: properties),
            ],
          );
        }

        if (state is SearchFailure) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Text(state.errMessage, style: const TextStyle(color: Colors.red)),
            ),
          );
        }

        // Skeleton Loading State
        return Skeletonizer.sliver(
          enabled: true,
          child: SliverMainAxisGroup(
            slivers: [
              SliverToBoxAdapter(
                child: SearchResultsCount(count: 3),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 8)),
              RecentProperties(
                properties: MockData.properties.take(3).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
