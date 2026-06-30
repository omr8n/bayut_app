import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_action_cubit/admin_action_cubit.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_action_cubit/admin_action_state.dart';

class AuditLogsScreen extends StatefulWidget {
  const AuditLogsScreen({super.key});

  @override
  State<AuditLogsScreen> createState() => _AuditLogsScreenState();
}

class _AuditLogsScreenState extends State<AuditLogsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AdminActionCubit>().fetchAdminActions();
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        title: Text(local.audit_logs),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: BlocBuilder<AdminActionCubit, AdminActionState>(
        builder: (context, state) {
          if (state is AdminActionLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AdminActionSuccess) {
            if (state.actions.isEmpty) {
              return _buildEmptyState(local);
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.actions.length,
              itemBuilder: (context, index) {
                final action = state.actions[index];
                return _buildActionCard(action, local);
              },
            );
          } else if (state is AdminActionFailure) {
            return Center(
              child: Text("${local.error_label}${state.errMessage}"),
            );
          }
          return Center(child: Text(local.initializing_data));
        },
      ),
    );
  }

  Widget _buildActionCard(dynamic action, AppLocalizations local) {
    final dateStr = DateFormat('yyyy/MM/dd HH:mm').format(action.createdAt);

    Color typeColor;
    IconData typeIcon;

    switch (action.actionType) {
      case 'BLOCK_USER':
        typeColor = Colors.red;
        typeIcon = Icons.block;
        break;
      case 'DELETE_PROPERTY':
        typeColor = Colors.orange;
        typeIcon = Icons.delete_forever;
        break;
      case 'CHANGE_STATUS':
      case 'UPDATE_REPORT':
        typeColor = Colors.blue;
        typeIcon = Icons.edit_note;
        break;
      default:
        typeColor = Colors.grey;
        typeIcon = Icons.info_outline;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: typeColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(typeIcon, color: typeColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      action.adminName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    Text(
                      dateStr,
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  action.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF475569),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  local.target_id_label.replaceFirst('{id}', action.targetId),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[400],
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations local) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_rounded, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            local.no_logs_found,
            style: TextStyle(fontSize: 18, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
