import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/core/models/notification_model.dart';
import 'package:test_graduation/features/notifications/presentation/manager/user_notification_cubit.dart';
import 'package:test_graduation/features/profile/presentation/manager/profile_cubit/profile_cubit.dart'; // 🔥 إضافة ProfileCubit

class NotificationCenterView extends StatefulWidget {
  const NotificationCenterView({super.key});

  @override
  State<NotificationCenterView> createState() => _NotificationCenterViewState();
}

class _NotificationCenterViewState extends State<NotificationCenterView> {
  @override
  void initState() {
    super.initState();
    // 🔥 جلب معرف المستخدم وتمريره للدالة
    final userId = context.read<ProfileCubit>().user?.uId;
    if (userId != null) {
      context.read<UserNotificationCubit>().markAllAsRead(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'مركز الإشعارات',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: isDark ? AppColors.darkBackground : const Color(0xFF00142B),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocBuilder<UserNotificationCubit, UserNotificationState>(
        builder: (context, state) {
          final isLoading = state is UserNotificationLoading;

          return Column(
            children: [
              if (isLoading)
                const LinearProgressIndicator(
                  backgroundColor: Colors.transparent,
                  color: AppColors.primary,
                  minHeight: 3,
                ),
              Expanded(
                child: _buildBodyContent(state),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBodyContent(UserNotificationState state) {
    if (state is UserNotificationSuccess) {
      if (state.notifications.isEmpty) {
        return _buildEmptyState();
      }
      return ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: state.notifications.length,
        itemBuilder: (context, index) {
          return _buildNotificationItem(state.notifications[index]);
        },
      );
    }
    if (state is UserNotificationFailure) {
      return Center(child: Text(state.message));
    }
    if (state is UserNotificationLoading) {
      return const SizedBox.shrink(); // Handled by top LinearProgressIndicator
    }
    return const Center(child: Text('جاري تحميل الإشعارات...'));
  }

  Widget _buildNotificationItem(AppNotification notification) {
    return InkWell(
      onTap: () {
        // 🔥 التوجيه مستقبلاً بناءً على targetId
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: notification.isRead
              ? Theme.of(context).cardColor
              : (Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkSurface
                    : const Color(0xFFF0F7FF)),
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: Theme.of(context).brightness == Brightness.dark
                    ? 0.2
                    : 0.02,
              ),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIcon(context, notification.type),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontWeight: notification.isRead
                          ? FontWeight.normal
                          : FontWeight.bold,
                      fontSize: 14.sp,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black87,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    notification.body,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.textSecondaryDark
                          : Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    DateFormat(
                      'yyyy/MM/dd - hh:mm a',
                      'ar',
                    ).format(notification.sentAt),
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.textSecondaryDark.withValues(alpha: 0.7)
                          : Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context, NotificationType type) {
    IconData icon;
    Color color;

    switch (type) {
      case NotificationType.adminAction:
        icon = Icons.admin_panel_settings_rounded;
        color = AppColors.error;
        break;
      case NotificationType.general:
      default:
        icon = Icons.notifications_active_rounded;
        color = AppColors.primary;
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(
          alpha: Theme.of(context).brightness == Brightness.dark ? 0.2 : 0.1,
        ),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : color,
        size: 20.sp,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none_rounded,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          const Text(
            'لا توجد إشعارات حالياً',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
