import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/core/widgets/report_item.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_cubit.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_state.dart';
import 'package:test_graduation/features/reports/domain/entities/report_entity.dart';
import 'widgets/admin_reports_widgets/reports_filter_section.dart';
import 'widgets/admin_reports_widgets/report_details_bottom_sheet.dart';

class AdminReportsScreen extends StatefulWidget {
  const AdminReportsScreen({super.key});

  @override
  State<AdminReportsScreen> createState() => _AdminReportsScreenState();
}

class _AdminReportsScreenState extends State<AdminReportsScreen> {
  ReportStatus? _filterStatus;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<AdminCubit>().fetchReports(isRefresh: true);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<AdminCubit>().fetchReports();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    return currentScroll >= (maxScroll * 0.9);
  }

  List<ReportEntity> _getFilteredReports(List<ReportEntity> allReports) {
    if (_filterStatus == null) return allReports;
    return allReports.where((r) => r.status == _filterStatus).toList();
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : const Color(0xFFF0F2F5),
      appBar: _buildAppBar(context, local),
      body: BlocConsumer<AdminCubit, AdminState>(
        listener: _adminListener,
        builder: (context, state) {
          final isLoading = state is AdminLoading;
          List<ReportEntity> allReports = [];
          if (state is AdminReportsSuccess) {
            allReports = state.reports;
          }

          final filteredReports = _getFilteredReports(allReports);

          return Column(
            children: [
              if (isLoading && allReports.isEmpty)
                const LinearProgressIndicator(
                  backgroundColor: Colors.transparent,
                  color: AppColors.primary,
                  minHeight: 3,
                ),
              ReportsFilterSection(
                allReports: allReports,
                selectedStatus: _filterStatus,
                onStatusChanged: (status) =>
                    setState(() => _filterStatus = status),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await context.read<AdminCubit>().fetchReports(isRefresh: true);
                  },
                  color: AppColors.primary,
                  child: filteredReports.isEmpty
                      ? (isLoading ? const SizedBox.shrink() : _buildEmptyState(local))
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: state is AdminReportsSuccess && !state.hasReachedMax
                              ? filteredReports.length + 1
                              : filteredReports.length,
                          itemBuilder: (context, index) {
                            if (index >= filteredReports.length) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            final report = filteredReports[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: ReportItem(
                                report: report,
                                onTap: () => _showReportDetails(context, report),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, AppLocalizations local) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AppBar(
      elevation: 0,
      backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFF00142B),
      title: Text(
        local.reports_management_center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => context.pop(),
      ),
    );
  }

  void _adminListener(BuildContext context, AdminState state) {
    if (state is AdminActionSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else if (state is AdminFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.errMessage),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _buildEmptyState(AppLocalizations local) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.2),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.assignment_turned_in_rounded,
                size: 100,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 16),
              Text(
                local.no_reports_in_section,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showReportDetails(BuildContext context, ReportEntity report) {
    final adminCubit = context.read<AdminCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          ReportDetailsBottomSheet(report: report, adminCubit: adminCubit),
    );
  }
}
