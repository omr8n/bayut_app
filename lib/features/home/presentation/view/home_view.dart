import 'package:flutter/material.dart';
import 'package:test_graduation/core/widgets/search_bar_widget.dart';
import 'package:test_graduation/features/home/presentation/view/widgets/featuerd_properties_section.dart';
import 'package:test_graduation/features/home/presentation/view/widgets/home_header.dart';
import 'package:test_graduation/features/home/presentation/view/widgets/list_type_buttons.dart';
import 'package:test_graduation/features/home/presentation/view/widgets/recent_properties_section.dart';
import 'search_screen.dart';

// الصفحة الرئيسية
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
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            HomeHeader(),

            // Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: SearchBarWidget(
                  controller: _searchController,
                  onChanged: (value) {
                    // يمكنك إضافة بحث مباشر هنا
                  },

                  onFilterTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SearchScreen(),
                      ),
                    );
                  },
                ),
              ),
            ),

            // أزرار بيع/إيجار
            ListTypeButtons(),

            // عقارات مميزة
            FeatuerdPropertiesSection(),

            RecentPropertiesSection(),

            // مسافة في الأسفل
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),

      // Bottom Navigation
      // bottomNavigationBar: CustomBottonNavigationBar(),
    );
  }
}
