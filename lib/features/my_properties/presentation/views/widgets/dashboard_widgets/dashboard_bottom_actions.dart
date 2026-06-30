import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/core/enums/property_enums.dart';
import 'package:test_graduation/core/routing/app_routes.dart';
import 'package:test_graduation/core/utils/colors.dart';

import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import 'package:test_graduation/features/my_properties/presentation/manager/my_properties_cubit.dart';

class DashboardBottomActions extends StatelessWidget {
  final PropertyEntity property;

  const DashboardBottomActions({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (locale == null) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 30.h),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _showStatusUpdateDialog(context, property),
              icon: const Icon(Icons.sync_rounded, color: Colors.white),
              label: Text(
                locale.translate(LangKeys.updateStatus),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(width: 12),
          _CircleActionButton(
            icon: Icons.edit_note_rounded,
            color: Colors.blue,
            onTap: () => GoRouter.of(
              context,
            ).push(AppRoutes.addPropertyScreen, extra: property),
          ),
          const SizedBox(width: 12),
          _CircleActionButton(
            icon: Icons.delete_sweep_rounded,
            color: Colors.red,
            onTap: () => _showDeleteConfirmDialog(context, property),
          ),
        ],
      ),
    );
  }

  void _showStatusUpdateDialog(BuildContext context, PropertyEntity property) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _StatusUpdateSheet(property: property),
    );
  }

  void _showDeleteConfirmDialog(BuildContext context, PropertyEntity property) {
    final locale = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dContext) => AlertDialog(
        title: Text(locale.translate(LangKeys.deleteProperty)),
        content: Text(locale.translate(LangKeys.deleteConfirmation)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dContext),
            child: Text(locale.translate(LangKeys.cancelAction)),
          ),
          TextButton(
            onPressed: () {
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                context.read<MyPropertiesCubit>().deleteProperty(
                  property.id,
                  user.uid,
                );
                Navigator.pop(dContext);
                Navigator.pop(context);
              }
            },
            child: Text(
              locale.translate(LangKeys.permanentDelete),
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _CircleActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(icon, color: color, size: 26),
      ),
    );
  }
}

class _StatusUpdateSheet extends StatelessWidget {
  final PropertyEntity property;

  const _StatusUpdateSheet({required this.property});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? Colors.white12 : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            locale.translate(LangKeys.updateStatusTitle),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
          ),
          const SizedBox(height: 20),
          _buildOption(
            context,
            PropertyStatus.active,
            locale.translate(LangKeys.activeStatusDesc),
            Icons.check_circle_outline,
          ),
          _buildOption(
            context,
            PropertyStatus.underInstallment,
            locale.translate(LangKeys.installmentStatusDesc),
            Icons.timer_outlined,
          ),
          _buildOption(
            context,
            PropertyStatus.sold,
            locale.translate(LangKeys.soldStatusDesc),
            Icons.sell_rounded,
          ),
          _buildOption(
            context,
            PropertyStatus.rented,
            locale.translate(LangKeys.rentedStatusDesc),
            Icons.key_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildOption(
    BuildContext context,
    PropertyStatus status,
    String title,
    IconData icon,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      leading: Icon(icon, color: _getStatusColor(status)),
      title: Text(title, style: TextStyle(color: isDark ? Colors.white70 : Colors.black87)),
      onTap: () {
        if (status == PropertyStatus.sold) {
          Navigator.pop(context);
          _showSoldConfirmation(context);
        } else if (status == PropertyStatus.active &&
            property.status == PropertyStatus.sold) {
          Navigator.pop(context);
          _showReasonDialog(context, status);
        } else {
          Navigator.pop(context);
          context.read<MyPropertiesCubit>().updatePropertyStatus(
            property,
            status,
          );
        }
      },
    );
  }

  void _showSoldConfirmation(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: Text(locale.translate(LangKeys.updateStatusTitle)),
        content: Text(locale.translate(LangKeys.soldStatusDesc)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dContext),
            child: Text(locale.translate(LangKeys.cancelAction)),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<MyPropertiesCubit>().updatePropertyStatus(
                property,
                PropertyStatus.sold,
              );
              Navigator.pop(dContext);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            child: Text(
              locale.translate(LangKeys.confirmAction),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showReasonDialog(BuildContext context, PropertyStatus status) {
    final controller = TextEditingController();
    final locale = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dContext) => AlertDialog(
        title: Text(locale.translate(LangKeys.cancelSaleReason)),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: locale.translate(LangKeys.enterReasonHere),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dContext),
            child: Text(locale.translate(LangKeys.cancelAction)),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<MyPropertiesCubit>().updatePropertyStatus(
                property,
                status,
                statusReason: controller.text,
              );
              Navigator.pop(dContext);
            },
            child: Text(locale.translate(LangKeys.confirmAction)),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(PropertyStatus status) {
    switch (status) {
      case PropertyStatus.active:
        return AppColors.primary;
      case PropertyStatus.sold:
        return Colors.redAccent;
      case PropertyStatus.rented:
        return Colors.purple;
      case PropertyStatus.underInstallment:
        return Colors.orange;
    }
  }
}
