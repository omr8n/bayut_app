import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/routing/app_routes.dart';

import 'package:test_graduation/features/admin/presentation/manager/admin_cubit.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_state.dart';
import 'package:test_graduation/features/admin/presentation/views/widgets/admin_dashboard_screen/admin_dashboard_shimmer.dart';
import 'package:test_graduation/features/admin/presentation/views/widgets/admin_dashboard_screen/admin_tool_square.dart';
import 'package:test_graduation/features/admin/presentation/views/widgets/admin_dashboard_screen/city_distribution_card.dart';
import 'package:test_graduation/features/admin/presentation/views/widgets/admin_dashboard_screen/date_selector.dart';
import 'package:test_graduation/features/admin/presentation/views/widgets/admin_dashboard_screen/donut_chart_card.dart';
import 'package:test_graduation/features/admin/presentation/views/widgets/admin_dashboard_screen/main_comparison_chart.dart';
import 'package:test_graduation/features/admin/presentation/views/widgets/admin_dashboard_screen/modern_stat_grid.dart';
import 'package:test_graduation/features/admin/presentation/views/widgets/admin_dashboard_screen/recent_activity_timeline.dart';
import 'package:test_graduation/features/admin/presentation/views/widgets/admin_dashboard_screen/summary_header.dart';
import 'package:test_graduation/features/admin/presentation/views/widgets/admin_dashboard_screen/time_filter_selector.dart';
import 'package:test_graduation/features/admin/presentation/views/widgets/custom_drawer.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AdminCubit>().getStats();
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          local.admin_platform_center,
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF1A1C1E),
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.settings_outlined,
              color: isDark ? Colors.white : const Color(0xFF1A1C1E),
              size: 22.sp,
            ),
            onPressed: () => context.pushNamed(AppRoutes.adminSettings),
          ),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: Icon(
                Icons.menu_rounded,
                color: isDark ? Colors.white : const Color(0xFF1A1C1E),
                size: 24.sp,
              ),
            ),
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: BlocBuilder<AdminCubit, AdminState>(
        builder: (context, state) {
          if (state is AdminLoading) {
            return const AdminDashboardShimmer();
          } else if (state is AdminStatsSuccess) {
            final stats = state.stats;
            return RefreshIndicator(
              onRefresh: () => context.read<AdminCubit>().getStats(),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const SummaryHeader(),
                  const SizedBox(height: 24),
                  _buildSectionTitle(context, local.vital_indicators),
                  const SizedBox(height: 16),
                  ModernStatGrid(stats: stats),
                  const SizedBox(height: 24),
                  const TimeFilterSelector(),
                  const SizedBox(height: 16),
                  const DateSelector(),
                  const SizedBox(height: 24),
                  MainComparisonChart(stats: stats),
                  const SizedBox(height: 32),
                  _buildSectionTitle(
                    context,
                    local.market_composition_analysis,
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        DonutChartCard(
                          title: local.featured_properties,
                          data: {
                            local.featured_label: stats.featuredProperties,
                            local.normal_label:
                                stats.totalProperties -
                                stats.featuredProperties,
                          },
                          color: Colors.amber,
                        ),
                        DonutChartCard(
                          title: local.listing_type,
                          data: {
                            local.sale: stats.propertiesForSale,
                            local.rent: stats.propertiesForRent,
                          },
                          color: Colors.blueAccent,
                        ),
                        DonutChartCard(
                          title: local.market_status,
                          data: stats.propertiesByStatus,
                          color: Colors.teal,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle(context, local.recent_activity_summary),
                  const SizedBox(height: 16),
                  RecentActivityTimeline(stats: stats),
                  const SizedBox(height: 32),
                  _buildSectionTitle(context, local.control_and_system),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            AdminToolSquare(
                              label: local.premium_requests,
                              icon: Icons.stars_rounded,
                              color: Colors.amber,
                              onTap: () => context.push(
                                AppRoutes.adminProperties,
                                extra: local.premium_requests,
                              ),
                            ),
                            if (stats.pendingPremiumRequests > 0)
                              Positioned(
                                top: 8.h,
                                left: 8.w,
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '${stats.pendingPremiumRequests}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 8.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: AdminToolSquare(
                          label: local.audit_logs,
                          icon: Icons.access_time_rounded,
                          color: const Color(0xFF5C6BC0),
                          onTap: () =>
                              context.pushNamed(AppRoutes.adminAuditLogs),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: AdminToolSquare(
                          label: local.financial_wallet,
                          icon: Icons.account_balance_wallet_rounded,
                          color: Colors.green,
                          onTap: () =>
                              context.pushNamed(AppRoutes.adminFinancials),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AdminToolSquare(
                          label: local.settings,
                          icon: Icons.settings_suggest_rounded,
                          color: Colors.blueGrey,
                          onTap: () =>
                              context.pushNamed(AppRoutes.adminSettings),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  CityDistributionCard(cities: stats.propertiesByCity),
                  const SizedBox(height: 50),
                ],
              ),
            );
          } else if (state is AdminFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    local.error_fetching_data.replaceFirst(
                      '{error}',
                      state.errMessage,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.read<AdminCubit>().getStats(),
                    child: Text(local.retry),
                  ),
                ],
              ),
            );
          }
          return Center(child: Text(local.initializing_data));
        },
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      title,
      style: TextStyle(
        fontSize: 17.sp,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white : const Color(0xFF1A1C1E),
        fontFamily: 'Cairo',
      ),
    );
  }
}
