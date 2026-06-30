import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/core/helper/my_app_method.dart';
import 'package:test_graduation/core/routing/app_routes.dart';
import 'package:test_graduation/core/services/firebase_auth_service.dart';
import 'package:test_graduation/core/utils/service_locator.dart';
import 'package:test_graduation/features/profile/presentation/manager/favorites_cubit/favorites_cubit.dart';
import 'package:test_graduation/features/profile/presentation/manager/favorites_cubit/favorites_state.dart';

class FavoriteButton extends StatelessWidget {
  final String propertyId;
  final double size;
  final Color? backgroundColor;

  const FavoriteButton({
    super.key,
    required this.propertyId,
    this.size = 24,
    this.backgroundColor,
  });

  void _handleTap(BuildContext context) {
    final authService = getIt.get<FirebaseAuthService>();
    if (!authService.isLoggedIn) {
      MyAppMethods.showErrorORWarningDialog(
        context: context,
        subtitle: 'يجب تسجيل الدخول لتتمكن من إضافة العقارات للمفضلة',
        fct: () {
          context.push(AppRoutes.loginScreen);
        },
        isError: false,
      );
      return;
    }
    context.read<FavoritesCubit>().toggleFavorite(propertyId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      buildWhen: (previous, current) => current is FavoritesLoaded,
      builder: (context, state) {
        final bool isFav = context.read<FavoritesCubit>().isFavorite(
          propertyId,
        );

        Widget icon = Icon(
          isFav ? Icons.favorite : Icons.favorite_border,
          color: isFav ? Colors.red : Colors.grey,
          size: size.sp,
        );

        if (backgroundColor != null) {
          return GestureDetector(
            onTap: () => _handleTap(context),
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: backgroundColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: icon,
            ),
          );
        }

        return GestureDetector(
          onTap: () => _handleTap(context),
          child: Padding(
            padding: EdgeInsets.all(4.w), // زيادة مساحة اللمس
            child: icon,
          ),
        );
      },
    );
  }
}
