import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_cubit.dart';
import 'package:test_graduation/features/auth/domain/entites/user_entity.dart';
import 'user_item_card.dart'; // استخدام الكارت الاحترافي الجديد

class AdminUsersList extends StatelessWidget {
  const AdminUsersList({super.key, required this.users});

  final List<UserEntity> users;

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return const Center(
        child: Text('لا يوجد مستخدمين يطابقون البحث'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        // استخدام UserItemCard بدلاً من الكارت القديم المسبب للمشاكل
        return UserItemCard(
          user: user,
          adminCubit: context.read<AdminCubit>(),
        );
      },
    );
  }
}
