import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/core/routing/app_routes.dart';
import 'package:test_graduation/core/services/secure_storage_singleton.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/profile/presentation/manager/profile_cubit/profile_cubit.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔥 فحص حالة تسجيل الدخول من الكاش المحصن
    final bool isLoggedIn = SecureStorage.isLoggedIn;

    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // شعار Bayut الاحترافي
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.home_work_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BAYUT',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      'Syrian Real Estate',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // 🔥 عرض صورة المستخدم أو الأيقونة الافتراضية عبر الـ Cubit مباشرة
            BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                final user = context.read<ProfileCubit>().user;
                String? imageUrl = user?.profilePic;
                String initial = (user?.name != null && user!.name.isNotEmpty)
                    ? user.name[0].toUpperCase()
                    : "U";

                return GestureDetector(
                  onTap: () {
                    if (!isLoggedIn) {
                      GoRouter.of(context).push(AppRoutes.loginScreen);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey.shade200,
                        width: 1.5,
                      ),
                    ),
                    child:
                        (isLoggedIn && imageUrl != null && imageUrl.isNotEmpty)
                        ? CircleAvatar(
                            radius: 22,
                            backgroundImage: NetworkImage(imageUrl),
                          )
                        : (isLoggedIn)
                        ? CircleAvatar(
                            radius: 22,
                            backgroundColor: AppColors.primary.withOpacity(0.1),
                            child: Text(
                              initial,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person_outline_rounded,
                              color: Colors.black87,
                              size: 26,
                            ),
                          ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
