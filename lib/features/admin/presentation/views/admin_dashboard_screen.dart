import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/core/routing/app_routes.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/core/utils/service_locator.dart';
import 'package:test_graduation/core/widgets/stat_card.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_action_cubit/admin_action_cubit.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_cubit.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_state.dart';
import 'package:test_graduation/features/admin/presentation/views/widgets/custom_drawer.dart';

import 'package:test_graduation/core/utils/styles.dart';
import 'package:test_graduation/features/admin/presentation/views/widgets/audit_logs/audit_logs_screen.dart';

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
            return const Center(child: CircularProgressIndicator());
          } else if (state is AdminStatsSuccess) {
            final stats = state.stats;
            return RefreshIndicator(
              onRefresh: () => context.read<AdminCubit>().getStats(),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildSummaryHeader(),
                  const SizedBox(height: 24),

                  // Quick Stats Grid
                  _buildSectionTitle("نظرة عامة على الأرقام"),
                  const SizedBox(height: 12),
                  _buildQuickStats(stats),

                  const SizedBox(height: 24),

                  // Time Filter Selector
                  _buildTimeFilterSelector(context),
                  const SizedBox(height: 16),
                  _buildDateSelector(context),

                  const SizedBox(height: 24),

                  // Growth Charts
                  _buildChartSection(
                    title: 'معدل نمو المستخدمين',
                    data: stats.userGrowth.map((e) => e.value).toList(),
                    labels: stats.userGrowth.map((e) => e.label).toList(),
                    color: AppColors.primary,
                  ),

                  const SizedBox(height: 32),

                  _buildChartSection(
                    title: 'العقارات المضافة مؤخراً',
                    data: stats.propertyGrowth.map((e) => e.value).toList(),
                    labels: stats.propertyGrowth.map((e) => e.label).toList(),
                    color: Colors.blueAccent,
                  ),

                  const SizedBox(height: 32),

                  // Distribution Sections
                  _buildSectionTitle("إدارة النظام والرقابة"),
                  const SizedBox(height: 16),
                  _buildAdminToolsCard(
                    title: "سجل نشاطات المسؤولين",
                    icon: Icons.history_edu,
                    color: Colors.indigo,
                    onTap: () => context.pushNamed(AppRoutes.adminAuditLogs),
                  ),
                  const SizedBox(height: 8),
                  _buildAdminToolsCard(
                    title: "إعدادات المنصة (Config)",
                    icon: Icons.settings_applications,
                    color: Colors.blueGrey,
                    onTap: () {
                      // ستنفذ لاحقاً
                    },
                  ),
                  const SizedBox(height: 24),

                  _buildSectionTitle("تحليل جودة وتكوين السوق"),
                  const SizedBox(height: 16),
                  _buildPieChartSection(
                    title: "العقارات المميزة",
                    data: {
                      "مميزة ✨": stats.featuredProperties,
                      "عادية": stats.totalProperties - stats.featuredProperties,
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildPieChartSection(
                    title: "نوع الإدراج",
                    data: {
                      "للبيع": stats.propertiesForSale,
                      "للإيجار": stats.propertiesForRent,
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildPieChartSection(
                    title: "تحليل حالات العقارات",
                    data: stats.propertiesByStatus,
                  ),
                  const SizedBox(height: 24),

                  _buildSectionTitle("توزيع البيانات الجغرافي والإداري"),
                  const SizedBox(height: 12),
                  _buildDistributionCard(
                    title: "توزيع العقارات حسب النوع",
                    data: stats.propertiesByType,
                    icon: Icons.category_outlined,
                    isFullWidth: true,
                  ),
                  const SizedBox(height: 16),
                  _buildDistributionCard(
                    title: "توزيع أدوار المستخدمين",
                    data: stats.usersByRole,
                    icon: Icons.admin_panel_settings_outlined,
                    isFullWidth: true,
                  ),

                  const SizedBox(height: 24),

                  _buildCityDistribution(stats.propertiesByCity),

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

  Widget _buildQuickStats(dynamic stats) {
    return Column(
      children: [
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.4,
          children: [
            StatCard(
              title: 'إجمالي المستخدمين',
              value: '${stats.totalUsers}',
              icon: Icons.people_alt_rounded,
              color: AppColors.primary,
              onTap: () => context.pushNamed(AppRoutes.adminUsers),
            ),
            StatCard(
              title: 'إجمالي العقارات',
              value: '${stats.totalProperties}',
              icon: Icons.home_work_rounded,
              color: Colors.blueAccent,
              onTap: () => context.pushNamed(AppRoutes.adminProperties),
            ),
            StatCard(
              title: 'البلاغات الجديدة',
              value: '${stats.pendingReports}',
              icon: Icons.report_problem_rounded,
              color: Colors.redAccent,
              onTap: () => context.pushNamed(AppRoutes.adminReports),
            ),
            StatCard(
              title: 'إيرادات تقديرية',
              value: '${stats.yearly.totalRevenue.toInt()} \$',
              icon: Icons.monetization_on_rounded,
              color: Colors.green,
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildDailyActivityRow(stats),
      ],
    );
  }

  Widget _buildAdminToolsCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: Styles.textStyle16),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1A1C1E),
      ),
    );
  }

  Widget _buildSummaryHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, const Color(0xFF1E3A8A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'أهلاً بك أيها القائد 👑',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.auto_graph, color: Colors.white70),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'نظام التحليلات الذكي يعمل بكفاءة.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyActivityRow(dynamic stats) {
    return Row(
      children: [
        _buildMiniStatItem(
          "مستخدمين جدد",
          "${stats.daily.newUsers}",
          Icons.person_add_alt_1,
          Colors.orange,
        ),
        const SizedBox(width: 12),
        _buildMiniStatItem(
          "عقارات اليوم",
          "${stats.daily.newProperties}",
          Icons.add_business_rounded,
          Colors.blue,
        ),
        const SizedBox(width: 12),
        _buildMiniStatItem(
          "تم البيع",
          "${stats.daily.soldProperties}",
          Icons.verified_rounded,
          Colors.green,
        ),
      ],
    );
  }

  Widget _buildTimeFilterSelector(BuildContext context) {
    final cubit = context.read<AdminCubit>();
    final List<Map<String, String>> filters = [
      {'key': 'day', 'label': 'اليوم'},
      {'key': 'week', 'label': 'الأسبوع'},
      {'key': 'month', 'label': 'الشهر'},
      {'key': 'year', 'label': 'السنة'},
    ];

    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: filters.map((f) {
          bool isSelected = cubit.currentFilter == f['key'];
          return Expanded(
            child: GestureDetector(
              onTap: () => cubit.getStats(filter: f['key']),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  f['label']!,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[600],
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDateSelector(BuildContext context) {
    final cubit = context.read<AdminCubit>();
    String dateText = "";

    if (cubit.currentFilter == 'day') {
      dateText =
          "${cubit.selectedDate.day}/${cubit.selectedDate.month}/${cubit.selectedDate.year}";
    } else if (cubit.currentFilter == 'month') {
      dateText = "شهر ${cubit.selectedDate.month} / ${cubit.selectedDate.year}";
    } else if (cubit.currentFilter == 'year') {
      dateText = "سنة ${cubit.selectedDate.year}";
    } else {
      dateText =
          "آخر 7 أيام من ${cubit.selectedDate.day}/${cubit.selectedDate.month}";
    }

    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: cubit.selectedDate,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
          locale: const Locale('ar'),
        );
        if (picked != null) {
          cubit.getStats(date: picked);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.calendar_month_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  "عرض بيانات: $dateText",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const Icon(
              Icons.arrow_drop_down_circle_outlined,
              color: AppColors.primary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.1)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartSection({
    required String title,
    required List<double> data,
    required List<String> labels,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "الإجمالي: ${data.fold(0.0, (a, b) => a + b).toInt()}",
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 220,
            child: LineChart(
              LineChartData(
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (spot) => color.withOpacity(0.8),
                    getTooltipItems: (List<LineBarSpot> touchedSpots) {
                      return touchedSpots.map((spot) {
                        return LineTooltipItem(
                          '${labels[spot.x.toInt()]}\n',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: '${spot.y.toInt()} عملية',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        );
                      }).toList();
                    },
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) =>
                      FlLine(color: Colors.grey[100]!, strokeWidth: 1),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index < labels.length &&
                            index % (labels.length > 10 ? 3 : 1) == 0) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              labels[index],
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[600],
                              ),
                            ),
                          );
                        }
                        return const Text("");
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 35,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                      data.length,
                      (index) => FlSpot(index.toDouble(), data[index]),
                    ),
                    isCurved: true,
                    curveSmoothness: 0.35,
                    color: color,
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(
                            radius: 4,
                            color: Colors.white,
                            strokeWidth: 2,
                            strokeColor: color,
                          ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          color.withOpacity(0.3),
                          color.withOpacity(0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChartSection({
    required String title,
    required Map<String, int> data,
  }) {
    if (data.isEmpty) return const SizedBox.shrink();

    final List<Color> colors = [
      AppColors.primary,
      const Color(0xFFF59E0B), // Orange
      const Color(0xFF10B981), // Green
      const Color(0xFF3B82F6), // Blue
      const Color(0xFF8B5CF6), // Purple
      const Color(0xFFEF4444), // Red
    ];

    int total = data.values.fold(0, (sum, item) => sum + item);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Text(
                  "الإجمالي: $total",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              SizedBox(
                height: 140,
                width: 140,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 4,
                    centerSpaceRadius: 35,
                    sections: data.entries.toList().asMap().entries.map((
                      entry,
                    ) {
                      int index = entry.key;
                      var e = entry.value;
                      return PieChartSectionData(
                        color: colors[index % colors.length],
                        value: e.value.toDouble(),
                        title: '${((e.value / total) * 100).toInt()}%',
                        radius: 40,
                        titleStyle: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: data.entries.toList().asMap().entries.map((entry) {
                    int index = entry.key;
                    var e = entry.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: colors[index % colors.length],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _translateKey(e.key),
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[800],
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "${e.value}",
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _translateKey(String key) {
    switch (key.toLowerCase()) {
      case 'active':
        return 'نشط';
      case 'sold':
        return 'تم البيع';
      case 'underinstallment':
        return 'قيد التقسيط';
      case 'pending':
        return 'قيد الانتظار';
      case 'villas':
        return 'فيلات';
      case 'buildings':
        return 'عمارات';
      case 'housesandapartments':
        return 'بيوت وشقق';
      case 'shops':
        return 'محلات';
      case 'underconstruction':
        return 'قيد الإنشاء';
      case 'lands':
        return 'أراضي';
      case 'user':
        return 'مستخدم';
      case 'admin':
        return 'مسؤول';
      case 'agent':
        return 'وكيل';
      default:
        return key;
    }
  }

  Widget _buildDistributionCard({
    required String title,
    required Map<String, int> data,
    required IconData icon,
    bool isFullWidth = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (isFullWidth)
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: data.entries
                  .map((e) => _buildDistributionItem(e))
                  .toList(),
            )
          else
            ...data.entries
                .take(5)
                .map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: _buildDistributionItem(e),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildDistributionItem(MapEntry<String, int> e) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _translateKey(e.key),
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              "${e.value}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCityDistribution(Map<String, int> cities) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "النشاط حسب المدن",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          ...cities.entries.map((e) {
            double percentage = 0;
            int total = cities.values.fold(0, (a, b) => a + b);
            if (total > 0) percentage = e.value / total;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(e.key, style: const TextStyle(fontSize: 14)),
                      Text(
                        "${e.value} عقار",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: percentage,
                    backgroundColor: Colors.grey[200],
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(4),
                    minHeight: 6,
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
