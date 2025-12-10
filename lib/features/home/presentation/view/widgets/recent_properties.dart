import 'package:flutter/material.dart';
import 'package:test_graduation/core/data/mock_data.dart';
import 'package:test_graduation/core/widgets/property_card.dart';
import 'package:test_graduation/features/home/presentation/view/details_view.dart';

class RecentProperties extends StatelessWidget {
  const RecentProperties({super.key});

  @override
  Widget build(BuildContext context) {
    final recent = MockData.properties.take(5).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: List.generate(recent.length, (index) {
          final property = recent[index];
          return PropertyCard(
            property: property,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PropertyDetailsScreen(property: property),
                ),
              );
            },
            onFavorite: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تمت الإضافة للمفضلة')),
              );
            },
          );
        }),
      ),
    );
  }
}

// Widget _buildRecentProperties() {
//   final recent = MockData.properties.take(5).toList();

  // return SliverPadding(
  //   padding: const EdgeInsets.symmetric(horizontal: 16),
  //   sliver: SliverList(
  //     delegate: SliverChildBuilderDelegate((context, index) {
  //       final property = recent[index];
  //       return PropertyCard(
  //         property: property,
  //         onTap: () {
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => PropertyDetailsScreen(property: property),
  //             ),
  //           );
  //         },
  //         onFavorite: () {
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             const SnackBar(content: Text('تمت الإضافة للمفضلة')),
  //           );
  //         },
  //       );
  //     }, childCount: recent.length),
  //   ),
  // );
// }
