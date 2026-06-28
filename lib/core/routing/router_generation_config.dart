import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/core/cubits/property_cubit/property_cubit.dart';
import 'package:test_graduation/core/routing/base_routes.dart';
import 'package:test_graduation/core/services/secure_storage_singleton.dart';
import 'package:test_graduation/core/services/shared_preferences_singleton.dart';
import 'package:test_graduation/core/utils/service_locator.dart';

import 'package:test_graduation/features/admin/presentation/views/admin_properties_view.dart';
import 'package:test_graduation/features/auth/domain/entites/user_entity.dart';
import 'package:test_graduation/features/auth/presentation/views/register_view.dart';
import 'package:test_graduation/features/auth/presentation/views/sigin_view.dart';
import 'package:test_graduation/features/auth/presentation/views/forget_password_view.dart';

import 'package:test_graduation/features/home/presentation/view/details_view.dart';
import 'package:test_graduation/features/home/presentation/view/properties_list_view.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';

import 'package:test_graduation/features/on_boarding/presentation/views/on_boarding_view.dart';
import 'package:test_graduation/features/profile/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:test_graduation/features/profile/presentation/views/seller_profile_view.dart';
import 'package:test_graduation/features/profile/presentation/views/seller_properties_view.dart';
import 'package:test_graduation/features/root/presentation/views/root_view.dart';
import 'package:test_graduation/features/my_properties/presentation/views/add_property_screen.dart';
import 'package:test_graduation/features/search/presentation/veiw/filter_screen.dart';
import 'package:test_graduation/features/search/presentation/veiw/location_search_page.dart';
import 'package:test_graduation/features/home/presentation/view/video_view.dart';
import 'package:test_graduation/features/my_properties/presentation/views/my_properties_view.dart';
import 'package:test_graduation/features/profile/presentation/views/contact_view.dart';
import 'package:test_graduation/features/profile/presentation/views/edit_profile_view.dart';
import 'package:test_graduation/features/profile/presentation/views/favorites_view.dart';
import 'package:test_graduation/features/profile/presentation/views/guide_view.dart';
import 'package:test_graduation/features/profile/presentation/views/profile_view.dart';
import 'package:test_graduation/features/profile/presentation/views/settings_view.dart';
import 'package:test_graduation/features/profile/presentation/views/terms_view.dart';
import 'package:test_graduation/features/notifications/presentation/screens/notifications_view.dart';

import 'package:test_graduation/features/my_properties/presentation/views/property_dashboard_view.dart';

// Admin Imports
import 'package:test_graduation/features/admin/presentation/views/admin_dashboard_screen.dart';
import 'package:test_graduation/features/admin/presentation/views/admin_users_screen.dart';

import 'package:test_graduation/features/admin/presentation/views/admin_reports_screen.dart';
import 'package:test_graduation/features/admin/presentation/views/admin_notifications_screen.dart';
import 'package:test_graduation/features/admin/presentation/views/admin_settings_screen.dart';
import 'package:test_graduation/features/admin/presentation/views/audit_logs_screen.dart';
import 'package:test_graduation/features/admin/presentation/views/financial_transfers_view.dart'; // 🔥 إضافة المحفظة

import 'package:test_graduation/features/admin/presentation/manager/admin_cubit.dart';

import 'package:test_graduation/features/admin/presentation/manager/admin_action_cubit/admin_action_cubit.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_notification_cubit/admin_notification_cubit.dart';
import 'app_routes.dart';

