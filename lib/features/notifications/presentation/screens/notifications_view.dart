import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/models/notification_model.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/notifications/presentation/manager/user_notification_cubit.dart';
import 'package:test_graduation/features/profile/presentation/manager/profile_cubit/profile_cubit.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = context.read<ProfileCubit>().user?.uId ?? '';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('الإشعارات'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => context.read<UserNotificationCubit>().markAllAsRead(userId),
            child: const Text('تحديد الكل كمقروء'),
          ),
        ],
      ),
      body: BlocBuilder<UserNotificationCubit, UserNotificationState>(
        builder: (context, state) {
          if (state is UserNotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UserNotificationFailure) {
            return Center(child: Text(state.message));
          }

          if (state is UserNotificationSuccess) {
            if (state.notifications.isEmpty) {
              return const Center(child: Text('لا يوجد إشعارات حالياً'));
            }

            // تقسيم الإشعارات
            final adminNotifications = state.notifications
                .where((n) => n.type == NotificationType.adminAction)
                .toList();
            final otherNotifications = state.notifications
                .where((n) => n.type != NotificationType.adminAction)
                .toList();

            return ListView(
              padding: EdgeInsets.all(16.w),
              children: [
                if (adminNotifications.isNotEmpty) ...[
                  _buildSectionTitle('إجراءات الإدارة'),
                  ...adminNotifications.map((n) => _NotificationItem(notification: n, userId: userId)),
                  SizedBox(height: 20.h),
                ],
                if (otherNotifications.isNotEmpty) ...[
                  _buildSectionTitle('إشعارات عامة'),
                  ...otherNotifications.map((n) => _NotificationItem(notification: n, userId: userId)),
                ],
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h, right: 4.w),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final AppNotification notification;
  final String userId;

  const _NotificationItem({required this.notification, required this.userId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!notification.isRead) {
          context.read<UserNotificationCubit>().markAsSeen(userId, notification.id);
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: notification.isRead ? Colors.white : AppColors.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: notification.isRead ? Colors.grey.shade200 : AppColors.primary.withOpacity(0.2),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIcon(),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    notification.body,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    DateFormat('yyyy/MM/dd HH:mm').format(notification.sentAt),
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ),
            if (!notification.isRead)
              Container(
                width: 8.w,
                height: 8.w,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    IconData icon;
    Color color;

    switch (notification.type) {
      case NotificationType.adminAction:
        icon = Icons.admin_panel_settings_rounded;
        color = AppColors.primary;
        break;
      case NotificationType.warning:
        icon = Icons.warning_amber_rounded;
        color = Colors.orange;
        break;
      default:
        icon = Icons.notifications_none_rounded;
        color = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 20.sp),
    );
  }
}
