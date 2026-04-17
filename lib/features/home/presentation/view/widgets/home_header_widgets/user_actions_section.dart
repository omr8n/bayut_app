import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/routing/app_routes.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/profile/presentation/manager/profile_cubit/profile_cubit.dart';

class UserActionsSection extends StatelessWidget {
  const UserActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        // نأخذ المستخدم مباشرة من الـ Cubit
        final user = context.read<ProfileCubit>().user;
        final bool isLoggedIn = user != null;

        return Flexible(
          flex: 3,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (isLoggedIn) ...[
                  _WelcomeText(name: user.name),
                  SizedBox(width: 12.w),
                  const _NotificationBadge(),
                  SizedBox(width: 10.w),
                ],
                _ProfileAvatar(
                  isLoggedIn: isLoggedIn,
                  imageUrl: user?.profilePic,
                  name: user?.name,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _WelcomeText extends StatelessWidget {
  final String? name;
  const _WelcomeText({this.name});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final firstName = name?.split(' ').first ?? localizations.translate(LangKeys.guestUser);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          localizations.isEnLocale ? 'Hello,' : 'هلا،',
          style: TextStyle(
            fontSize: 11.sp,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          firstName,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

class _NotificationBadge extends StatelessWidget {
  const _NotificationBadge();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      icon: Badge(
        label: Text('2', style: TextStyle(fontSize: 10.sp)),
        backgroundColor: Colors.redAccent,
        child: Icon(
          Icons.notifications_none_rounded,
          color: Colors.black87,
          size: 24.sp,
        ),
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  final bool isLoggedIn;
  final String? imageUrl;
  final String? name;

  const _ProfileAvatar({
    required this.isLoggedIn,
    this.imageUrl,
    this.name,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleNavigation(context),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1.5,
          ),
        ),
        child: _buildAvatarChild(context),
      ),
    );
  }

  Widget _buildAvatarChild(BuildContext context) {
    if (!isLoggedIn) {
      return CircleAvatar(
        radius: 18.r,
        backgroundColor: Colors.grey.shade50,
        child: Icon(
          Icons.person_outline_rounded,
          color: Colors.grey.shade700,
          size: 22.sp,
        ),
      );
    }

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      // 🔥 استخدام CachedNetworkImage للسرعة والأداء
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        imageBuilder: (context, imageProvider) => CircleAvatar(
          radius: 18.r,
          backgroundImage: imageProvider,
        ),
        placeholder: (context, url) => CircleAvatar(
          radius: 18.r,
          backgroundColor: Colors.grey.shade200,
        ),
        errorWidget: (context, url, error) => _buildInitialAvatar(),
      );
    }

    return _buildInitialAvatar();
  }

  Widget _buildInitialAvatar() {
    final initial = (name != null && name!.isNotEmpty) ? name![0].toUpperCase() : "U";
    return CircleAvatar(
      radius: 18.r,
      backgroundColor: AppColors.primary.withOpacity(0.1),
      child: Text(
        initial,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
          fontSize: 14.sp,
        ),
      ),
    );
  }

  void _handleNavigation(BuildContext context) {
    if (!isLoggedIn) {
      context.push(AppRoutes.loginScreen);
    } else {
      // السينيور يوجه المستخدم لبروفايله بدلاً من مجرد عرض الصورة
      context.push(AppRoutes.profileView);
    }
  }
}
