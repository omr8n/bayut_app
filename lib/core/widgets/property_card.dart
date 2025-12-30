import 'package:flutter/material.dart';
import '../models/property_model.dart';
import '../utils/colors.dart';
import 'package:intl/intl.dart';

class PropertyCard extends StatelessWidget {
  const PropertyCard({
    super.key,
    required this.property,
    this.onTap,
    this.onFavorite,
    this.isFavorite = false,
  });

  final bool isFavorite;
  final VoidCallback? onFavorite;
  final VoidCallback? onTap;
  final Property property;

  Widget _buildDetail(IconData icon, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _errorImage() {
    return Container(
      color: Colors.grey.shade200,
      child: const Center(
        child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,###');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // صورة العقار
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: property.images.isNotEmpty
                      ? Image.network(
                          property.images.first,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _errorImage(),
                        )
                      : _errorImage(),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: property.listingType == ListingType.sale
                          ? AppColors.forSale
                          : AppColors.forRent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      property.listingType.arabicName,
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                if (property.isFeatured)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFD700),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.stars, color: Colors.white, size: 16),
                    ),
                  ),
              ],
            ),

            // المحتوى
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${numberFormat.format(property.price)} ${property.currency}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    property.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 12, color: AppColors.textSecondary),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          '${property.governorate} - ${property.city}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Divider(height: 1),
                  const SizedBox(height: 8),
                  // تفاصيل سريعة - استخدام Wrap بدلاً من Row لمنع الـ Overflow
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      if (property.bedrooms != null && property.bedrooms! > 0)
                        _buildDetail(Icons.bed_outlined, '${property.bedrooms}'),
                      if (property.bathrooms != null && property.bathrooms! > 0)
                        _buildDetail(Icons.bathroom_outlined, '${property.bathrooms}'),
                      _buildDetail(Icons.square_foot_outlined, '${property.area.toInt()} م²'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
