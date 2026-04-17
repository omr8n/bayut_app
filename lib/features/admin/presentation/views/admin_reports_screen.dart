import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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

  @override
  void initState() {
    super.initState();
    context.read<AdminCubit>().fetchReports();
  }

  List<ReportEntity> _getFilteredReports(List<ReportEntity> allReports) {
    if (_filterStatus == null) return allReports;
    return allReports.where((r) => r.status == _filterStatus).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: _buildAppBar(context),
      body: BlocConsumer<AdminCubit, AdminState>(
        listener: _adminListener,
        builder: (context, state) {
          if (state is AdminLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          List<ReportEntity> allReports = [];
          if (state is AdminReportsSuccess) {
            allReports = state.reports;
          }

          final filteredReports = _getFilteredReports(allReports);

          return Column(
            children: [
              ReportsFilterSection(
                allReports: allReports,
                selectedStatus: _filterStatus,
                onStatusChanged: (status) => setState(() => _filterStatus = status),
              ),
              Expanded(
                child: filteredReports.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        itemCount: filteredReports.length,
                        itemBuilder: (context, index) {
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
            ],
          );
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.primary,
      title: const Text(
        'مركز إدارة الإبلاغات',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_turned_in_rounded, size: 100, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'لا توجد بلاغات في هذا القسم',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[500],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showReportDetails(BuildContext context, ReportEntity report) {
    final adminCubit = context.read<AdminCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ReportDetailsBottomSheet(
        report: report,
        adminCubit: adminCubit,
      ),
    );
  }
}
