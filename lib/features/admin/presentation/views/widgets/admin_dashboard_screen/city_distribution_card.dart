import 'package:flutter/material.dart';
import 'package:test_graduation/core/utils/colors.dart';

class CityDistributionCard extends StatelessWidget {
  final Map<String, int> cities;

  const CityDistributionCard({super.key, required this.cities});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "النشاط حسب المدن",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          ...cities.entries.map((e) {
            int total = cities.values.fold(0, (a, b) => a + b);
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(e.key),
                      Text(
                        "${e.value} عقار",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: total > 0 ? e.value / total : 0,
                    backgroundColor: Colors.grey[200],
                    color: AppColors.primary,
                    minHeight: 6,
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
