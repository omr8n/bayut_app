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
      backgroundColor: const Color(0xFFFBFBFC), // خلفية رمادية خفيفة جداً كما في الصورة
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'الإشعارات',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () => context.read<UserNotificationCubit>().markAllAsRead(userId),
            child: Text(
              'تحديد الكل كمقروء',
              style: TextStyle(fontSize: 12.sp, color: AppColors.primary),
            ),
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
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.notifications_none_rounded, size: 64.sp, color: Colors.grey.shade300),
                    SizedBox(height: 16.h),
                    Text('لا يوجد إشعارات حالياً', style: TextStyle(color: Colors.grey.shade500)),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              itemCount: state.notifications.length,
              itemBuilder: (context, index) {
                return _NotificationItem(
                  notification: state.notifications[index],
                  userId: userId,
                );
              },
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

  @override
  Widget build(BuildContext context) {
    // الألوان المستوحاة من الصورة
    final isUnread = !notification.isRead;
    final backgroundColor = isUnread ? const Color(0xFFEDF2F7) : Colors.white;
    final dotColor = Colors.redAccent;

    return GestureDetector(
      onTap: () {
        if (isUnread) {
          context.read<UserNotificationCubit>().markAsSeen(userId, notification.id);
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isUnread ? const Color(0xFFCBD5E0) : Colors.grey.shade100,
            width: 0.5,
          ),
          boxShadow: [
            if (!isUnread)
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // المحتوى النصي والتاريخ
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (isUnread) ...[
                        Container(
                          width: 8.w,
                          height: 8.w,
                          decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
                        ),
                        SizedBox(width: 8.w),
                      ],
                      Text(
                        DateFormat('dd/MM').format(notification.sentAt),
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.grey.shade400,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        notification.title,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2D3748),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    notification.body,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: const Color(0xFF718096),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            // الأيقونة كما في الصورة (مربع بخلفية فاتحة)
            _buildThemedIcon(),
          ],
        ),
      ),
    );
  }

  Widget _buildThemedIcon() {
    IconData iconData;
    Color iconColor;
    Color bgColor;

    switch (notification.type) {
      case NotificationType.adminAction:
        if (notification.title.contains('حظر')) {
          iconData = Icons.lock_person_rounded;
          iconColor = Colors.redAccent;
          bgColor = Colors.red.shade50;
        } else if (notification.title.contains('فك')) {
          iconData = Icons.lock_open_rounded;
          iconColor = Colors.green;
          bgColor = Colors.green.shade50;
        } else if (notification.title.contains('عقار')) {
          iconData = Icons.home_work_rounded;
          iconColor = AppColors.primary;
          bgColor = AppColors.primary.withOpacity(0.1);
        } else {
          iconData = Icons.admin_panel_settings_rounded;
          iconColor = Colors.blueGrey;
          bgColor = Colors.blueGrey.shade50;
        }
        break;
      case NotificationType.promotion:
        iconData = Icons.auto_awesome_rounded; // أيقونة النجوم كما في الصورة
        iconColor = const Color(0xFFF6AD55); // لون ذهبي
        bgColor = const Color(0xFFFFFAF0);
        break;
      case NotificationType.warning:
        iconData = Icons.report_problem_rounded;
        iconColor = Colors.orange;
        bgColor = Colors.orange.shade50;
        break;
      default:
        iconData = Icons.notifications_active_rounded;
        iconColor = Colors.grey.shade400;
        bgColor = Colors.grey.shade50;
    }

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Icon(iconData, color: iconColor, size: 24.sp),
    );
  }
}
