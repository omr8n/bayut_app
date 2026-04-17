import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_cubit.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import 'admin_property_card.dart';

class AdminPropertiesList extends StatelessWidget {
  final List<PropertyEntity> properties;

  const AdminPropertiesList({super.key, required this.properties});

  @override
  Widget build(BuildContext context) {
    if (properties.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home_work_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('لا توجد عقارات مطابقة للبحث', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: properties.length,
      itemBuilder: (context, index) {
        return AdminPropertyCard(
          property: properties[index],
          adminCubit: context.read<AdminCubit>(),
        );
      },
    );
  }
}
