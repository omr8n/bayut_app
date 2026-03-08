import 'package:flutter/material.dart';

import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import 'my_property_item.dart';

class PropertiesListView extends StatelessWidget {
  const PropertiesListView({super.key, required this.properties});

  final List<PropertyEntity> properties;

  @override
  Widget build(BuildContext context) {
    if (properties.isEmpty) {
      return const Center(child: Text('لا توجد عقارات مضافة بعد.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: properties.length,
      itemBuilder: (context, index) {
        return MyPropertyItem(property: properties[index]);
      },
    );
  }
}
