import 'package:go_router/go_router.dart';
import 'package:test_graduation/features/auth/presentation/views/login_view.dart';
import 'package:test_graduation/features/root/presentation/views/root_view.dart';

// import '../../features/auth/login_screen.dart';
// import '../../features/root_view/root_veiw.dart';
// import '../../features/on_boarding_screen/on_boarding_screen.dart';
// import '../../features/verify_otp/verify_otp_screen.dart';
import 'app_routes.dart';

class RouterGenerationConfig {
  static GoRouter goRouter = GoRouter(
    initialLocation: AppRoutes.onBoardingScreen,
    routes: [
      // GoRoute(
      //   path: AppRoutes.onBoardingScreen,
      //   name: AppRoutes.onBoardingScreen,
      //   builder: (context, state) => const OnBoardingScreen(),
      // ),
      GoRoute(
        path: AppRoutes.loginScreen,
        name: AppRoutes.loginScreen,
        builder: (context, state) => const LoginView(),
      ),
      // GoRoute(
      //   path: AppRoutes.verifyOtpScreen,
      //   name: AppRoutes.verifyOtpScreen,
      //   builder: (context, state) => const VerifyOtpScreen(),
      // ),
      GoRoute(
        path: AppRoutes.mainScreen,
        name: AppRoutes.mainScreen,
        builder: (context, state) => const RootView(),
      ),
    ],
  );
}
