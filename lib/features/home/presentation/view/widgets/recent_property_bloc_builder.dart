import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/cubits/property_cubit/property_cubit.dart';
import 'package:test_graduation/core/utils/service_locator.dart';
// import 'featuerd_properties.dart';
import 'recent_properties.dart';

// enum PropertyGroup { featured, recent }

class RecentPropertyBlocBuilder extends StatelessWidget {
  const RecentPropertyBlocBuilder({
    super.key,
    this.searchController,
    // this.group = PropertyGroup.recent,
  });

  final TextEditingController? searchController;
  // final PropertyGroup group;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<PropertyCubit>()..fetchProperties(),
      child: BlocBuilder<PropertyCubit, PropertyState>(
        builder: (context, state) {
          if (state is PropertyLoading) {
            return const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(child: CircularProgressIndicator()),
              ),
            );
          }

          if (state is PropertyFailure) {
            return SliverToBoxAdapter(
              child: Center(
                child: Text(
                  'خطأ: ${state.errMessage}',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          if (state is PropertySuccess) {
            // 🔥 العودة للتصميم الأفقي للسلايدر العلوي

            // التصميم الرأسي لقائمة أحدث العقارات
            if (state.recentProperties.isEmpty) {
              return const SliverToBoxAdapter(
                child: Center(child: Text('لا توجد عقارات حديثة')),
              );
            } else {
              return RecentProperties(properties: state.recentProperties);
            }
          }

          return const SliverToBoxAdapter(child: SizedBox.shrink());
        },
      ),
    );
  }
}
