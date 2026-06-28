import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_cubit.dart';
import 'package:test_graduation/features/auth/domain/entites/user_entity.dart';
import 'user_item_card.dart'; // Use the new professional card

class AdminUsersList extends StatelessWidget {
  const AdminUsersList({super.key, required this.users});

  final List<UserEntity> users;

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return Center(
        child: Text(AppLocalizations.of(context)!.no_matching_users),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        // Use UserItemCard instead of the old problematic card
        return UserItemCard(user: user, adminCubit: context.read<AdminCubit>());
      },
    );
  }
}
