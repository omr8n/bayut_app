import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        title: const Text('مركز إدارة المنصة'),
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
                  _buildSectionTitle("المؤشرات الحيوية"),
                  const SizedBox(height: 16),
                  ModernStatGrid(stats: stats),
                  const SizedBox(height: 24),
                  const TimeFilterSelector(),
                  const SizedBox(height: 16),
                  const DateSelector(),
                  const SizedBox(height: 24),
                  MainComparisonChart(stats: stats),
                  const SizedBox(height: 32),
                  _buildSectionTitle("تحليل تكوين السوق"),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        DonutChartCard(
                          title: "العقارات المميزة",
                          data: {
                            "مميزة": stats.featuredProperties,
                            "عادية": stats.totalProperties - stats.featuredProperties,
                          },
                          color: Colors.amber,
                        ),
                        DonutChartCard(
                          title: "نوع الإدراج",
                          data: {
                            "بيع": stats.propertiesForSale,
                            "إيجار": stats.propertiesForRent,
                          },
                          color: Colors.blueAccent,
                        ),
                        DonutChartCard(
                          title: "حالة السوق",
                          data: stats.propertiesByStatus,
                          color: Colors.teal,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle("ملخص النشاط الأخير"),
                  const SizedBox(height: 16),
                  RecentActivityTimeline(stats: stats),
                  const SizedBox(height: 32),
                  _buildSectionTitle("الرقابة والنظام"),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: AdminToolSquare(
                          label: "سجل العمليات",
                          icon: Icons.history_toggle_off_rounded,
                          color: Colors.indigo,
                          onTap: () => context.pushNamed(AppRoutes.adminAuditLogs),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AdminToolSquare(
                          label: "الإعدادات",
                          icon: Icons.settings_suggest_rounded,
                          color: Colors.blueGrey,
                          onTap: () => context.pushNamed(AppRoutes.adminSettings),
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
                  Text('خطأ في جلب البيانات: ${state.errMessage}'),
                  TextButton(
                    onPressed: () => context.read<AdminCubit>().getStats(),
                    child: const Text("إعادة المحاولة"),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('جاري تهيئة البيانات...'));
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
