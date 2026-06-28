import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/models/notification_model.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_cubit.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_notification_cubit/admin_notification_cubit.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_state.dart';
import 'package:test_graduation/features/auth/domain/entites/user_entity.dart';
import 'widgets/admin_notifications/user_search_delegate.dart';

class AdminNotificationsScreen extends StatefulWidget {
  final String? targetUserId;
  final String? targetUserName;

  const AdminNotificationsScreen({
    super.key,
    this.targetUserId,
    this.targetUserName,
  });

  @override
  State<AdminNotificationsScreen> createState() =>
      _AdminNotificationsScreenState();
}

class _AdminNotificationsScreenState extends State<AdminNotificationsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  late bool _sendToAll;
  String? _selectedUserId;
  String? _selectedUserName;
  NotificationType _selectedType = NotificationType.general;

  @override
  void initState() {
    super.initState();
    _sendToAll = widget.targetUserId == null;
    _selectedUserId = widget.targetUserId;
    _selectedUserName = widget.targetUserName;

    if (_selectedUserName != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          final locale = AppLocalizations.of(context)!;
          _titleController.text =
              locale.alert_for.replaceFirst('{name}', _selectedUserName!);
        }
      });
    }
    context.read<AdminCubit>().getStats();
    context.read<AdminCubit>().fetchUsers(); // Fetch users list for search
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        title: Text(locale.admin_notifications),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<AdminNotificationCubit, AdminNotificationState>(
            listener: (context, state) {
              if (state is AdminNotificationSendSuccess) {
                _titleController.clear();
                _bodyController.clear();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.success,
                  ),
                );
              } else if (state is AdminNotificationSendFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errMessage),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
          ),
          BlocListener<AdminCubit, AdminState>(
            listener: (context, state) {
              if (state is AdminFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errMessage),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
          ),
        ],
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSendForm(locale),
              const SizedBox(height: 32),
              Text(
                locale.sent_notifications_history,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              _buildNotificationsHistory(locale),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSendForm(AppLocalizations locale) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
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
                Expanded(
                  child: Text(
                    locale.send_new_notification,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[900],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.send_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: locale.notification_title,
                hintText: locale.notification_title_hint,
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (v) => (v == null || v.isEmpty) ? locale.retry : null,
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _bodyController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: locale.notification_message,
                hintText: locale.notification_message_hint,
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (v) => (v == null || v.isEmpty) ? locale.retry : null,
            ),
            const SizedBox(height: 24),

            Text(
              locale.notification_type,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: NotificationType.values.map((type) {
                final isSelected = _selectedType == type;
                return GestureDetector(
                  onTap: () => setState(() => _selectedType = type),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.transparent,
                      ),
                    ),
                    child: Text(
                      _getTypeArabicName(type, locale),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.blueGrey,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            _buildRecipientSelector(locale),

            const SizedBox(height: 24),

            BlocBuilder<AdminNotificationCubit, AdminNotificationState>(
              builder: (context, state) {
                final bool isSending = state is AdminNotificationSendLoading;
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: isSending ? null : () => _handleSend(locale),
                    icon: isSending
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.send_rounded, color: Colors.white),
                    label: Text(
                      isSending ? locale.sending : locale.send_notification,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
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

  Widget _buildRecipientSelector(AppLocalizations locale) {
    return BlocBuilder<AdminCubit, AdminState>(
      builder: (context, state) {
        int totalUsersCount = 0;
        List<UserEntity> allUsers = [];
        if (state is AdminStatsSuccess) {
          totalUsersCount = state.stats.totalUsers;
        }
        if (state is AdminUsersSuccess) {
          allUsers = state.users;
          if (totalUsersCount == 0) totalUsersCount = allUsers.length;
        }

        return Column(
          children: [
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                locale.send_to_all_users,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                _sendToAll
                    ? locale.send_to_all_hint.replaceFirst('{count}', totalUsersCount.toString())
                    : (_selectedUserName != null
                          ? '${locale.recipient}: $_selectedUserName'
                          : locale.send_to_user_hint),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              value: _sendToAll,
              onChanged: (v) => setState(() => _sendToAll = v),
              activeColor: AppColors.primary,
            ),
            if (!_sendToAll)
              GestureDetector(
                onTap: () async {
                  final user = await showSearch<UserEntity?>(
                    context: context,
                    delegate: UserSearchDelegate(allUsers, searchLabel: locale.search),
                  );
                  if (user != null) {
                    setState(() {
                      _selectedUserId = user.uId;
                      _selectedUserName = user.name;
                    });
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.withOpacity(0.1)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.person_search_rounded,
                        color: Colors.blue,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _selectedUserName ?? locale.send_to_user_hint,
                          style: TextStyle(
                            color: _selectedUserName != null ? Colors.blue : Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      if (_selectedUserName != null)
                        const Icon(Icons.edit, size: 14, color: Colors.blue),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildNotificationsHistory(AppLocalizations locale) {
    return BlocBuilder<AdminNotificationCubit, AdminNotificationState>(
      builder: (context, state) {
        if (state is AdminNotificationLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is AdminNotificationFailure) {
          return Center(child: Text(state.errMessage));
        }

        if (state is AdminNotificationSuccess) {
          final notifications = state.notifications;
          if (notifications.isEmpty) {
            return Center(
              child: Column(
                children: [
                  Icon(
                    Icons.notifications_off_rounded,
                    size: 64,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    locale.no_notification_history,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notif = notifications[index];
              return _buildHistoryItem(notif, locale);
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildHistoryItem(AppNotification notif, AppLocalizations locale) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getTypeColor(notif.type).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _getTypeArabicName(notif.type, locale),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: _getTypeColor(notif.type),
                  ),
                ),
              ),
              const Spacer(),
              Text(
                DateFormat('yyyy/MM/dd HH:mm').format(notif.sentAt),
                style: TextStyle(fontSize: 11, color: Colors.grey[400]),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            notif.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            notif.body,
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                notif.sentToAll ? Icons.groups_rounded : Icons.person_rounded,
                size: 14,
                color: Colors.blueGrey[300],
              ),
              const SizedBox(width: 4),
              Text(
                notif.sentToAll
                    ? locale.sent_to_all
                    : locale.sent_to_specific_user.replaceFirst('{name}', notif.targetUserName ?? locale.specific_user),
                style: TextStyle(fontSize: 11, color: Colors.blueGrey[300]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getTypeArabicName(NotificationType type, AppLocalizations locale) {
    switch (type) {
      case NotificationType.general: return locale.notif_type_general;
      case NotificationType.warning: return locale.notif_type_warning;
      case NotificationType.promotion: return locale.notif_type_promotion;
      case NotificationType.update: return locale.notif_type_update;
      case NotificationType.report: return locale.notif_type_report;
      case NotificationType.propertyFeatured: return locale.notif_type_property_featured;
      case NotificationType.accountStatus: return locale.notif_type_account_status;
      case NotificationType.adminAction: return locale.notif_type_admin_action;
    }
  }

  Color _getTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.general:
        return AppColors.info;
      case NotificationType.warning:
        return Colors.orange;
      case NotificationType.promotion:
        return Colors.purple;
      case NotificationType.update:
        return Colors.teal;
      case NotificationType.report:
        return Colors.red;
      case NotificationType.propertyFeatured:
        return Colors.amber[700]!;
      case NotificationType.accountStatus:
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  void _handleSend(AppLocalizations locale) {
    if (_formKey.currentState!.validate()) {
      final cubit = context.read<AdminNotificationCubit>();
      if (_sendToAll) {
        cubit.sendGlobalNotification(
          _titleController.text,
          _bodyController.text,
        );
      } else if (_selectedUserId != null) {
        cubit.sendTargetedNotification(
          uId: _selectedUserId!,
          name: _selectedUserName ?? locale.user_label,
          title: _titleController.text,
          body: _bodyController.text,
          type: _selectedType,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(locale.select_user_or_all)),
        );
      }
    }
  }
}
