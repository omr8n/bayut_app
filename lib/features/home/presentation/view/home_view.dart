import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/cubits/property_cubit/property_cubit.dart';
import 'package:test_graduation/core/utils/service_locator.dart';
import 'package:test_graduation/core/widgets/search_bar_widget.dart';
import 'package:test_graduation/features/home/presentation/view/widgets/featuerd_properties_section.dart';
import 'package:test_graduation/features/home/presentation/view/widgets/home_header.dart';
import 'package:test_graduation/features/home/presentation/view/widgets/list_type_buttons.dart';
import 'package:test_graduation/features/home/presentation/view/widgets/recent_properties_section.dart';
import '../../../search/presentation/veiw/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 🔥 تغليف الصفحة بـ BlocProvider ليكون الكيوبيت متاحاً لكل الودجت الفرعية
    return BlocProvider(
      create: (context) => getIt.get<PropertyCubit>()..fetchProperties(),
      child: Scaffold(
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              const HomeHeader(),

              // Search Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Builder(
                    builder: (context) => SearchBarWidget(
                      controller: _searchController,
                      onChanged: (value) {
                        // تفعيل البحث المباشر
                        context.read<PropertyCubit>().searchProperties(value);
                      },
                      onFilterTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SearchScreen()),
                        );
                      },
                    ),
                  ),
                ),
              ),

              const ListTypeButtons(),

              // عقارات مميزة (featured)
              const FeatuerdPropertiesSection(),

              // أحدث العقارات (recent)
              const RecentPropertiesSection(),

              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),
        ),
      ),
    );
  }
}
