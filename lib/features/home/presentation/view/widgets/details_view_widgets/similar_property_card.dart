import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:test_graduation/core/utils/viewed_properties_manager.dart';
import 'package:test_graduation/core/widgets/favorite_button.dart';
import 'package:test_graduation/features/home/presentation/view/widgets/details_view_widgets/media_gallery.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';

class SimilarPropertyCard extends StatelessWidget {
  final PropertyEntity property;
  final VoidCallback onTap;

  const SimilarPropertyCard({
    super.key,
    required this.property,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat('#,###');
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180.w, // عرض أصغر ومناسب
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة العقار مع Badge "موثوق"
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(12.r),
                  ),
                  child: Builder(
                    builder: (context) {
                      final List<String> allMedia = property.media.isNotEmpty
                          ? property.media
                          : property.images;
                      final String firstMedia = allMedia.isNotEmpty
                          ? allMedia[0]
                          : '';
                      final bool isVideo = firstMedia.toLowerCase().endsWith(
                        '.mp4',
                      );

                      return SizedBox(
                        height: 120.h,
                        width: double.infinity,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            isVideo
                                ? VideoThumbnailWidget(videoUrl: firstMedia)
                                : FancyShimmerImage(
                                    imageUrl: firstMedia,
                                    boxFit: BoxFit.cover,
                                  ),
                            if (isVideo)
                              Center(
                                child: Container(
                                  padding: EdgeInsets.all(4.w),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.4),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.play_arrow_rounded,
                                    color: Colors.white,
                                    size: 24.sp,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // شارة "شوهد" (Viewed Badge)
                ValueListenableBuilder(
                  valueListenable: ViewedPropertiesManager().changeNotifier,
                  builder: (context, _, __) {
                    if (!ViewedPropertiesManager().isViewed(property.id)) {
                      return const SizedBox.shrink();
                    }
                    return Positioned(
                      bottom: 8.h,
                      right: 8.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: (isDark ? Colors.black : Colors.white).withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'شوهد',
                              style: TextStyle(
                                color: isDark ? Colors.white70 : Colors.grey[700],
                                fontSize: 9.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Icon(
                              Icons.check_circle_rounded,
                              color: isDark ? Colors.white60 : Colors.grey[600],
                              size: 12.sp,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                // زر القلب (المفضلة)
                Positioned(
                  top: 8.h,
                  left: 8.w,
                  child: FavoriteButton(
                    propertyId: property.id,
                    size: 16,
                    backgroundColor: (isDark ? Colors.black : Colors.white).withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),

            // بيانات العقار
            Padding(
              padding: EdgeInsets.all(10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // السعر
                  Text(
                    '${currencyFormat.format(property.price)} ${property.currency}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.accent : AppColors.primary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),

                  // معلومات الغرف والمساحة
                  Row(
                    children: [
                      Icon(
                        Icons.king_bed_outlined,
                        size: 14.sp,
                        color: isDark ? AppColors.textSecondaryDark : Colors.grey,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${property.bedrooms ?? 0}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Icon(
                        Icons.square_foot_outlined,
                        size: 14.sp,
                        color: isDark ? AppColors.textSecondaryDark : Colors.grey,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${property.area} م²',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),

                  // العنوان/الموقع
                  Text(
                    '${property.city}، ${property.governorate}',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: isDark ? AppColors.textSecondaryDark : Colors.grey.shade600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
