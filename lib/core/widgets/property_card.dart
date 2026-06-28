import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/routing/app_routes.dart';
import 'package:test_graduation/core/enums/property_enums.dart';
import 'package:test_graduation/core/widgets/communication.dart';
import 'package:test_graduation/features/home/presentation/view/widgets/details_view_widgets/media_gallery.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import 'package:test_graduation/core/utils/viewed_properties_manager.dart';
import 'package:test_graduation/core/widgets/favorite_button.dart';
import '../utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PropertyCard extends StatefulWidget {
  const PropertyCard({
    super.key,
    required this.property,
    this.onTap,
  });

  final Function(int index)? onTap;
  final PropertyEntity property;

  @override
  State<PropertyCard> createState() => _PropertyCardState();
}

class _PropertyCardState extends State<PropertyCard> {
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final numberFormat = NumberFormat('#,###');
    final List<String> allMedia = widget.property.media.isNotEmpty
        ? widget.property.media
        : (widget.property.images.isNotEmpty
              ? widget.property.images
              : ['https://via.placeholder.com/800x450?text=No+Media']);

    final int displayCount = allMedia.length > 3 ? 3 : allMedia.length;

    return GestureDetector(
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!(0); // للحفاظ على التوافق القديم إذا كان هناك منطق خاص
        } else {
          context.push(
            AppRoutes.propertyDetailsScreen,
            extra: {
              'property': widget.property,
              'initialIndex': 0,
            },
          );
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. قسم الصور
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: displayCount,
                    onPageChanged: (index) =>
                        setState(() => _currentImageIndex = index),
                    itemBuilder: (context, index) {
                      final url = allMedia[index];
                      final isVideo = url.toLowerCase().endsWith('.mp4');
                      final isLastVisible = index == 2 && allMedia.length > 3;

                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          // نستخدم IgnorePointer هنا لضمان أن حدث النقر يمر للـ GestureDetector الأب
                          // لكي يتم الانتقال لصفحة التفاصيل بغض النظر عن محتوى الصورة/الفيديو
                          IgnorePointer(
                            child: isVideo
                                ? VideoThumbnailWidget(videoUrl: url)
                                : FancyShimmerImage(
                                    imageUrl: url,
                                    boxFit: BoxFit.cover,
                                  ),
                          ),
                          if (isVideo)
                            IgnorePointer(
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.all(8.w),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.4),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.play_arrow_rounded,
                                    color: Colors.white,
                                    size: 30.sp,
                                  ),
                                ),
                              ),
                            ),
                          if (isLastVisible)
                            IgnorePointer(
                              child: Container(
                                color: Colors.black.withOpacity(0.5),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_photo_alternate_outlined,
                                        color: Colors.white,
                                        size: 28.sp,
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        '${localizations.translate(LangKeys.viewAll)} (+${allMedia.length - 3})',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),

                  // النقاط (Dots Indicator)
                  if (displayCount > 1)
                    Positioned(
                      bottom: 12.h,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          displayCount,
                          (index) => Container(
                            margin: EdgeInsets.symmetric(horizontal: 3.w),
                            width: _currentImageIndex == index ? 12.w : 6.w,
                            height: 6.w,
                            decoration: BoxDecoration(
                              color: _currentImageIndex == index
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                        ),
                      ),
                    ),

                  // شارة "شوهد" (Viewed Badge)
                  ValueListenableBuilder(
                    valueListenable: ViewedPropertiesManager().changeNotifier,
                    builder: (context, _, __) {
                      if (!ViewedPropertiesManager().isViewed(widget.property.id)) {
                        return const SizedBox.shrink();
                      }
                      return Positioned(
                        bottom: 12.h,
                        left: 12.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                localizations.isEnLocale ? 'Viewed' : 'شوهد',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Icon(
                                Icons.check_circle_rounded,
                                color: Colors.grey[600],
                                size: 14.sp,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  // شارة الحالة (للبيع / للايجار + تريند)
                  Positioned(
                    top: 12.h,
                    right: 12.w,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.property.views >= 5) // شارة التريند تظهر دائماً إذا حقق الشرط
                          Container(
                            margin: EdgeInsets.only(left: 8.w),
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 5.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(8.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.trending_up_rounded,
                                  color: Colors.white,
                                  size: 14.sp,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  localizations.isEnLocale ? 'Trend' : 'تريند',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 5.h,
                          ),
                          decoration: BoxDecoration(
                            color: widget.property.listingType == ListingType.sale
                                ? AppColors.forSale
                                : AppColors.forRent,
                            borderRadius: BorderRadius.circular(8.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            widget.property.listingType.localizedName(context),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // شارة "مميز" (تظهر بجانب التريند أو لحالها إذا كان العقار مدفوع)
                  if (widget.property.premiumStatus == PremiumStatus.active)
                    Positioned(
                      top: 12.h,
                      left: 12.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 5.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: Colors.white,
                              size: 14.sp,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              localizations.isEnLocale ? 'Featured' : 'مميز',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // 🔥 شارة "قيد التقسيط" (Under Installment Badge)
                  if (widget.property.status == PropertyStatus.underInstallment)
                    Positioned(
                      top: 45.h, // وضعه تحت شارة "مميز" إذا وُجدت، أو في مكان بارز
                      left: 12.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 5.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade800,
                          borderRadius: BorderRadius.circular(8.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.history_toggle_off_rounded,
                              color: Colors.white,
                              size: 14.sp,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              localizations.translate(LangKeys.underInstallment),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // 2. قسم المحتوى
            Flexible(
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerRight,
                              child: Text(
                                '${numberFormat.format(widget.property.price)} ${localizations.translate(widget.property.currency.trim().toLowerCase())}',
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                          FavoriteButton(
                            propertyId: widget.property.id,
                            size: 24,
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Wrap(
                        spacing: 15.w,
                        runSpacing: 5.h,
                        children: [
                          if (widget.property.bedrooms != null)
                            _buildInfoItem(
                              Icons.bed_outlined,
                              '${widget.property.bedrooms} ${localizations.translate(LangKeys.rooms)}',
                            ),
                          _buildInfoItem(
                            Icons.square_foot_outlined,
                            '${widget.property.area.toInt()} ${localizations.isEnLocale ? 'm²' : 'م²'}',
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      SizedBox(
                        width: double.infinity,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: localizations.isEnLocale ? Alignment.centerLeft : Alignment.centerRight,
                          child: Text(
                            widget.property.title,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      SizedBox(
                        width: double.infinity,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: localizations.isEnLocale ? Alignment.centerLeft : Alignment.centerRight,
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on_rounded,
                                size: 14.sp,
                                color: AppColors.primary,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                '${localizations.translate(widget.property.governorate)}، ${widget.property.city}',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CommunicationButtons(property: widget.property),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18.sp, color: Colors.grey[700]),
        SizedBox(width: 6.w),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