class RouterGenerationConfig {
  static GoRouter goRouter = GoRouter(
    initialLocation: AppRoutes.onBoardingScreen,
    // 🔥 إضافة refreshListenable لجعل الراوتر يشعر بتغييرات الحالة
    // لكن بما أننا لا نملك ChangeNotifier لـ Auth، سنقوم بتعديل الـ Redirect ليكون أكثر ذكاءً
    redirect: (context, state) {
      final bool isOnBoardingSeen = Prefs.getBool('isOnBoardingSeen');
      // الفحص المباشر من SecureStorage لضمان أحدث قيمة
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

        // إذا كان يحاول الذهاب للـ Login وهو مسجل دخول فعلياً، نرجعه للـ Main
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
          return BaseRoute(child: PropertyDashboardView(property: property));
        },
      ),
      GoRoute(
        path: AppRoutes.myPropertiesScreen,
        name: AppRoutes.myPropertiesScreen,
        pageBuilder: (context, state) =>
            BaseRoute(child: const MyPropertiesScreen()),
      ),
      GoRoute(
        path: AppRoutes.settingsView,
        name: AppRoutes.settingsView,
        pageBuilder: (context, state) => BaseRoute(child: const SettingsView()),
      ),
      GoRoute(
        path: AppRoutes.editProfileView,
        name: AppRoutes.editProfileView,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return BaseRoute(
            child: EditProfileView(
              user: extra['user'] as UserEntity,
              isPasswordChange: extra['isPasswordChange'] as bool? ?? false,
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.guideView,
        name: AppRoutes.guideView,
        pageBuilder: (context, state) => BaseRoute(child: const GuideView()),
      ),
      GoRoute(
        path: AppRoutes.termsView,
        name: AppRoutes.termsView,
        pageBuilder: (context, state) => BaseRoute(child: const TermsView()),
      ),
      GoRoute(
        path: AppRoutes.contactView,
        name: AppRoutes.contactView,
        pageBuilder: (context, state) => BaseRoute(child: const ContactView()),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        name: AppRoutes.notifications,
        pageBuilder: (context, state) =>
            BaseRoute(child: const NotificationsView()),
      ),

      GoRoute(
        path: AppRoutes.adminDashboard,
        name: AppRoutes.adminDashboard,
        redirect: (context, state) {
          final user = context.read<ProfileCubit>().user;
          if (user == null || !user.isAdmin) {
            return AppRoutes.mainScreen;
          }
          return null;
        },
        pageBuilder: (context, state) => BaseRoute(
          child: BlocProvider(
            create: (context) => getIt<AdminCubit>(),
            child: const AdminDashboardScreen(),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.adminUsers,
        name: AppRoutes.adminUsers,
        redirect: (context, state) {
          final user = context.read<ProfileCubit>().user;
          if (user == null || !user.isAdmin) {
            return AppRoutes.mainScreen;
          }
          return null;
        },
        pageBuilder: (context, state) => BaseRoute(
          child: BlocProvider(
            create: (context) => getIt<AdminCubit>(),
            child: const AdminUsersScreen(),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.adminProperties,
        name: AppRoutes.adminProperties,
        redirect: (context, state) {
          final user = context.read<ProfileCubit>().user;
          if (user == null || !user.isAdmin) {
            return AppRoutes.mainScreen;
          }
          return null;
        },
        pageBuilder: (context, state) => BaseRoute(
          child: BlocProvider(
            create: (context) => getIt<AdminCubit>(),
            child: const AdminPropertiesView(),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.adminReports,
        name: AppRoutes.adminReports,
        redirect: (context, state) {
          final user = context.read<ProfileCubit>().user;
          if (user == null || !user.isAdmin) {
            return AppRoutes.mainScreen;
          }
          return null;
        },
        pageBuilder: (context, state) => BaseRoute(
          child: BlocProvider(
            create: (context) => getIt<AdminCubit>(),
            child: const AdminReportsScreen(),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.adminNotifications,
        name: AppRoutes.adminNotifications,
        redirect: (context, state) {
          final user = context.read<ProfileCubit>().user;
          if (user == null || !user.isAdmin) {
            return AppRoutes.mainScreen;
          }
          return null;
        },
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return BaseRoute(
            child: MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => getIt<AdminCubit>()),
                BlocProvider(
                  create: (context) =>
                      getIt<AdminNotificationCubit>()..fetchNotificationsHistory(),
                ),
              ],
              child: AdminNotificationsScreen(
                targetUserId: extra?['uId'],
                targetUserName: extra?['name'],
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.adminSettings,
        name: AppRoutes.adminSettings,
        redirect: (context, state) {
          final user = context.read<ProfileCubit>().user;
          if (user == null || !user.isAdmin) {
            return AppRoutes.mainScreen;
          }
          return null;
        },
        pageBuilder: (context, state) => BaseRoute(
          child: BlocProvider(
            create: (context) => getIt<AdminCubit>(),
            child: const AdminSettingsScreen(),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.adminAuditLogs,
        name: AppRoutes.adminAuditLogs,
        redirect: (context, state) {
          final user = context.read<ProfileCubit>().user;
          if (user == null || !user.isAdmin) {
            return AppRoutes.mainScreen;
          }
          return null;
        },
        pageBuilder: (context, state) => BaseRoute(
          child: BlocProvider(
            create: (context) => getIt<AdminActionCubit>(),
            child: const AuditLogsScreen(),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.adminFinancials,
        name: AppRoutes.adminFinancials,
        redirect: (context, state) {
          final user = context.read<ProfileCubit>().user;
          if (user == null || !user.isAdmin) {
            return AppRoutes.mainScreen;
          }
          return null;
        },
        pageBuilder: (context, state) => BaseRoute(
          child: const FinancialTransfersView(),
        ),
      ),
    ],
  );
}
