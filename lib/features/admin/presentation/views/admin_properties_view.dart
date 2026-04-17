import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/core/utils/service_locator.dart';
import 'package:test_graduation/features/admin/domain/repos/admin_repo.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_cubit.dart';
import 'widgets/admin_properties_widgets/admin_properties_view_body.dart';

class AdminPropertiesView extends StatelessWidget {
  const AdminPropertiesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AdminCubit>()..fetchProperties(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFF1E4C9A), // اللون الأزرق الملكي
          title: const Text(
            'إدارة العقارات',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => context.pop(),
          ),
        ),
        body: const AdminPropertiesViewBody(),
      ),
    );
  }
}
