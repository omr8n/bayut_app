import 'package:flutter/material.dart';

import 'package:test_graduation/core/widgets/property_card.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';

class SellerPropertiesView extends StatelessWidget {
  const SellerPropertiesView({
    super.key,
    required this.properties,
    required this.sellerName,
  });

  final List<PropertyEntity> properties;
  final String sellerName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('عقارات $sellerName'), centerTitle: true),
      body: properties.isEmpty
          ? const Center(child: Text('لا يوجد عقارات معروضة حالياً'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: properties.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: PropertyCard(property: properties[index]),
                );
              },
            ),
    );
  }
}
