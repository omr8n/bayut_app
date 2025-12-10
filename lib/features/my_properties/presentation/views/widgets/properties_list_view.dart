import 'package:flutter/material.dart';

import 'package:test_graduation/core/models/property_model.dart';
import 'package:test_graduation/features/my_properties/presentation/views/widgets/my_property_item.dart';

class PropertiesListView extends StatelessWidget {
  const PropertiesListView({super.key, required this.myProperties});
  final List<Property> myProperties;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: myProperties.length,
      itemBuilder: (context, index) {
        final property = myProperties[index];
        return MyPropertyItem(property: property);
      },
    );
  }
}
