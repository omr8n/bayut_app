import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_cubit.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_state.dart';
import 'package:test_graduation/features/auth/domain/entites/user_entity.dart';
import 'admin_users_header.dart';
import 'admin_users_list.dart';

class AdminUsersViewBody extends StatefulWidget {
  const AdminUsersViewBody({super.key});

  @override
  State<AdminUsersViewBody> createState() => _AdminUsersViewBodyState();
}

class _AdminUsersViewBodyState extends State<AdminUsersViewBody> {
  String searchQuery = '';
  String? selectedStatus;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubit, AdminState>(
      listener: (context, state) {
        if (state is AdminFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.translate(state.errMessage)),
              backgroundColor: Colors.red,
            ),
          );
        }
        if (state is AdminActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is AdminLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is AdminUsersSuccess) {
          List<UserEntity> filteredUsers = state.users.where((user) {
            final matchesSearch = user.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
                                user.email.toLowerCase().contains(searchQuery.toLowerCase());
            final matchesStatus = selectedStatus == null || user.status == selectedStatus;
            return matchesSearch && matchesStatus;
          }).toList();

          return Column(
            children: [
              AdminUsersHeader(
                onSearchChanged: (val) => setState(() => searchQuery = val),
                onFilterChanged: (status) => setState(() => selectedStatus = status),
              ),
              // Optional: Add Stats bar for users here
              Expanded(
                child: AdminUsersList(users: filteredUsers),
              ),
            ],
          );
        }

        return Center(child: Text(AppLocalizations.of(context)!.loading_users));
      },
    );
  }
}
