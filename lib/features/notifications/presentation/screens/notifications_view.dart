import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as dev;

import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/models/notification_model.dart';
import 'package:test_graduation/features/notifications/presentation/manager/user_notification_cubit.dart';
import 'package:test_graduation/features/profile/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:test_graduation/core/routing/app_routes.dart';
import 'package:test_graduation/core/routing/router_generation_config.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    // استخدم watch بدلاً من read لضمان التحديث إذا تغير المستخدم
    final user = context.watch<ProfileCubit>().user;
    final userId = user?.uId ?? '';
    final locale = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? null : const Color(0xFFFBFBFC),
      appBar: AppBar(
        title: Text(
          locale.notifications,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        actions: [
          if (userId.isNotEmpty)
            TextButton(
              onPressed: () =>
                  context.read<UserNotificationCubit>().markAllAsRead(userId),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
              ),
              child: Text(
                locale.mark_all_as_read,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: userId.isEmpty 
        ? Center(child: Text(locale.please_login_to_view_notifications))
        : BlocBuilder<UserNotificationCubit, UserNotificationState>(
            builder: (context, state) {
              if (state is UserNotificationLoading) {
                return const Center(child: CircularProgressIndicator.adaptive());
              }

              if (state is UserNotificationFailure) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline_rounded,
                            color: Colors.redAccent, size: 48.sp),
                        SizedBox(height: 16.h),
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                        ),
                        SizedBox(height: 16.h),
                        ElevatedButton(
                          onPressed: () => context.read<UserNotificationCubit>().getNotifications(userId),
                          child: Text(locale.retry),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (state is UserNotificationSuccess) {
                if (state.notifications.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(30.w),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.grey.withValues(alpha: 0.05)
                                : Colors.grey.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.notifications_none_rounded,
                            size: 80.sp,
                            color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                          ),
                        ),
                        SizedBox(height: 24.h),
                        Text(
                          locale.no_notifications_currently,
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator.adaptive(
                  onRefresh: () async =>
                      context.read<UserNotificationCubit>().getNotifications(userId),
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    itemCount: state.notifications.length,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return _NotificationItem(
                        notification: state.notifications[index],
                        userId: userId,
                      );
                    },
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final AppNotification notification;
  final String userId;

  const _NotificationItem({required this.notification, required this.userId});

  void _handleNavigation(BuildContext context) {
    if (notification.targetId != null && notification.targetId!.isNotEmpty) {
      dev.log("Deep linking to Property: ${notification.targetId}");
      RouterGenerationConfig.goRouter.pushNamed(
        AppRoutes.propertyDetailsById,
        pathParameters: {'id': notification.targetId!},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUnread = !notification.isRead;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color backgroundColor = isUnread
        ? (isDark ? const Color(0xFF1E293B) : const Color(0xFFF0F4F8))
        : (isDark ? Theme.of(context).cardColor : Colors.white);

    final Color borderColor = isUnread
        ? (isDark ? Colors.blue.withValues(alpha: 0.4) : const Color(0xFFD1DCE5))
        : (isDark ? Colors.grey.shade800 : Colors.grey.shade100);

    final isEn = AppLocalizations.of(context)?.isEnLocale ?? false;

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: InkWell(
        onTap: () {
          if (isUnread) {
            context.read<UserNotificationCubit>().markAsSeen(
              userId,
              notification.id,
            );
          }
          _handleNavigation(context);
        },
        borderRadius: BorderRadius.circular(20.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: borderColor, width: 1.2),
            boxShadow: [
              if (!isUnread)
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isEn) ...[
                _buildThemedIcon(context, isDark),
                SizedBox(width: 16.w),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      isEn ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        if (!isEn) ...[
                          Text(
                            DateFormat('dd/MM HH:mm')
                                .format(notification.sentAt),
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: isDark
                                  ? Colors.grey.shade500
                                  : Colors.grey.shade400,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Flexible(
                                  child: Text(
                                    _getLocalizedText(
                                        context, notification.title, notification.titleKey, null),
                                    textAlign: TextAlign.end,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w800,
                                      color: isDark
                                          ? Colors.white
                                          : const Color(0xFF1A202C),
                                    ),
                                  ),
                                ),
                                if (isUnread) ...[
                                  SizedBox(width: 8.w),
                                  _buildUnreadDot(),
                                ],
                              ],
                            ),
                          ),
                        ] else ...[
                          if (isUnread) ...[
                            _buildUnreadDot(),
                            SizedBox(width: 8.w),
                          ],
                          Expanded(
                            child: Text(
                              _getLocalizedText(context, notification.title, notification.titleKey, null),
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w800,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF1A202C),
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            DateFormat('dd/MM HH:mm')
                                .format(notification.sentAt),
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: isDark
                                  ? Colors.grey.shade500
                                  : Colors.grey.shade400,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      _getLocalizedText(context, notification.body, notification.bodyKey, notification.bodyArgs),
                      textAlign: isEn ? TextAlign.left : TextAlign.right,
                      style: TextStyle(
                        fontSize: 13.5.sp,
                        color: isDark
                            ? Colors.grey.shade400
                            : const Color(0xFF4A5568),
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isEn) ...[
                SizedBox(width: 16.w),
                _buildThemedIcon(context, isDark),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUnreadDot() {
    return Container(
      width: 8.w,
      height: 8.w,
      decoration: const BoxDecoration(
        color: Colors.redAccent,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.redAccent,
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }

  String _getLocalizedText(BuildContext context, String fallback, String? key, Map<String, dynamic>? args) {
    if (key == null || key.isEmpty) return _fallbackLocalization(context, fallback);
    
    final locale = AppLocalizations.of(context)!;
    String translated = locale.translate(key);
    
    if (args != null) {
      args.forEach((k, v) {
        translated = translated.replaceFirst('{$k}', v.toString());
      });
    }
    
    return translated;
  }

  String _fallbackLocalization(BuildContext context, String text) {
    // Keep existing fallback logic for old notifications without keys
    final locale = AppLocalizations.of(context)!;
    final t = text.toLowerCase();

    if (t.contains('premium activated') ||
        t.contains('تم تفعيل التميز') ||
        t.contains('premium approved')) {
      return locale.property_featured_title;
    }
    // ... rest of the existing fallback logic if needed, 
    // but simplified to just return text if no match
    return text;
  }

  Widget _buildThemedIcon(BuildContext context, bool isDark) {
    IconData iconData;
    Color iconColor;
    Color bgColor;

    if (notification.type == NotificationType.propertyFeatured || 
             notification.title.contains('مميز') || notification.title.contains('Featured')) {
      iconData = Icons.auto_awesome_rounded;
      iconColor = const Color(0xFFF6AD55);
      bgColor = iconColor.withValues(alpha: isDark ? 0.15 : 0.1);
    }
    else if (notification.type == NotificationType.promotion || 
             notification.body.contains('استلام') || notification.body.contains('received')) {
      iconData = Icons.rocket_launch_rounded;
      iconColor = const Color(0xFF38B2AC);
      bgColor = iconColor.withValues(alpha: isDark ? 0.15 : 0.1);
    }
    else if (notification.type == NotificationType.warning || notification.type == NotificationType.report) {
      iconData = Icons.report_problem_rounded;
      iconColor = Colors.orangeAccent;
      bgColor = iconColor.withValues(alpha: isDark ? 0.15 : 0.1);
    }
    else if (notification.type == NotificationType.adminAction) {
      iconData = Icons.admin_panel_settings_rounded;
      iconColor = Colors.blueAccent;
      bgColor = iconColor.withValues(alpha: isDark ? 0.15 : 0.1);
    }
    else {
      iconData = Icons.notifications_active_rounded;
      iconColor = Theme.of(context).primaryColor;
      bgColor = iconColor.withValues(alpha: isDark ? 0.15 : 0.1);
    }

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          if (!notification.isRead)
            BoxShadow(
              color: iconColor.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Icon(iconData, color: iconColor, size: 26.sp),
    );
  }
}
