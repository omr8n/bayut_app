import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:test_graduation/features/admin/presentation/manager/admin_cubit.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_state.dart';
import 'package:test_graduation/core/models/admin_stats_model.dart';

import 'package:test_graduation/core/language/app_localizations.dart';

class AdminAnalyticsScreen extends StatefulWidget {
  const AdminAnalyticsScreen({super.key});

  @override
  State<AdminAnalyticsScreen> createState() => _AdminAnalyticsScreenState();
}

class _AdminAnalyticsScreenState extends State<AdminAnalyticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.read<AdminCubit>().getStats();
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: BlocBuilder<AdminCubit, AdminState>(
        builder: (context, state) {
          if (state is AdminLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AdminStatsSuccess) {
            return _buildBody(state.stats, local);
          } else if (state is AdminFailure) {
            return Center(
              child: Text('${local.error_label}${state.errMessage}'),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildBody(AdminStats stats, AppLocalizations local) {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(local),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummarySection(stats, local),
                const SizedBox(height: 24),
                _buildGrowthSection(stats, local),
                const SizedBox(height: 24),
                _buildActivitySection(stats, local),
                const SizedBox(height: 24),
                _buildMarketSection(stats, local),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar(AppLocalizations local) {
    return SliverAppBar(
      expandedHeight: 180.0,
      floating: false,
      pinned: true,
      backgroundColor: const Color(0xFF1E4C9A),
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          local.data_intelligence_center,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        background: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF1E4C9A),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummarySection(AdminStats stats, AppLocalizations local) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          local.today_summary,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMiniStatCard(
                local.users_label,
                stats.daily.newUsers.toString(),
                Icons.person_add,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMiniStatCard(
                local.properties_label,
                stats.daily.newProperties.toString(),
                Icons.home_work,
                Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMiniStatCard(
                local.sales_label,
                stats.daily.soldProperties.toString(),
                Icons.shopping_bag,
                Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMiniStatCard(
                local.rentals_label,
                stats.daily.rentedProperties.toString(),
                Icons.key,
                Colors.purple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMiniStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGrowthSection(AdminStats stats, AppLocalizations local) {
    return _buildChartContainer(
      title: local.platform_growth_7_days,
      child: SizedBox(
        height: 200,
        child: LineChart(
          LineChartData(
            gridData: const FlGridData(show: false),
            titlesData: _buildChartTitles(stats.userGrowth),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              _buildLineSeries(
                stats.userGrowth,
                Colors.blue,
                local.users_label,
              ),
              _buildLineSeries(
                stats.propertyGrowth,
                Colors.orange,
                local.properties_label,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivitySection(AdminStats stats, AppLocalizations local) {
    return _buildChartContainer(
      title: local.daily_activity_analysis,
      child: SizedBox(
        height: 250,
        child: BarChart(
          BarChartData(
            barGroups: _buildBarGroups(stats),
            borderData: FlBorderData(show: false),
            gridData: const FlGridData(show: false),
            titlesData: _buildChartTitles(stats.propertyGrowth),
          ),
        ),
      ),
    );
  }

  Widget _buildMarketSection(AdminStats stats, AppLocalizations local) {
    return _buildChartContainer(
      title: local.real_estate_market_distribution,
      child: SizedBox(
        height: 200,
        child: PieChart(
          PieChartData(
            sections: [
              PieChartSectionData(
                value: stats.propertiesForSale.toDouble(),
                title: local.sale,
                color: Colors.blue,
                radius: 50,
                titleStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              PieChartSectionData(
                value: stats.propertiesForRent.toDouble(),
                title: local.rent,
                color: Colors.orange,
                radius: 50,
                titleStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChartContainer({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }

  LineChartBarData _buildLineSeries(
    List<ChartDataPoint> data,
    Color color,
    String name,
  ) {
    return LineChartBarData(
      spots: data
          .asMap()
          .entries
          .map((e) => FlSpot(e.key.toDouble(), e.value.value))
          .toList(),
      isCurved: true,
      color: color,
      barWidth: 3,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(show: true, color: color.withOpacity(0.1)),
    );
  }

  List<BarChartGroupData> _buildBarGroups(AdminStats stats) {
    return List.generate(stats.propertyGrowth.length, (i) {
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: stats.propertyGrowth[i].value,
            color: Colors.blue,
            width: 8,
          ),
          BarChartRodData(
            toY: stats.salesGrowth[i].value,
            color: Colors.green,
            width: 8,
          ),
          BarChartRodData(
            toY: stats.rentGrowth[i].value,
            color: Colors.purple,
            width: 8,
          ),
        ],
      );
    });
  }

  FlTitlesData _buildChartTitles(List<ChartDataPoint> data) {
    return FlTitlesData(
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            int index = value.toInt();
            if (index >= 0 && index < data.length) {
              return Text(
                data[index].label,
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
