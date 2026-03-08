import 'package:flutter/material.dart';

import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';

class MyPropertyItem extends StatelessWidget {
  const MyPropertyItem({super.key, required this.property});

  final PropertyEntity property;

  @override
  Widget build(BuildContext context) {
    // منطق ذكي للصور
    final String displayImage = property.media.isNotEmpty
        ? property.media[0]
        : (property.images.isNotEmpty ? property.images[0] : '');

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          // الصورة المصغرة
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(
              right: Radius.circular(12),
            ),
            child: displayImage.isNotEmpty
                ? Image.network(
                    displayImage,
                    width: 120,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 120,
                      height: 100,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.broken_image),
                    ),
                  )
                : Container(
                    width: 120,
                    height: 100,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image),
                  ),
          ),
          // التفاصيل
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${property.price} ${property.currency}',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        property.city,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // زر القائمة (More)
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
    );
  }
}
