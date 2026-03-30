import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/core/routing/app_routes.dart';
import 'package:test_graduation/core/widgets/property_card.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import 'package:test_graduation/features/search/presentation/veiw/widgets/empty_state.dart';

class PropertiesListScreen extends StatelessWidget {
  final String title;
  final List<PropertyEntity> properties;

  const PropertiesListScreen({
    super.key,
    required this.title,
    required this.properties,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title), 
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: properties.isEmpty
          ? const EmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: properties.length,
              itemBuilder: (context, index) {
                final property = properties[index];
                return PropertyCard(
                  property: property,
                  onTap: () {
                    // 🔥 استخدام push لضمان إمكانية العودة لهذه القائمة
                    GoRouter.of(context).push(AppRoutes.propertyDetailsScreen, extra: property);
                  },
                );
              },
            ),
    );
  }
}
