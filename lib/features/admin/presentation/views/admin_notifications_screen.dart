// import 'package:flutter/material.dart';
// import '../../core/utils/colors.dart';

// class AdminNotificationsScreen extends StatelessWidget {
//   const AdminNotificationsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final notifications = [
//       'تمت إضافة عقار جديد',
//       'تم تسجيل مستخدم جديد',
//       'تم حل بلاغ',
//     ];

//     return Scaffold(
//       appBar: AppBar(title: const Text('الإشعارات'), centerTitle: true),
//       body: ListView.separated(
//         padding: const EdgeInsets.all(16),
//         itemCount: notifications.length,
//         separatorBuilder: (_, __) => const SizedBox(height: 8),
//         itemBuilder: (context, index) {
//           return Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.05),
//                   blurRadius: 4,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Text(
//               notifications[index],
//               style: const TextStyle(fontSize: 14),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_graduation/core/models/notification_model.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/admin/presentation/views/widgets/data/admin_mock_data.dart';

// شاشة إدارة الإشعارات
class AdminNotificationsScreen extends StatefulWidget {
  const AdminNotificationsScreen({super.key});

  @override
  State<AdminNotificationsScreen> createState() =>
      _AdminNotificationsScreenState();
}

class _AdminNotificationsScreenState extends State<AdminNotificationsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  NotificationType _selectedType = NotificationType.general;
  bool _sendToAll = true;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إدارة الإشعارات'), centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // نموذج إرسال إشعار
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.send,
                            color: AppColors.primary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'إرسال إشعار جديد',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // العنوان
                    TextFormField(
                      controller: _titleController,
                      textAlign: TextAlign.right,
                      decoration: const InputDecoration(
                        labelText: 'عنوان الإشعار',
                        hintText: 'مثل: مرحباً بكم في بيوت',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال العنوان';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // الرسالة
                    TextFormField(
                      controller: _bodyController,
                      textAlign: TextAlign.right,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'الرسالة',
                        hintText: 'اكتب الرسالة هنا...',
                        alignLabelWithHint: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال الرسالة';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // نوع الإشعار
                    const Text(
                      'نوع الإشعار',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: NotificationType.values.map((type) {
                        return _buildTypeChip(
                          type.arabicName,
                          _selectedType == type,
                          () => setState(() => _selectedType = type),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // إرسال للجميع
                    SwitchListTile(
                      title: const Text('إرسال لجميع المستخدمين'),
                      subtitle: Text(
                        _sendToAll
                            ? 'سيتم الإرسال لـ ${AdminMockData.users.length} مستخدم'
                            : 'إرسال لمستخدم محدد',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textLight,
                        ),
                      ),
                      value: _sendToAll,
                      onChanged: (value) => setState(() => _sendToAll = value),
                      activeColor: AppColors.primary,
                    ),
                    const SizedBox(height: 20),

                    // زر الإرسال
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _sendNotification,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        icon: const Icon(Icons.send, color: Colors.white),
                        label: const Text(
                          'إرسال الإشعار',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // سجل الإشعارات
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'سجل الإشعارات',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...AdminMockData.notifications.map(
                    (AppNotification notif) => _buildNotificationItem(notif),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.error,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationItem(AppNotification notif) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  notif.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getTypeColor(notif.type).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  notif.type.arabicName,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: _getTypeColor(notif.type),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            notif.body,
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                notif.sentToAll ? Icons.people : Icons.person,
                size: 14,
                color: AppColors.textLight,
              ),
              const SizedBox(width: 4),
              Text(
                '${notif.recipientsCount} مستلم',
                style: TextStyle(fontSize: 12, color: AppColors.textLight),
              ),
              const SizedBox(width: 12),
              Icon(Icons.access_time, size: 14, color: AppColors.textLight),
              const SizedBox(width: 4),
              Text(
                DateFormat('yyyy/MM/dd HH:mm').format(notif.sentAt),
                style: TextStyle(fontSize: 12, color: AppColors.textLight),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.general:
        return AppColors.info;
      case NotificationType.warning:
        return AppColors.warning;
      case NotificationType.promotion:
        return AppColors.success;
      case NotificationType.update:
        return AppColors.primary;
    }
  }

  void _sendNotification() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تم إرسال الإشعار إلى ${_sendToAll ? AdminMockData.users.length : 1} مستخدم',
          ),
          backgroundColor: AppColors.success,
        ),
      );
      _titleController.clear();
      _bodyController.clear();
    }
  }
}
