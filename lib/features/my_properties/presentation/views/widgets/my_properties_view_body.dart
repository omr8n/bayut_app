import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/core/routing/app_routes.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/core/utils/strings_ar.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import 'package:test_graduation/features/my_properties/presentation/manager/my_properties_cubit.dart';
import 'package:test_graduation/features/my_properties/presentation/views/widgets/properties_list_view.dart';

class MyPropertiesViewBody extends StatefulWidget {
  final List<PropertyEntity> properties;
  const MyPropertiesViewBody({super.key, required this.properties});

  @override
  State<MyPropertiesViewBody> createState() => _MyPropertiesViewBodyState();
}

class _MyPropertiesViewBodyState extends State<MyPropertiesViewBody>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void navigateToReservedTab() {
    if (_tabController.index != 1) {
      _tabController.animateTo(1);
    }
  }

  // 🔥 دالة التحديث عند السحب
  Future<void> _onRefresh() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      context.read<MyPropertiesCubit>().fetchMyProperties(user.uid);
      // ننتظر قليلاً لضمان ظهور مؤشر التحميل بشكل مريح للمستخدم
      await Future.delayed(const Duration(milliseconds: 1000));
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final active = widget.properties.where((p) => !p.isReserved).toList();
    final reserved = widget.properties.where((p) => p.isReserved).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      appBar: AppBar(
        title: const Text('عقاراتي'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'النشطة'),
            Tab(text: 'المحجوزة'),
          ],
        ),
      ),
      // 🔥 إضافة ميزة السحب للتحديث
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: AppColors.primary,
        backgroundColor: Colors.white,
        child: TabBarView(
          controller: _tabController,
          children: [
            PropertiesListView(properties: active, onReservedAction: navigateToReservedTab),
            PropertiesListView(properties: reserved),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => GoRouter.of(context).push(AppRoutes.addPropertyScreen),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          AppStrings.addProperty,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
