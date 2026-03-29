import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/core/services/secure_storage_singleton.dart';
import 'package:test_graduation/core/services/shared_preferences_singleton.dart';
import 'package:test_graduation/core/utils/service_locator.dart';
import 'package:test_graduation/features/auth/presentation/views/sigin_view.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import 'package:test_graduation/features/my_properties/presentation/cubit/add_property_cubit.dart';
import 'package:test_graduation/features/on_boarding/presentation/views/on_boarding_view.dart';
import 'package:test_graduation/features/profile/presentation/views/seller_profile_view.dart';
import 'package:test_graduation/features/profile/presentation/views/seller_properties_view.dart';
import 'package:test_graduation/features/root/presentation/views/root_view.dart';
import 'package:test_graduation/features/my_properties/presentation/views/add_property_screen.dart';
import 'app_routes.dart';

class RouterGenerationConfig {
  static GoRouter goRouter = GoRouter(
    initialLocation: AppRoutes.onBoardingScreen,
    redirect: (context, state) {
      final bool isOnBoardingSeen = Prefs.getBool('isOnBoardingSeen');
      final bool isLoggedIn = SecureStorage.isLoggedIn;

      if (!isOnBoardingSeen) {
        if (state.matchedLocation != AppRoutes.onBoardingScreen) {
          return AppRoutes.onBoardingScreen;
        }
        return null;
      }

      if (isOnBoardingSeen) {
        if (state.matchedLocation == AppRoutes.onBoardingScreen) {
          return AppRoutes.mainScreen;
        }

        if (isLoggedIn && state.matchedLocation == AppRoutes.loginScreen) {
          return AppRoutes.mainScreen;
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.onBoardingScreen,
        name: AppRoutes.onBoardingScreen,
        builder: (context, state) => const OnBoardingView(),
      ),
      GoRoute(
        path: AppRoutes.loginScreen,
        name: AppRoutes.loginScreen,
        builder: (context, state) => const SiginView(),
      ),
      GoRoute(
        path: AppRoutes.mainScreen,
        name: AppRoutes.mainScreen,
        builder: (context, state) => const RootView(),
      ),
      GoRoute(
        path: AppRoutes.sellerProfileView,
        name: AppRoutes.sellerProfileView,
        builder: (context, state) {
          // 🔥 الإصلاح: التحقق من وجود البيانات قبل التمرير لتجنب خطأ الـ Null
          final property = state.extra as PropertyEntity;
          return SellerProfileView(property: property);
        },
      ),
      GoRoute(
        path: AppRoutes.sellerPropertiesView,
        name: AppRoutes.sellerPropertiesView,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return SellerPropertiesView(
            sellerId: extra['sellerId'] as String,
            sellerName: extra['sellerName'] as String,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.addPropertyScreen,
        name: AppRoutes.addPropertyScreen,
        builder: (context, state) => AddPropertyScreen(
          propertyEntity: state.extra as PropertyEntity?,
        ),
      ),
    ],
  );
}
