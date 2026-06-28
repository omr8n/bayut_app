import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/routing/app_routes.dart';
import 'package:test_graduation/core/utils/colors.dart';
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
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        title: Text(local.admin_platform_center),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        actions: [
          IconButton(
            onPressed: () => context.pushNamed(AppRoutes.adminSettings),
            icon: const Icon(Icons.settings_outlined),
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
                  _buildSectionTitle(local.vital_indicators),
                  const SizedBox(height: 16),
                  ModernStatGrid(stats: stats),
                  const SizedBox(height: 24),
                  const TimeFilterSelector(),
                  const SizedBox(height: 16),
                  const DateSelector(),
                  const SizedBox(height: 24),
                  MainComparisonChart(stats: stats),
                  const SizedBox(height: 32),
                  _buildSectionTitle(local.market_composition_analysis),
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
                  _buildSectionTitle(local.recent_activity_summary),
                  const SizedBox(height: 16),
                  RecentActivityTimeline(stats: stats),
                  const SizedBox(height: 32),
                  _buildSectionTitle(local.control_and_system),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: AdminToolSquare(
                          label: local.audit_logs,
                          icon: Icons.history_toggle_off_rounded,
                          color: Colors.indigo,
                          onTap: () =>
                              context.pushNamed(AppRoutes.adminAuditLogs),
                        ),
                      ),
                      const SizedBox(width: 12),
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
                                top: -5,
                                right: -5,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '${stats.pendingPremiumRequests}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
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

  Widget _buildSectionTitle(String title) => Text(
    title,
    style: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Color(0xFF1A1C1E),
    ),
  );
}
