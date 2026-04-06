import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/core/cubits/property_cubit/property_cubit.dart';
import 'package:test_graduation/core/routing/app_routes.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/core/widgets/search_field_widget.dart';
import 'package:test_graduation/features/home/presentation/view/widgets/featuerd_properties_section.dart';
import 'package:test_graduation/features/home/presentation/view/widgets/home_header.dart';
import 'package:test_graduation/features/home/presentation/view/widgets/list_type_buttons_bloc_builder.dart';
import 'package:test_graduation/features/home/presentation/view/widgets/recent_properties_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<PropertyCubit>().fetchProperties();
        },
        color: AppColors.primary,
        backgroundColor: Colors.white,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // 🔥 الهيدر أصبح SliverToBoxAdapter داخله Widget مرن
            const SliverToBoxAdapter(child: HomeHeader()),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: SearchFieldWidget(
                  readOnly: true, // جعله للعرض فقط ليعمل كـ "زر"
                  onTap: () {
                    // 🔥 التوجه لصفحة اختيار الموقع مباشرة
                    context.push(AppRoutes.locationSearchPage);
                  },
                ),
              ),
            ),

            const ListTypeButtonsBlocBuilder(),
            const FeatuerdPropertiesSection(),
            const RecentPropertiesSection(),
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }
}
