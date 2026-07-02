import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:intl/intl.dart';
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
import 'package:test_graduation/features/my_properties/presentation/views/widgets/dashboard_widgets/dashboard_status_banner.dart';
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
                          // 🔥 عرض بانرات الحالة (تريند / تميز) بناءً على التصميم الجديد
                          DashboardStatusBanner(
                            property: currentProperty,
                            trendRank: currentProperty.views > 0 ? 1 : null, // Mocking rank 1 if has views for demo
                          ),
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
                  top: 16.h,
                  left: 16.w,
                  right: 16.w,
                  child: SafeArea(
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
}
