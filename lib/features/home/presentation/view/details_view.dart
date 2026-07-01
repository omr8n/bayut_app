import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';

import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/core/widgets/communication.dart';
import 'package:test_graduation/core/widgets/custom_circle_button.dart';
import 'package:test_graduation/core/widgets/custom_draggable_sheet.dart';
import 'package:test_graduation/core/widgets/favorite_button.dart';
import 'package:test_graduation/features/home/presentation/view/widgets/details_view_widgets/media_gallery.dart';

import 'package:test_graduation/features/home/presentation/view/widgets/details_view_widgets/property_details_facilities.dart';
import 'package:test_graduation/features/home/presentation/view/widgets/details_view_widgets/property_details_header.dart';
import 'package:test_graduation/features/home/presentation/view/widgets/details_view_widgets/property_details_installment.dart';
import 'package:test_graduation/features/home/presentation/view/widgets/details_view_widgets/property_details_location.dart';
import 'package:test_graduation/features/home/presentation/view/widgets/details_view_widgets/property_details_main_info.dart';
import 'package:test_graduation/features/home/presentation/view/widgets/details_view_widgets/property_details_seller.dart';
import 'package:test_graduation/features/home/presentation/view/widgets/details_view_widgets/property_type_specific_details.dart';
import 'package:test_graduation/features/home/presentation/view/widgets/details_view_widgets/similar_properties_section.dart';

import 'package:test_graduation/core/utils/viewed_properties_manager.dart';
import 'package:test_graduation/core/repos/property_repo/property_repo.dart';
import 'package:test_graduation/core/utils/service_locator.dart';
import 'package:test_graduation/core/utils/share_service.dart';
import 'package:test_graduation/core/services/firebase_auth_service.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PropertyDetailsScreen extends StatefulWidget {
  final PropertyEntity property;
  final int initialIndex; // 🔥 استقبال الفهرس الابتدائي
  const PropertyDetailsScreen({
    super.key,
    required this.property,
    this.initialIndex = 0,
  });

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  final ScrollController _backgroundScrollController = ScrollController();

  bool get isOwner {
    final currentUser = getIt<FirebaseAuthService>().currentUser;
    return currentUser != null && currentUser.uid == widget.property.sellerId;
  }

  @override
  void initState() {
    super.initState();
    // 1. تسجيل المشاهدة محلياً (لإظهار كلمة "شوهد")
    ViewedPropertiesManager().markAsViewed(widget.property.id);

    // 2. تحديث عدد المشاهدات في الـ Database للأدمن (Clean Way via Repo)
    getIt<PropertyRepo>().updatePropertyStatus(widget.property.id, {
      'views': widget.property.views + 1,
    });

    // 🔥 القفز للصورة المطلوبة بعد بناء الواجهة
    if (widget.initialIndex > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _jumpToImage();
      });
    }
  }

  void _jumpToImage() {
    final mediaList = widget.property.media.isNotEmpty
        ? widget.property.media
        : widget.property.images;

    // البحث عن الفهرس الحقيقي داخل القائمة الكاملة (التي قد تحتوي على فيديوهات)
    int actualIndex = 0;
    int imageCounter = 0;
    for (int i = 0; i < mediaList.length; i++) {
      if (!mediaList[i].toLowerCase().endsWith('.mp4')) {
        if (imageCounter == widget.initialIndex) {
          actualIndex = i;
          break;
        }
        imageCounter++;
      } else if (widget.initialIndex == 0) {
        // إذا كان المستخدم ضغط على الكارد وكان الفيديو هو أول شيء، نبقى في البداية
        actualIndex = i;
        break;
      }
    }

    final double targetOffset = actualIndex * 382.h;
    _backgroundScrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _backgroundScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final numberFormat = NumberFormat('#,###');
    final mediaList = widget.property.media.isNotEmpty
        ? widget.property.media
        : widget.property.images;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // 1. الخلفية الثابتة مع التحكم في السكرول
          Positioned.fill(
            child: SingleChildScrollView(
              controller: _backgroundScrollController, // 🔥 ربط السكرول
              physics: const BouncingScrollPhysics(),
              child: MediaGallery(
                mediaUrls: mediaList,
                propertyImages: widget.property.images,
                property: widget.property,
              ),
            ),
          ),

          // 2. الطبقة القابلة للسحب
          CustomDraggableSheet(
            initialChildSize: 0.35,
            minChildSize: 0.35,
            maxChildSize: 0.9,
            padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 60.h),
            children: [
              PropertyDetailsHeader(
                format: numberFormat,
                property: widget.property,
              ),
              SizedBox(height: 15.h),
              Text(
                widget.property.title,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black87,
                ),
              ),
              SizedBox(height: 10.h),
              PropertyDetailsLocation(property: widget.property),
              SizedBox(height: 24.h),
              PropertyDetailsMainInfo(property: widget.property),
              PropertyDetailsInstallment(
                property: widget.property,
                format: numberFormat,
              ),
              SizedBox(height: 24.h),
              _buildSectionTitle(
                context,
                localizations.translate(LangKeys.description),
              ),
              Text(
                widget.property.description,
                style: TextStyle(
                  fontSize: 15.sp,
                  height: 1.6,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondary,
                ),
              ),
              if (widget.property.facilities.isNotEmpty) ...[
                SizedBox(height: 24.h),
                _buildSectionTitle(
                  context,
                  localizations.translate(LangKeys.facilitiesAndServices),
                ),
                PropertyDetailsFacilities(
                  facilities: widget.property.facilities,
                ),
              ],
              PropertyTypeSpecificDetails(property: widget.property),
              SizedBox(height: 24.h),
              PropertyDetailsSeller(property: widget.property),
              SizedBox(height: 10.h),
              SimilarPropertiesSection(currentProperty: widget.property),
            ],
          ),

          // الأزرار العائمة العليا
          Positioned(
            top: 16.h,
            left: 16.w,
            right: 16.w,
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomCircleButton(
                    icon: localizations.isEnLocale
                        ? Icons.arrow_back_ios_new
                        : Icons.arrow_forward_ios,
                    onTap: () => Navigator.pop(context),
                  ),
                  Row(
                    children: [
                      CustomCircleButton(
                        icon: Icons.share_outlined,
                        onTap: () {
                          ShareService.shareProperty(context, widget.property);
                        },
                      ),
                      SizedBox(width: 12.w),
                      FavoriteButton(
                        propertyId: widget.property.id,
                        size: 22,
                        backgroundColor: Colors.white.withValues(alpha: 0.9),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // أزرار التواصل الثابتة دوماً بأسلوب Hero للاستمرارية البصرية
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Hero(
              tag: 'contact_buttons_${widget.property.id}', // 🔥 التاج السحري
              child: Material(
                color: Theme.of(context).cardColor,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: CommunicationButtons(property: widget.property),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black87,
        ),
      ),
    );
  }
}
