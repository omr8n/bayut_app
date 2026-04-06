import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_graduation/core/widgets/custom_circle_button.dart';
import 'package:test_graduation/core/widgets/custom_draggable_sheet.dart';
import 'package:test_graduation/features/home/presentation/view/widgets/details_view_widgets/media_gallery.dart';
import 'package:test_graduation/core/utils/share_service.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import 'package:test_graduation/features/my_properties/presentation/manager/my_properties_cubit.dart';
import 'package:test_graduation/features/my_properties/presentation/views/widgets/dashboard_widgets/dashboard_activity_timeline.dart';
import 'package:test_graduation/features/my_properties/presentation/views/widgets/dashboard_widgets/dashboard_bottom_actions.dart';
import 'package:test_graduation/features/my_properties/presentation/views/widgets/dashboard_widgets/dashboard_stats_grid.dart';

class PropertyDashboardView extends StatelessWidget {
  const PropertyDashboardView({super.key, required this.property});

  final PropertyEntity property;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyPropertiesCubit, MyPropertiesState>(
      builder: (context, state) {
        PropertyEntity currentProperty = property;
        if (state is MyPropertiesSuccess) {
          try {
            currentProperty = state.properties.firstWhere(
              (p) => p.id == property.id,
            );
          } catch (e) {}
        }

        final mediaList = currentProperty.media.isNotEmpty
            ? currentProperty.media
            : currentProperty.images;

        return BlocListener<MyPropertiesCubit, MyPropertiesState>(
          listener: (context, state) {
            if (state is MyPropertiesFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errMessage),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                // 1. Background Media
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

                // 2. Reusable Sliding Sheet
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
                            ),
                          ),
                          SizedBox(height: 20.h),
                          DashboardStatsGrid(property: currentProperty),
                          SizedBox(height: 30.h),
                          const Text(
                            'سجل النشاطات والتاريخ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          DashboardActivityTimeline(property: currentProperty),
                          SizedBox(height: 120.h), // Space for bottom actions
                        ],
                      ),
                    ),
                  ],
                ),

                // 3. Top Controls
                Positioned(
                  top: 40.h,
                  left: 16.w,
                  right: 16.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomCircleButton(
                        icon: Icons.arrow_back_ios_new,
                        onTap: () => Navigator.pop(context),
                      ),
                      CustomCircleButton(
                        icon: Icons.share_outlined,
                        onTap: () {
                          ShareService.shareProperty(currentProperty);
                        },
                      ),
                    ],
                  ),
                ),

                // 4. Bottom Controls (Fixed at bottom)
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
