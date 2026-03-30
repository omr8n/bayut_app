import 'package:flutter/material.dart';
import 'package:test_graduation/core/enums/property_enums.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';

class PropertyTypeSpecificDetails extends StatelessWidget {
  final PropertyEntity property;
  const PropertyTypeSpecificDetails({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> specs = [];
    if (property.buildingAge != null) {
      specs.add({'عمر البناء': '${property.buildingAge} سنوات'});
    }
    if (property.finishType != null) specs.add({'الكسوة': property.finishType!});
    
    switch (property.type) {
      case PropertyType.housesAndApartments:
      case PropertyType.villas:
        if (property.floorNumber != null) specs.add({'الطابق': '${property.floorNumber}'});
        if (property.heatingType != null) specs.add({'التدفئة': property.heatingType!});
        break;
      default:
        break;
    }

    if (specs.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text('المواصفات الفنية', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3.5,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: specs.length,
          itemBuilder: (context, index) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Text(
                  '${specs[index].keys.first}: ',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Expanded(
                  child: Text(
                    specs[index].values.first,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
