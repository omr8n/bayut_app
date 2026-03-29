import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:test_graduation/core/utils/service_locator.dart';
import 'package:test_graduation/features/my_properties/presentation/manager/my_properties_cubit.dart';
import 'package:test_graduation/features/my_properties/presentation/views/widgets/my_properties_view_bloc_builder.dart';

class MyPropertiesScreen extends StatelessWidget {
  const MyPropertiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔥 المرجع الأساسي والوحيد: الكاش المشفر الفوري
    // final bool isLoggedIn = SecureStorage.isLoggedIn;

    // log("User is logged in: $isLoggedIn");
    //  log("User data: ${user}");

    // 🎯 إذا كان مسجلاً (True) ولديه كائن مستخدم -> ادخله فوراً وبدون EmptyBag
    // if (isLoggedIn) {
    return BlocProvider(
      create: (context) => getIt.get<MyPropertiesCubit>(),
      child: const MyPropertiesViewBlocBuilder(),
    );
    // }

    // إذا لم يكن مسجلاً -> اظهر صفحة التنبيه
    // return EmptyBagProperties(
    //   onPressed: () => GoRouter.of(context).push(AppRoutes.loginScreen),
    // );
  }
}
