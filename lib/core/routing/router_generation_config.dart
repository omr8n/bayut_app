import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/core/cubits/property_cubit/property_cubit.dart';
import 'package:test_graduation/core/routing/base_routes.dart';
import 'package:test_graduation/core/services/secure_storage_singleton.dart';
import 'package:test_graduation/core/services/shared_preferences_singleton.dart';
import 'package:test_graduation/core/utils/service_locator.dart';
import 'package:test_graduation/features/auth/presentation/views/register_view.dart';
import 'package:test_graduation/features/auth/presentation/views/sigin_view.dart';
import 'package:test_graduation/features/auth/presentation/views/forget_password_view.dart';
import 'package:test_graduation/features/auth/presentation/views/verify_otp_view.dart';
import 'package:test_graduation/features/home/presentation/view/details_view.dart';
import 'package:test_graduation/features/home/presentation/view/properties_list_view.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import 'package:test_graduation/features/my_properties/presentation/manager/my_properties_cubit.dart';
import 'package:test_graduation/features/on_boarding/presentation/views/on_boarding_view.dart';
import 'package:test_graduation/features/profile/presentation/views/seller_profile_view.dart';
import 'package:test_graduation/features/profile/presentation/views/seller_properties_view.dart';
import 'package:test_graduation/features/root/presentation/views/root_view.dart';
import 'package:test_graduation/features/my_properties/presentation/views/add_property_screen.dart';
import 'package:test_graduation/features/search/presentation/veiw/filter_screen.dart';
import 'package:test_graduation/features/search/presentation/veiw/location_search_page.dart';
import 'package:test_graduation/features/home/presentation/view/video_view.dart';
import 'package:test_graduation/features/profile/presentation/views/favorites_view.dart';
import 'package:test_graduation/features/profile/presentation/views/profile_view.dart';
import 'package:test_graduation/features/my_properties/presentation/views/property_dashboard_view.dart';
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
        pageBuilder: (context, state) =>
            BaseRoute(child: const OnBoardingView()),
      ),
      GoRoute(
        path: AppRoutes.loginScreen,
        name: AppRoutes.loginScreen,
        pageBuilder: (context, state) => BaseRoute(child: const SiginView()),
      ),
      GoRoute(
        path: AppRoutes.forgetPassword,
        name: AppRoutes.forgetPassword,
        pageBuilder: (context, state) =>
            BaseRoute(child: const ForgetPasswordView()),
      ),
      // GoRoute(
      //   path: AppRoutes.verifyOtpScreen,
      //   name: AppRoutes.verifyOtpScreen,
      //   builder: (context, state) => const VerifyOtpScreen(),
      // ),
      GoRoute(
        path: AppRoutes.mainScreen,
        name: AppRoutes.mainScreen,
        pageBuilder: (context, state) => BaseRoute(child: const RootView()),
      ),
      GoRoute(
        path: AppRoutes.locationSearchPage, // 🔥 تسجيل صفحة المواقع
        name: AppRoutes.locationSearchPage,
        pageBuilder: (context, state) =>
            BaseRoute(child: const LocationSearchPage()),
      ),
      GoRoute(
        path: AppRoutes.sellerProfileView,
        name: AppRoutes.sellerProfileView,
        pageBuilder: (context, state) {
          final property = state.extra as PropertyEntity;
          return BaseRoute(child: SellerProfileView(property: property));
        },
      ),
      GoRoute(
        path: AppRoutes.sellerPropertiesView,
        name: AppRoutes.sellerPropertiesView,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return BaseRoute(
            child: SellerPropertiesView(
              sellerId: extra['sellerId'] as String,
              sellerName: extra['sellerName'] as String,
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.addPropertyScreen,
        name: AppRoutes.addPropertyScreen,
        pageBuilder: (context, state) => BaseRoute(
          child: AddPropertyScreen(
            propertyEntity: state.extra as PropertyEntity?,
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.propertiesListScreen,
        name: AppRoutes.propertiesListScreen,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return BaseRoute(
            child: PropertiesListScreen(
              title: extra['title'] as String,
              properties: extra['properties'] as List<PropertyEntity>,
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.propertyDetailsScreen,
        name: AppRoutes.propertyDetailsScreen,
        pageBuilder: (context, state) {
          if (state.extra is Map<String, dynamic>) {
            final extra = state.extra as Map<String, dynamic>;
            return BaseRoute(
              child: PropertyDetailsScreen(
                property: extra['property'] as PropertyEntity,
                initialIndex: extra['initialIndex'] as int? ?? 0,
              ),
            );
          }
          // للحفاظ على التوافق إذا تم تمرير الـ property مباشرة في مكان آخر
          return BaseRoute(
            child: PropertyDetailsScreen(
              property: state.extra as PropertyEntity,
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.propertyDetailsById,
        name: AppRoutes.propertyDetailsById,
        pageBuilder: (context, state) {
          final String propertyId = state.pathParameters['id']!;
          // هنا نحتاج لجلب العقار من الـ Cubit أو الـ Repository بناءً على الـ ID
          // بما أن PropertyCubit مخزن فيه كل العقارات، سنبحث فيه
          final propertyCubit = context.read<PropertyCubit>();
          PropertyEntity? property;

          if (propertyCubit.state is PropertySuccess) {
            try {
              property = (propertyCubit.state as PropertySuccess).properties
                  .firstWhere((p) => p.id == propertyId);
            } catch (e) {
              property = null;
            }
          }

          if (property != null) {
            return BaseRoute(child: PropertyDetailsScreen(property: property));
          } else {
            // إذا لم نجد العقار (مثلاً الرابط قديم)، نعود للرئيسية أو صفحة خطأ
            return BaseRoute(child: const RootView());
          }
        },
      ),
      GoRoute(
        path: AppRoutes.videoView,
        name: AppRoutes.videoView,
        pageBuilder: (context, state) {
          if (state.extra is Map<String, dynamic>) {
            final extra = state.extra as Map<String, dynamic>;
            return BaseRoute(
              child: VideoView(
                videoUrls: (extra['urls'] as List).cast<String>(),
                initialIndex: extra['index'] as int? ?? 0,
                heroTag: extra['heroTag'] as String?,
                property:
                    extra['property'] as PropertyEntity?, // 🔥 تمرير العقار
              ),
            );
          } else if (state.extra is List) {
            return BaseRoute(
              child: VideoView(videoUrls: (state.extra as List).cast<String>()),
            );
          } else {
            return BaseRoute(
              child: VideoView(videoUrls: [state.extra as String]),
            );
          }
        },
      ),
      GoRoute(
        path: AppRoutes.registerScreen,
        name: AppRoutes.registerScreen,
        pageBuilder: (context, state) => BaseRoute(child: const RegisterView()),
      ),
      GoRoute(
        path: AppRoutes.filterScreen,
        name: AppRoutes.filterScreen,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return BaseRoute(
            child: FilterScreen(
              initialGovernorate: extra?['governorate'] as String?,
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.favoritesView,
        name: AppRoutes.favoritesView,
        pageBuilder: (context, state) =>
            BaseRoute(child: const FavoritesView()),
      ),
      GoRoute(
        path: AppRoutes.profileView,
        name: AppRoutes.profileView,
        pageBuilder: (context, state) => BaseRoute(child: const ProfileView()),
      ),
      GoRoute(
        path: AppRoutes.propertyDashboard,
        name: AppRoutes.propertyDashboard,
        pageBuilder: (context, state) {
          final property = state.extra as PropertyEntity;
          return BaseRoute(
            child: BlocProvider.value(
              value:
                  getIt<
                    MyPropertiesCubit
                  >(), // 🔥 توفير الـ Cubit الموجود أصلاً
              child: PropertyDashboardView(property: property),
            ),
          );
        },
      ),
    ],
  );
}
