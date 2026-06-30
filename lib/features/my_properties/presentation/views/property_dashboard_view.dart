import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:intl/intl.dart';
import 'package:test_graduation/core/enums/property_enums.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/services/connectivity_service.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/core/utils/service_locator.dart';
import 'package:test_graduation/core/widgets/custom_circle_button.dart';
import 'package:test_graduation/core/widgets/custom_draggable_sheet.dart';
import 'package:test_graduation/features/home/presentation/view/widgets/details_view_widgets/media_gallery.dart';
import 'package:test_graduation/core/utils/share_service.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import 'package:test_graduation/features/my_properties/presentation/manager/my_properties_cubit.dart';
import 'package:test_graduation/features/my_properties/presentation/views/widgets/dashboard_widgets/dashboard_activity_timeline.dart';
import 'package:test_graduation/features/my_properties/presentation/views/widgets/dashboard_widgets/dashboard_bottom_actions.dart';
import 'package:test_graduation/features/my_properties/presentation/views/widgets/dashboard_widgets/dashboard_stats_grid.dart';
import 'package:test_graduation/features/profile/presentation/manager/profile_cubit/profile_cubit.dart';

class PropertyDashboardView extends StatefulWidget {
  const PropertyDashboardView({super.key, required this.property});

  final PropertyEntity property;

  @override
  State<PropertyDashboardView> createState() => _PropertyDashboardViewState();
}

