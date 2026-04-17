import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:test_graduation/core/routing/app_routes.dart';
import 'package:test_graduation/core/services/secure_storage_singleton.dart';
import 'package:test_graduation/core/services/firebase_auth_service.dart';
import 'package:test_graduation/core/data/mock_data.dart';

import 'package:test_graduation/features/my_properties/presentation/cubit/add_property_cubit.dart';
import 'package:test_graduation/features/my_properties/presentation/cubit/add_property_state.dart';
import 'package:test_graduation/features/my_properties/presentation/manager/my_properties_cubit.dart';
import 'package:test_graduation/features/my_properties/presentation/views/widgets/empty_bag_properties.dart';
import 'package:test_graduation/core/widgets/no_network_widget.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/features/my_properties/presentation/views/widgets/my_properties_view_body.dart';

class MyPropertiesViewBlocBuilder extends StatelessWidget {
  const MyPropertiesViewBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isLoggedIn = SecureStorage.isLoggedIn;
    final user = FirebaseAuthService().currentUser;

    log(
      "BlocBuilder Check: isLoggedIn = $isLoggedIn, FirebaseUser = ${user?.uid}",
    );

    if (!isLoggedIn || user == null) {
      return EmptyBagProperties(
        onPressed: () => GoRouter.of(context).push(AppRoutes.loginScreen),
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        final cubit = context.read<MyPropertiesCubit>();
        if (!cubit.isClosed && cubit.state is MyPropertiesInitial) {
          cubit.fetchMyProperties(user.uid);
        }
      }
    });

    return BlocListener<AddPropertyCubit, AddPropertyState>(
      listener: (context, state) {
        if (state is UpdatePropertySuccess || state is AddPropertySuccess) {
          context.read<MyPropertiesCubit>().fetchMyProperties(user.uid);
        }
      },
      child: BlocBuilder<MyPropertiesCubit, MyPropertiesState>(
        builder: (context, state) {
          if (state is MyPropertiesSuccess) {
            return Column(
              children: [
                if (state.isOffline)
                  Container(
                    width: double.infinity,
                    color: Colors.orange.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      AppLocalizations.of(
                        context,
                      )!.translate(LangKeys.offlineMode),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                Expanded(
                  child: MyPropertiesViewBody(properties: state.properties),
                ),
              ],
            );
          } else if (state is MyPropertiesFailure) {
            return NoNetworkWidget(
              onRetry: () {
                context.read<MyPropertiesCubit>().fetchMyProperties(user.uid);
              },
            );
          } else {
            // 🔥 الإصلاح: استخدام Skeletonizer العادي لأننا لسنا بداخل Viewport يتوقع Slivers
            return Skeletonizer(
              enabled: true,
              child: MyPropertiesViewBody(
                properties: MockData.properties.take(3).toList(),
              ),
            );
          }
        },
      ),
    );
  }
}
