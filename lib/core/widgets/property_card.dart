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
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
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
        margin: const EdgeInsets.only(bottom: 16),
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
          children: [
            // صورة العقار مع Badge الحالة
            Stack(
              children: [
                SizedBox(
                  height: 160,
                  width: double.infinity,
                  child: property.images.isNotEmpty
                      ? Image.network(
                          property.images.first,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _errorImage(),
                        )
                      : _errorImage(),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: property.listingType == ListingType.sale
                          ? AppColors.forSale
                          : AppColors.forRent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      property.listingType.arabicName,
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),

            // المحتوى
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // السعر والعملة
                  Text(
                    '${numberFormat.format(property.price)} ${property.currency}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  
                  // العنوان
                  Text(
                    property.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  
                  const SizedBox(height: 6),

                  // الموقع (المحافظة والمدينة)
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${property.governorate} - ${property.city}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),

                  // تفاصيل سريعة
                  Row(
                    children: [
                      if (property.bedrooms != null && property.bedrooms! > 0) ...[
                        _buildDetail(Icons.bed_outlined, '${property.bedrooms}'),
                        const SizedBox(width: 12),
                      ],
                      if (property.bathrooms != null && property.bathrooms! > 0) ...[
                        _buildDetail(Icons.bathroom_outlined, '${property.bathrooms}'),
                        const SizedBox(width: 12),
                      ],
                      _buildDetail(Icons.square_foot_outlined, '${property.area.toInt()} م²'),
                      const Spacer(),
                      Text(
                        property.type.arabicName,
                        style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.bold),
                      ),
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
