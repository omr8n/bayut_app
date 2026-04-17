import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:test_graduation/core/utils/styles.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("سجل نشاطات المسؤولين", style: Styles.textStyle18),
        centerTitle: true,
      ),
      body: BlocBuilder<AdminActionCubit, AdminActionState>(
        builder: (context, state) {
          if (state is AdminActionLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AdminActionFailure) {
            return Center(child: Text(state.errMessage));
          } else if (state is AdminActionSuccess) {
            if (state.actions.isEmpty) {
              return const Center(child: Text("لا توجد سجلات حالياً"));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.actions.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final action = state.actions[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getActionColor(action.actionType),
                    child: Icon(
                      _getActionIcon(action.actionType),
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  title: Text(action.description, style: Styles.textStyle14),
                  subtitle: Text(
                    "${action.adminName} • ${DateFormat('yyyy-MM-dd HH:mm').format(action.createdAt)}",
                    style: Styles.textStyle12.copyWith(color: Colors.grey),
                  ),
                  isThreeLine: true,
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Color _getActionColor(String type) {
    switch (type) {
      case 'DELETE_PROPERTY':
        return Colors.red;
      case 'BLOCK_USER':
        return Colors.black87;
      case 'CHANGE_STATUS':
        return Colors.blue;
      case 'FEATURE_PROPERTY':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getActionIcon(String type) {
    switch (type) {
      case 'DELETE_PROPERTY':
        return Icons.delete_forever;
      case 'BLOCK_USER':
        return Icons.block;
      case 'CHANGE_STATUS':
        return Icons.edit_note;
      case 'FEATURE_PROPERTY':
        return Icons.star;
      default:
        return Icons.info;
    }
  }
}
