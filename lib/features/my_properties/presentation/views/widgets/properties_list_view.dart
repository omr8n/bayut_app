import 'package:flutter/material.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import 'my_property_item.dart';

class PropertiesListView extends StatelessWidget {
  const PropertiesListView({super.key, required this.properties, this.onReservedAction});

  final List<PropertyEntity> properties;
  final VoidCallback? onReservedAction; // 🔥 دالة لإخطار الواجهة بالانتقال

  @override
  Widget build(BuildContext context) {
    if (properties.isEmpty) {
      return const Center(child: Text('لا توجد عقارات في هذا القسم.'));
    }

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: properties.length,
        itemBuilder: (context, index) {
          return MyPropertyItem(
            property: properties[index],
            onReserved: onReservedAction, // تمرير الوظيفة للبطاقة
          );
        },
      ),
    );
  }
}
