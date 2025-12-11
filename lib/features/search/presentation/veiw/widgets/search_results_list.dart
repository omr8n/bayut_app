import 'package:flutter/material.dart';
import 'package:test_graduation/core/widgets/property_card.dart';
import 'package:test_graduation/features/home/presentation/view/details_view.dart';
import 'package:test_graduation/core/models/property_model.dart';

class SearchResultsList extends StatelessWidget {
  const SearchResultsList({super.key, required this.properties});

  final List<Property> properties;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: properties.length,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        final property = properties[index];

        return PropertyCard(
          property: property,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PropertyDetailsScreen(property: property),
              ),
            );
          },
          onFavorite: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تمت الإضافة للمفضلة')),
            );
          },
        );
      },
    );
  }
}
