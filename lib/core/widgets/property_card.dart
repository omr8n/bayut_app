import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:test_graduation/core/enums/property_enums.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PropertyCard extends StatefulWidget {
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

  // وظائف التواصل
  Future<void> _makeCall() async {
    final Uri url = Uri.parse('tel:${widget.property.phone}');
    if (await canLaunchUrl(url)) await launchUrl(url);
  }

  Future<void> _sendWhatsApp() async {
    final Uri url = Uri.parse('https://wa.me/${widget.property.whatsapp}');
    if (await canLaunchUrl(url))
      await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  Future<void> _sendEmail() async {
    final Uri url = Uri.parse(
      'mailto:support@bayut.com?subject=استفسار عن عقار: ${widget.property.title}',
    );
    if (await canLaunchUrl(url)) await launchUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,###');
    final images = widget.property.images.isNotEmpty
        ? widget.property.images
        : ['https://via.placeholder.com/800x450?text=No+Image'];

    return GestureDetector(
      onTap: widget.onTap,
      child: Flexible(
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
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
              // 1. معرض الصور (Image Carousel)
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9, // ✅ تثبيت الـ Ratio لمنع الـ Overflow
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: images.length,
                      onPageChanged: (index) =>
                          setState(() => _currentImageIndex = index),
                      itemBuilder: (context, index) => FittedBox(
                        fit: BoxFit.cover,
                        child: FancyShimmerImage(
                          imageUrl: images[index],
                          boxFit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  // مؤشر النقاط (Dots)
                  if (images.length > 1)
                    Positioned(
                      bottom: 12,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          images.length,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentImageIndex == index
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                  // ملصق الحالة (بيع/إيجار) - يمين
                  Positioned(
                    top: 12,
                    right: 12,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: widget.property.listingType == ListingType.sale
                              ? AppColors.forSale
                              : AppColors.forRent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            widget.property.listingType.arabicName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // 🔥 ملصق "مميز" - يسار
                  if (widget.property.isFeatured)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Icon(
                                Icons.star,
                                color: Colors.white,
                                size: 14.sp,
                              ),
                            ),
                            const SizedBox(width: 4),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: const Text(
                                'مميز',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),

              // 2. المحتوى (نفس بيانات بيوت)
              Flexible(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // السعر والعملة
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          '${numberFormat.format(widget.property.price)} ${widget.property.currency}',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: SizedBox(height: 4.h),
                      ),
                      // المواصفات (غرف، حمامات، مساحة)
                      Flexible(
                        flex: 1,
                        child: Row(
                          children: [
                            if (widget.property.bedrooms != null)
                              _buildInfoItem(
                                Icons.bed_outlined,
                                '${widget.property.bedrooms}',
                              ),
                            if (widget.property.bathrooms != null)
                              _buildInfoItem(
                                Icons.bathroom_outlined,
                                '${widget.property.bathrooms}',
                              ),
                            _buildInfoItem(
                              Icons.square_foot_outlined,
                              '${widget.property.area.toInt()} م²',
                            ),
                          ],
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: const SizedBox(height: 8),
                      ),
                      // العنوان
                      Flexible(
                        flex: 1,
                        child: Text(
                          widget.property.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      // الموقع
                      Flexible(
                        flex: 1,
                        child: Row(
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Icon(
                                Icons.location_on_outlined,
                                size: 14.sp,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 4),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '${widget.property.governorate} - ${widget.property.city}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 3. أزرار التواصل (WhatsApp, Call, Email)
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade100),
                    ),
                  ),
                  child: Row(
                    children: [
                      _buildActionButton(
                        'واتساب',
                        Icons.chat_bubble_outline,
                        const Color(0xFF25D366),
                        _sendWhatsApp,
                      ),
                      _buildActionButton(
                        'اتصال',
                        Icons.phone_outlined,
                        AppColors.success,
                        _makeCall,
                      ),
                      _buildActionButton(
                        'الإيميل',
                        Icons.email_outlined,
                        Colors.blue,
                        _sendEmail,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String value) {
    return FittedBox(
      child: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Row(
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Icon(icon, size: 16, color: Colors.grey[600]),
            ),
            const SizedBox(width: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: const TextStyle(fontSize: 12, color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Flexible(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Icon(icon, size: 18, color: color),
              ),
              const SizedBox(width: 6),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
