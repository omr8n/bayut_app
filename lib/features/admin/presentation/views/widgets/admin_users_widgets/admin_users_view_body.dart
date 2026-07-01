import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/utils/colors.dart';
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
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    context.read<AdminCubit>().fetchUsers(isRefresh: true);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() => searchQuery = query);
        context.read<AdminCubit>().searchUsers(query);
      }
    });
  }

  void _onScroll() {
    if (_isBottom && searchQuery.isEmpty) {
      context.read<AdminCubit>().fetchUsers();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubit, AdminState>(
      listener: (context, state) {
        if (state is AdminFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.translate(state.errMessage),
              ),
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
        final isLoading = state is AdminLoading;
        List<UserEntity> users = [];
        bool hasReachedMax = false;

        if (state is AdminUsersSuccess) {
          users = state.users;
          hasReachedMax = state.hasReachedMax;
        }

        List<UserEntity> filteredUsers = users.where((user) {
          final matchesStatus =
              selectedStatus == null || user.status == selectedStatus;
          return matchesStatus;
        }).toList();

        return Column(
          children: [
            if (isLoading && users.isEmpty)
              const LinearProgressIndicator(
                backgroundColor: Colors.transparent,
                color: Color(0xFF1E4C9A),
                minHeight: 3,
              ),
            AdminUsersHeader(
              onSearchChanged: _onSearchChanged,
              onFilterChanged: (status) =>
                  setState(() => selectedStatus = status),
            ),
            // Optional: Add Stats bar for users here
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await context.read<AdminCubit>().fetchUsers(isRefresh: true);
                },
                color: AppColors.primary,
                child: AdminUsersList(
                  users: filteredUsers,
                  scrollController: _scrollController,
                  isLoadingMore:
                      state is AdminUsersSuccess &&
                      !hasReachedMax &&
                      searchQuery.isEmpty,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
