import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_cubit.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import 'admin_property_card.dart';

import 'package:test_graduation/core/language/app_localizations.dart';

class AdminPropertiesList extends StatelessWidget {
  final List<PropertyEntity> properties;
  final String extraFilter; // 🔥 Filter input
  final ScrollController? scrollController;
  final bool isLoadingMore;

  const AdminPropertiesList({
    super.key,
    required this.properties,
    this.extraFilter = 'All',
    this.scrollController,
    this.isLoadingMore = false,
  });

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    if (properties.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.2),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.home_work_outlined, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  local.no_matching_properties,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: 8.h),
      itemCount: properties.length +
          (extraFilter == local.trend_leaders ? 1 : 0) +
          (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (isLoadingMore && index >= (properties.length + (extraFilter == local.trend_leaders ? 1 : 0))) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (extraFilter == local.trend_leaders && index == 0) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                  children: [
                    Icon(
                      Icons.bar_chart_rounded,
                      color: Colors.orange,
                      size: 24.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      local.trend_leaders_30_days,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black87,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.leaderboard_rounded,
                      color: Colors.orange,
                      size: 24,
                    ),
                  ],
                ),
              ),
              _buildTrendingLeadersList(),
            ],
          );
        }

        final propertyIndex = extraFilter == local.trend_leaders
            ? index - 1
            : index;
        final property = properties[propertyIndex];

        return AdminPropertyCard(
          property: property,
          adminCubit: context.read<AdminCubit>(),
          trendRank: extraFilter == local.trend_leaders
              ? (propertyIndex + 1)
              : null,
        );
      },
    );
  }

  Widget _buildTrendingLeadersList() {
    // Take top 5 properties by views
    final sortedProperties = List<PropertyEntity>.from(properties);
    sortedProperties.sort((a, b) => b.views.compareTo(a.views));
    final leaders = sortedProperties.take(5).toList();

    return SizedBox(
      height: 140.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: leaders.length,
        itemBuilder: (context, index) {
          final property = leaders[index];
          return _buildTrendingLeaderCard(context, property, index + 1);
        },
      ),
    );
  }

  Widget _buildTrendingLeaderCard(
    BuildContext context,
    PropertyEntity property,
    int rank,
  ) {
    return Container(
      width: 150.w,
      margin: EdgeInsets.only(left: 12.w, bottom: 10.h),
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: Theme.of(context).brightness == Brightness.dark
                  ? 0.2
                  : 0.04,
            ),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: CachedNetworkImage(
                  imageUrl: property.images.isNotEmpty
                      ? property.images[0]
                      : '',
                  height: 70.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                property.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black87,
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "${property.views}",
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.textSecondaryDark
                          : Colors.grey,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.visibility_rounded,
                    size: 12.sp,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.textSecondaryDark
                        : Colors.grey,
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: Text(
              "#$rank",
              style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.w900,
                fontSize: 16.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
