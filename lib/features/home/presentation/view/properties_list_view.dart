import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/core/routing/app_routes.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/core/widgets/property_card.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import 'package:test_graduation/features/search/presentation/veiw/widgets/empty_state.dart';

class PropertiesListScreen extends StatelessWidget {
  final String title;
  final List<PropertyEntity> properties;

  const PropertiesListScreen({
    super.key,
    required this.title,
    required this.properties,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // خلفية خفيفة لتمييز الكروت
      body: properties.isEmpty
          ? Column(
              children: [
                AppBar(title: Text(title), centerTitle: true),
                const Expanded(child: EmptyState()),
              ],
            )
          : CustomScrollView(
              physics: const BouncingScrollPhysics(), // إضافة حركة مطاطية (iOS Style)
              slivers: [
                SliverAppBar(
                  expandedHeight: 120.h,
                  floating: true, // يختفي عند السحب لأسفل ويظهر فوراً عند السحب لأعلى
                  pinned: true, // يبقى العنوان ظاهراً بشكل مصغر عند الصعود
                  stretch: true, // يتمدد عند السحب بقوة لأسفل
                  backgroundColor: AppColors.primary,
                  elevation: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      title,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    centerTitle: true,
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.primary,
                            AppColors.primary.withOpacity(0.8),
                          ],
                        ),
                      ),
                    ),
                    stretchModes: const [
                      StretchMode.zoomBackground,
                      StretchMode.blurBackground,
                    ],
                  ),
                  iconTheme: const IconThemeData(color: Colors.white),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final property = properties[index];
                        // إضافة حركة دخول تدريجية لكل كرت
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 300 + (index * 100)),
                          curve: Curves.easeOut,
                          child: PropertyCard(
                            property: property,
                            onTap: (imageIndex) {
                              context.push(
                                AppRoutes.propertyDetailsScreen,
                                extra: {
                                  'property': property,
                                  'initialIndex': imageIndex,
                                },
                              );
                            },
                          ),
                        );
                      },
                      childCount: properties.length,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