class _PropertyDashboardViewState extends State<PropertyDashboardView> {
  StreamSubscription? _connectivitySubscription;
  Timer? _countdownTimer;
  Duration _remainingTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    _startCountdown();
    _connectivitySubscription = getIt<ConnectivityService>().connectivityStream
        .listen((results) {
          final isConnected = !results.contains(ConnectivityResult.none);
          if (isConnected &&
              context.read<MyPropertiesCubit>().state is MyPropertiesFailure) {
            _refreshData();
          }
        });
  }

  void _startCountdown() {
    if (widget.property.premiumExpiryDate != null) {
      _remainingTime = widget.property.premiumExpiryDate!.difference(
        DateTime.now(),
      );
      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mounted) {
          setState(() {
            _remainingTime = widget.property.premiumExpiryDate!.difference(
              DateTime.now(),
            );
          });
          if (_remainingTime.isNegative) {
            timer.cancel();
          }
        }
      });
    }
  }

  void _refreshData() {
    final user = context.read<ProfileCubit>().user;
    if (user != null) {
      context.read<MyPropertiesCubit>().fetchMyProperties(user.uId);
    }
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return BlocConsumer<MyPropertiesCubit, MyPropertiesState>(
      listener: (context, state) {
        if (state is MyPropertiesFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(locale.translate(state.errMessage)),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        PropertyEntity currentProperty = widget.property;
        if (state is MyPropertiesSuccess) {
          try {
            currentProperty = state.properties.firstWhere(
              (p) => p.id == widget.property.id,
            );
          } catch (e) {}
        }

        final mediaList = currentProperty.media.isNotEmpty
            ? currentProperty.media
            : currentProperty.images;

        return Directionality(
          textDirection: locale.isEnLocale
              ? ui.TextDirection.ltr
              : ui.TextDirection.rtl,
          child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: Stack(
              children: [
                Positioned.fill(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: MediaGallery(
                      mediaUrls: mediaList,
                      propertyImages: currentProperty.images,
                      property: currentProperty,
                    ),
                  ),
                ),
                CustomDraggableSheet(
                  initialChildSize: 0.4,
                  minChildSize: 0.4,
                  maxChildSize: 0.9,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentProperty.title,
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          // 🔥 عرض بانر التريند إذا كان العقار ضمن التريند
                          if (currentProperty.views > 5) _buildTrendBanner(),
                          if (currentProperty.views > 5 &&
                              currentProperty.premiumStatus ==
                                  PremiumStatus.active)
                            SizedBox(height: 12.h),
                          // 🔥 عرض بانر التميز إذا كان العقار مميزاً
                          if (currentProperty.premiumStatus ==
                              PremiumStatus.active)
                            _buildPremiumStatusBanner(currentProperty),

                          SizedBox(height: 16.h),
                          DashboardStatsGrid(property: currentProperty),
                          SizedBox(height: 30.h),
                          Text(
                            locale.translate(LangKeys.activityHistory),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          DashboardActivityTimeline(property: currentProperty),
                          SizedBox(height: 120.h),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 40.h,
                  left: 16.w,
                  right: 16.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomCircleButton(
                        icon: locale.isEnLocale
                            ? Icons.arrow_back_ios_new
                            : Icons.arrow_forward_ios,
                        onTap: () => context.pop(),
                      ),
                      CustomCircleButton(
                        icon: Icons.share_outlined,
                        onTap: () {
                          ShareService.shareProperty(context, currentProperty);
                        },
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: DashboardBottomActions(property: currentProperty),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTrendBanner() {
    final locale = AppLocalizations.of(context)!;
    final trendExpiry = DateTime.now().add(const Duration(days: 7));
    final expiryString = DateFormat('yyyy/MM/dd').format(trendExpiry);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.orange.withOpacity(0.05)
            : const Color(0xFFFFF9F0),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isDark
              ? Colors.orange.withOpacity(0.2)
              : Colors.orange.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.local_fire_department_rounded,
                color: Colors.orange,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                locale.translate(LangKeys.congratulationsTrend),
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? Colors.orange.shade300
                      : Colors.orange.shade800,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.trending_up_rounded,
                color: Colors.orange,
                size: 20,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      locale.translate(LangKeys.mostViewed),
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : Colors.grey,
                      ),
                    ),
                    Text(
                      locale
                          .translate(LangKeys.currentRank)
                          .replaceFirst('{rank}', '1'),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? Colors.orange.shade300
                            : Colors.orange.shade800,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      locale.translate(LangKeys.trendExpiryUntil),
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : Colors.grey,
                      ),
                    ),
                    Text(
                      expiryString,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white70 : Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumStatusBanner(PropertyEntity property) {
    if (_remainingTime.isNegative) return const SizedBox.shrink();
    final locale = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final days = _remainingTime.inDays;
    final hours = _remainingTime.inHours % 24;

    // Calculate total duration (assuming 30 days for month or based on creation)
    // For demo purposes, we use 30 days as total.
    const totalDurationSeconds = 30 * 24 * 60 * 60;
    final progress = (1 - (_remainingTime.inSeconds / totalDurationSeconds))
        .clamp(0.0, 1.0);

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.primary.withOpacity(0.1)
            : const Color(0xFFF3F7FA),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isDark
              ? AppColors.primary.withOpacity(0.2)
              : Colors.blue.withOpacity(0.1),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1E4C9A).withOpacity(0.1),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.stars_rounded,
                  color: Color(0xFF1E4C9A),
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                locale.translate(LangKeys.premiumStatusActiveLabel),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1E4C9A),
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.emoji_events_rounded,
                color: Color(0xFF1E4C9A),
                size: 20,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.primary.withOpacity(0.2)
                      : const Color(0xFFD3E3F0),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  locale
                      .translate(LangKeys.remainingTime)
                      .replaceFirst('{days}', days.toString())
                      .replaceFirst('{hours}', hours.toString()),
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1E4C9A),
                  ),
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    locale.translate(LangKeys.expiryDateLabel),
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: isDark ? AppColors.textSecondaryDark : Colors.grey,
                    ),
                  ),
                  Text(
                    DateFormat(
                      'd MMMM yyyy - hh:mm a',
                      locale.isEnLocale ? 'en' : 'ar',
                    ).format(property.premiumExpiryDate!),
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white70 : Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: isDark ? Colors.white10 : Colors.white,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF1E4C9A),
              ),
              minHeight: 8.h,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                locale.translate(LangKeys.planProMonth),
                style: TextStyle(
                  fontSize: 10,
                  color: isDark ? AppColors.textSecondaryDark : Colors.grey,
                ),
              ),
              Icon(
                Icons.info_outline_rounded,
                size: 14.sp,
                color: isDark ? AppColors.textSecondaryDark : Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
