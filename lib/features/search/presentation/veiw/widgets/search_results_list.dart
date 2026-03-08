import 'package:flutter/material.dart';

import 'package:test_graduation/core/widgets/property_card.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';

class SearchResultsList extends StatelessWidget {
  const SearchResultsList({super.key, required this.properties});

  final List<PropertyEntity> properties;

  @override
  Widget build(BuildContext context) {
    if (properties.isEmpty) {
      return const Center(child: Text('لا توجد نتائج تطابق بحثك.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: properties.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: PropertyCard(property: properties[index]),
        );
      },
    );
  }
}
