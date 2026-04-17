import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_cubit.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminPropertyActions extends StatelessWidget {
  const AdminPropertyActions({super.key, required this.property});

  final PropertyEntity property;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // 1. زر التواصل مع المالك (احترافي جداً للاستفسار)
        _buildActionButton(
          context,
          Icons.chat,
          Colors.green,
          () => _contactOwner(property.whatsapp),
          tooltip: 'تواصل مع المالك',
        ),
        const SizedBox(width: 8),

        // 2. زر التميز (Promotion)
        _buildActionButton(
          context,
          Icons.star,
          property.isFeatured ? AppColors.featured : Colors.grey.shade400,
          () {
            context.read<AdminCubit>().togglePropertyFeatured(
              property.id,
              !property.isFeatured,
            );
          },
          tooltip: property.isFeatured ? 'إلغاء التمييز' : 'تمييز العقار',
        ),
        const SizedBox(width: 8),

        // 3. زر الحالة (قبول / رفض مع سبب)
        _buildActionButton(
          context,
          property.isApproved ? Icons.check_circle : Icons.cancel,
          property.isApproved ? AppColors.success : AppColors.error,
          () => _showStatusDialog(context),
          tooltip: property.isApproved ? 'إدارة القبول' : 'مراجعة الطلب',
        ),
        const SizedBox(width: 8),

        // 4. زر الحذف (للسبام والمخالفات الجسيمة فقط)
        _buildActionButton(
          context,
          Icons.delete_sweep,
          Colors.redAccent,
          () => _showDeleteDialog(context),
          tooltip: 'حذف نهائي (مخالفة جسيمة)',
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    Color color,
    VoidCallback onTap, {
    String? tooltip,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Tooltip(
        message: tooltip ?? '',
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
      ),
    );
  }

  void _contactOwner(String phone) async {
    final url = "https://wa.me/$phone";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  void _showStatusDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          property.isApproved ? 'تعطيل العقار' : 'الموافقة على العقار',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              property.isApproved
                  ? 'هل تريد إخفاء هذا العقار من العرض العام؟'
                  : 'بعد الموافقة، سيظهر العقار لجميع المستخدمين.',
            ),
            if (!property.isApproved) ...[
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  hintText: 'أضف ملاحظة للمالك (اختياري)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: property.isApproved
                  ? Colors.orange
                  : Colors.green,
            ),
            onPressed: () {
              context.read<AdminCubit>().togglePropertyApproval(
                property.id,
                !property.isApproved,
              );
              Navigator.pop(dialogContext);
            },
            child: Text(property.isApproved ? 'تعطيل الآن' : 'موافقة ونشر'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('حذف نهائي'),
        content: const Text(
          'هذا الإجراء لا يمكن التراجع عنه. هل العقار مخالف فعلاً للقوانين؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              context.read<AdminCubit>().deleteProperty(property.id);
              Navigator.pop(dialogContext);
            },
            child: const Text('تأكيد الحذف'),
          ),
        ],
      ),
    );
  }
}
