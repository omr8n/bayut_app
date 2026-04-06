import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/core/enums/property_enums.dart';
import 'package:test_graduation/core/routing/app_routes.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import 'package:test_graduation/features/my_properties/presentation/manager/my_properties_cubit.dart';

class DashboardBottomActions extends StatelessWidget {
  final PropertyEntity property;

  const DashboardBottomActions({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 30.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _showStatusUpdateDialog(context, property),
              icon: const Icon(Icons.sync_rounded, color: Colors.white),
              label: const Text(
                'تحديث الحالة',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(width: 12),
          _CircleActionButton(
            icon: Icons.edit_note_rounded,
            color: Colors.blue,
            onTap: () => GoRouter.of(context).push(AppRoutes.addPropertyScreen, extra: property),
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
    showDialog(
      context: context,
      builder: (dContext) => AlertDialog(
        title: const Text('حذف العقار'),
        content: const Text('هل أنت متأكد؟ لا يمكن التراجع عن هذه الخطوة.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dContext), child: const Text('إلغاء')),
          TextButton(
            onPressed: () {
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                context.read<MyPropertiesCubit>().deleteProperty(property.id, user.uid);
                Navigator.pop(dContext);
                Navigator.pop(context);
              }
            },
            child: const Text('حذف نهائي', style: TextStyle(color: Colors.red)),
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

  const _CircleActionButton({required this.icon, required this.color, required this.onTap});

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
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
          ),
          const SizedBox(height: 20),
          const Text('تحديث حالة العقار', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _buildOption(context, PropertyStatus.active, 'نشط (متاح للجميع)', Icons.check_circle_outline),
          _buildOption(context, PropertyStatus.underInstallment, 'قيد التقسيط', Icons.timer_outlined),
          _buildOption(context, PropertyStatus.sold, 'تم البيع (إخفاء)', Icons.sell_rounded),
        ],
      ),
    );
  }

  Widget _buildOption(BuildContext context, PropertyStatus status, String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: _getStatusColor(status)),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        if (status == PropertyStatus.active && property.status == PropertyStatus.sold) {
          _showReasonDialog(context, status);
        } else {
          context.read<MyPropertiesCubit>().updatePropertyStatus(property, status);
        }
      },
    );
  }

  void _showReasonDialog(BuildContext context, PropertyStatus status) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (dContext) => AlertDialog(
        title: const Text('سبب إلغاء البيع'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'ادخل السبب هنا...'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dContext), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              context.read<MyPropertiesCubit>().updatePropertyStatus(property, status, statusReason: controller.text);
              Navigator.pop(dContext);
            },
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(PropertyStatus status) {
    switch (status) {
      case PropertyStatus.active: return AppColors.primary;
      case PropertyStatus.sold: return Colors.redAccent;
      case PropertyStatus.underInstallment: return Colors.orange;
    }
  }
}
