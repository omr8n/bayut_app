import 'package:go_router/go_router.dart';
import 'package:test_graduation/features/auth/presentation/views/login_view.dart';
import 'package:test_graduation/features/on_boarding/presentation/views/on_boarding_view.dart';
import 'package:test_graduation/features/root/presentation/views/root_view.dart';
import 'app_routes.dart';

class RouterGenerationConfig {
  static GoRouter goRouter = GoRouter(
    initialLocation: AppRoutes.onBoardingScreen,
    routes: [
      GoRoute(
        path: AppRoutes.onBoardingScreen,
        name: AppRoutes.onBoardingScreen,
        builder: (context, state) => const OnBoardingView(),
      ),
      GoRoute(
        path: AppRoutes.loginScreen,
        name: AppRoutes.loginScreen,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: AppRoutes.mainScreen,
        name: AppRoutes.mainScreen,
        builder: (context, state) => const RootView(),
      ),
    ],
  );
}
