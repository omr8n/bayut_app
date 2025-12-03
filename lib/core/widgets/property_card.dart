// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../models/property_model.dart';
// import '../utils/colors.dart';
// import '../utils/strings_ar.dart';

// // بطاقة عرض العقار
// class PropertyCard extends StatelessWidget {
//   final Property property;
//   final VoidCallback? onTap;
//   final VoidCallback? onFavorite;
//   final bool isFavorite;

//   const PropertyCard({
//     super.key,
//     required this.property,
//     this.onTap,
//     this.onFavorite,
//     this.isFavorite = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final numberFormat = NumberFormat('#,###');

//     return GestureDetector(
//       onTap: onTap,
//       child: AspectRatio(
//         aspectRatio: 0.4,
//         child: Container(
//           margin: const EdgeInsets.only(bottom: 16),
//           decoration: BoxDecoration(
//             color: AppColors.cardBackground,
//             borderRadius: BorderRadius.circular(12),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.08),
//                 blurRadius: 8,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // الصورة
//               _buildImage(),

//               // المحتوى
//               Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     // السعر
//                     Text(
//                       '${numberFormat.format(property.price)} ${AppStrings.aed}',
//                       style: const TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: AppColors.primary,
//                       ),
//                     ),
//                     const SizedBox(height: 4),

//                     // العنوان
//                     FittedBox(
//                       fit: BoxFit.scaleDown,
//                       child: Text(
//                         property.title,
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: AppColors.textPrimary,
//                         ),
//                       ),
//                     ),
//                     // const SizedBox(height: 8),

//                     // الموقع
//                     Row(
//                       children: [
//                         const Icon(
//                           Icons.location_on,
//                           size: 16,
//                           color: AppColors.textSecondary,
//                         ),
//                         const SizedBox(width: 4),
//                         Expanded(
//                           child: Text(
//                             property.location,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: const TextStyle(
//                               fontSize: 14,
//                               color: AppColors.textSecondary,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 12),

//                     // التفاصيل
//                     Row(
//                       children: [
//                         if (property.bedrooms > 0) ...[
//                           _buildDetail(
//                             Icons.bed_outlined,
//                             '${property.bedrooms}',
//                           ),
//                           const SizedBox(width: 16),
//                         ],
//                         if (property.bathrooms > 0) ...[
//                           _buildDetail(
//                             Icons.bathroom_outlined,
//                             '${property.bathrooms}',
//                           ),
//                           const SizedBox(width: 16),
//                         ],
//                         _buildDetail(
//                           Icons.square_foot,
//                           '${property.area.toInt()} ${AppStrings.sqm}',
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildImage() {
//     return Stack(
//       children: [
//         // الصورة الرئيسية
//         ClipRRect(
//           borderRadius: const BorderRadius.only(
//             topLeft: Radius.circular(12),
//             topRight: Radius.circular(12),
//           ),
//           child: AspectRatio(
//             aspectRatio: 1.6,
//             child: Image.network(
//               property.images.first,
//               height: 200,
//               width: double.infinity,
//               fit: BoxFit.cover,
//               errorBuilder: (context, error, stackTrace) {
//                 return Container(
//                   height: 200,
//                   color: AppColors.background,
//                   child: const Icon(
//                     Icons.image_not_supported,
//                     size: 50,
//                     color: AppColors.textLight,
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),

//         // Badge للبيع/الإيجار
//         Positioned(
//           top: 12,
//           right: 12,
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(
//               color: property.listingType == ListingType.sale
//                   ? AppColors.forSale
//                   : AppColors.forRent,
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Text(
//               property.listingType.arabicName,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 12,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ),

//         // أيقونة المفضلة
//         Positioned(
//           top: 12,
//           left: 12,
//           child: GestureDetector(
//             onTap: onFavorite,
//             child: Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 shape: BoxShape.circle,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 4,
//                   ),
//                 ],
//               ),
//               child: Icon(
//                 isFavorite ? Icons.favorite : Icons.favorite_border,
//                 color: isFavorite ? Colors.red : AppColors.textSecondary,
//                 size: 20,
//               ),
//             ),
//           ),
//         ),

//         // Badge مميز
//         if (property.isFeatured)
//           Positioned(
//             bottom: 12,
//             left: 12,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//               decoration: BoxDecoration(
//                 color: AppColors.featured,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: const Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(Icons.star, size: 14, color: Colors.white),
//                   SizedBox(width: 4),
//                   Text(
//                     'مميز',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 11,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//       ],
//     );
//   }

//   Widget _buildDetail(IconData icon, String text) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(icon, size: 18, color: AppColors.textSecondary),
//         const SizedBox(width: 4),
//         Text(
//           text,
//           style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../models/property_model.dart';
import '../utils/colors.dart';
import '../utils/strings_ar.dart';
import 'package:intl/intl.dart';

class PropertyCard extends StatelessWidget {
  final Property property;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;
  final bool isFavorite;

  const PropertyCard({
    super.key,
    required this.property,
    this.onTap,
    this.onFavorite,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,###');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -------------------- صورة العقار --------------------
            SizedBox(
              height: 180,
              width: double.infinity,
              child: property.images.isNotEmpty
                  ? Image.network(
                      property.images.first,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _errorImage(),
                    )
                  : _errorImage(),
            ),

            // -------------------- المحتوى --------------------
            Padding(
              padding: const EdgeInsets.all(12),
              child: SizedBox(
                height: 140, // ارتفاع ذكي يمنع overflow ويحافظ على الشكل
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // السعر
                    Text(
                      '${numberFormat.format(property.price)} ${AppStrings.aed}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // عنوان العقار
                    Text(
                      property.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // الموقع
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 18,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            property.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                              height: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // -------------------- تفاصيل العقار --------------------
                    Row(
                      children: [
                        if (property.bedrooms > 0)
                          _buildDetail(Icons.bed, '${property.bedrooms}'),
                        if (property.bathrooms > 0) ...[
                          const SizedBox(width: 16),
                          _buildDetail(
                            Icons.bathtub_outlined,
                            '${property.bathrooms}',
                          ),
                        ],
                        const SizedBox(width: 16),
                        _buildDetail(
                          Icons.square_foot,
                          '${property.area.toInt()} ${AppStrings.sqm}',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -------------------- عنصر تفاصيل (غرف – حمامات – مساحة) --------------------

  Widget _buildDetail(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  // -------------------- صورة خطأ --------------------

  Widget _errorImage() {
    return Container(
      color: Colors.grey.shade200,
      child: const Center(
        child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
      ),
    );
  }
}
