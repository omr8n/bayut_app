import 'package:flutter/material.dart';
import 'package:test_graduation/core/data/mock_data.dart';
import 'package:test_graduation/core/models/property_model.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/core/widgets/property_card.dart';
import 'package:test_graduation/features/home/presentation/view/details_view.dart';

class SellerPropertiesView extends StatelessWidget {
  final Property sellerInfo;

  const SellerPropertiesView({super.key, required this.sellerInfo});

  @override
  Widget build(BuildContext context) {
    // جلب عقارات هذا البائع فقط
    final sellerProperties = MockData.properties
        .where((p) => p.sellerName == sellerInfo.sellerName)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'عقارات ${sellerInfo.sellerName}',
          style: const TextStyle(
            color: Colors.black, 
            fontSize: 18, 
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildSellerHeader(),
          _buildStatsRow(sellerProperties.length),
          const SizedBox(height: 10),
          Expanded(
            child: sellerProperties.isEmpty 
              ? const Center(child: Text('لا توجد عقارات حالياً لهذا البائع'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: sellerProperties.length,
                  itemBuilder: (context, index) {
                    return PropertyCard(
                      property: sellerProperties[index],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PropertyDetailsScreen(
                              property: sellerProperties[index],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSellerHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                sellerInfo.sellerName,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                sellerInfo.sellerJoinDate,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(width: 15),
          CircleAvatar(
            radius: 40,
            backgroundColor: const Color(0xFFE3F2FD),
            child: Text(
              sellerInfo.sellerName[0],
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(int total) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('متاح', total, Colors.orange, Icons.shopping_bag_outlined),
          _buildStatItem('المحجوزة', 0, Colors.green, Icons.check_circle_outline),
          _buildStatItem('إجمالي العقارات', total, Colors.blue, Icons.inventory_2_outlined),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int count, Color color, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          '$count',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}
