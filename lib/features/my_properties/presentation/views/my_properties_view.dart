import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/core/routing/app_routes.dart';

import 'package:test_graduation/features/my_properties/presentation/views/widgets/empty_bag_properties.dart';
import 'package:test_graduation/features/my_properties/presentation/views/widgets/my_properties_view_bloc_builder.dart';
import 'package:test_graduation/features/profile/presentation/manager/profile_cubit/profile_cubit.dart';

class MyPropertiesScreen extends StatelessWidget {
  const MyPropertiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        // الاعتماد على الحالة الحالية للـ ProfileCubit كمصدر وحيد للحقيقة
        final user = context.watch<ProfileCubit>().user;

        if (user != null) {
          return const MyPropertiesViewBlocBuilder();
        }

        return EmptyBagProperties(
          onPressed: () => context.pushNamed(AppRoutes.loginScreen),
        );
      },
    );
  }
}
