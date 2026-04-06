import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:test_graduation/core/enums/property_enums.dart';
import 'package:test_graduation/core/routing/app_routes.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import 'package:test_graduation/features/my_properties/presentation/manager/my_properties_cubit.dart';

class MyPropertyItem extends StatelessWidget {
  const MyPropertyItem({super.key, required this.property, this.onSold});

  final PropertyEntity property;
  final VoidCallback? onSold; // 🔥 دالة الانتقال للـ Tab المباع

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,###');
    final String displayImage = property.media.isNotEmpty
        ? property.media[0]
        : (property.images.isNotEmpty ? property.images[0] : '');

    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      child: InkWell(
        onTap: () => GoRouter.of(context).push(
          AppRoutes.propertyDashboard,
          extra: property,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: displayImage.isNotEmpty
                                ? Image.network(
                                    displayImage,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        _buildPlaceholder(),
                                  )
                                : _buildPlaceholder(),
                          ),
                          Positioned(
                            top: 6,
                            right: 6,
                            child: _buildStatusChip(),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              property.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${numberFormat.format(property.price)} ${property.currency}',
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 14,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${property.governorate} - ${property.city}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_month_outlined,
                                      size: 14,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      DateFormat(
                                        'yyyy/MM/dd',
                                      ).format(property.createdAt),
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                                _buildOldViewsBadge(), // 🔥 إرجاع المشاهدات بالشكل القديم هنا
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 1, indent: 4, endIndent: 4),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildActionItem(
                            Icons.edit_note_rounded,
                            'تعديل',
                            Colors.blue,
                            () {
                              GoRouter.of(context).push(
                                AppRoutes.addPropertyScreen,
                                extra: property,
                              );
                            },
                          ),
                          const SizedBox(width: 16),
                          // 🔥 زر التمييز: يغير الحالة ولا ينتقل للـ Tab
                          _buildActionItem(
                            property.isFeatured
                                ? Icons.star_rounded
                                : Icons.star_border_rounded,
                            'مميز',
                            Colors.amber.shade700,
                            () => context
                                .read<MyPropertiesCubit>()
                                .toggleFeatured(property),
                          ),
                          const SizedBox(width: 16),
                          // 🔥 زر التقسيط
                          _buildActionItem(
                            property.status == PropertyStatus.underInstallment
                                ? Icons.timer_rounded
                                : Icons.timer_outlined,
                            'قيد التقسيط',
                            Colors.orange.shade800,
                            () => context
                                .read<MyPropertiesCubit>()
                                .updatePropertyStatus(
                                  property,
                                  property.status ==
                                          PropertyStatus.underInstallment
                                      ? PropertyStatus.active
                                      : PropertyStatus.underInstallment,
                                ),
                          ),
                          const SizedBox(width: 16),
                          // 🔥 زر البيع: يغير الحالة وينتقل للـ Tab المباع
                          _buildActionItem(
                            property.status == PropertyStatus.sold
                                ? Icons.check_circle_rounded
                                : Icons.sell_rounded,
                            'مباع',
                            Colors.teal,
                            () {
                              if (property.status == PropertyStatus.sold) {
                                // إذا كان مباعاً ونريد إلغاءه، نطلب السبب
                                _showCancellationDialog(context);
                              } else {
                                context
                                    .read<MyPropertiesCubit>()
                                    .updatePropertyStatus(
                                      property,
                                      PropertyStatus.sold,
                                    );
                                onSold?.call(); // تنفيذ الانتقال للـ Tab الآخر
                              }
                            },
                          ),
                          const SizedBox(width: 16),
                          // 🔥 زر السجل التاريخي
                          _buildActionItem(
                            Icons.history_rounded,
                            'السجل',
                            Colors.blueGrey,
                            () => _showStatusHistory(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: -8,
              left: 8,
              child: GestureDetector(
                onTap: () => _showDeleteConfirmDialog(
                  context,
                  context.read<MyPropertiesCubit>(),
                ),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmDialog(BuildContext context, MyPropertiesCubit cubit) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('حذف العقار', textAlign: TextAlign.center),
        content: const Text(
          'هل أنت متأكد من رغبتك في حذف هذا العقار نهائياً؟',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) cubit.deleteProperty(property.id, user.uid);
              Navigator.pop(dialogContext);
            },
            child: const Text(
              'حذف',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOldViewsBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.visibility_outlined,
            size: 16,
            color: AppColors.primary,
          ),
          const SizedBox(width: 4),
          Text(
            '${property.views}',
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip() {
    String label = property.status.arabicName;
    Color color = AppColors.primary;
    if (property.status == PropertyStatus.sold) {
      color = Colors.redAccent;
    } else if (property.status == PropertyStatus.underInstallment) {
      color = Colors.orange;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showCancellationDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('سبب إلغاء البيع', textAlign: TextAlign.center),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'مثلاً: تعثر المشتري في الدفع...',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                context.read<MyPropertiesCubit>().updatePropertyStatus(
                  property,
                  PropertyStatus.active,
                  statusReason: controller.text.trim(),
                );
                Navigator.pop(dialogContext);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text(
              'تأكيد الإلغاء',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showStatusHistory(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        final history = property.statusHistory.reversed.toList();
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'سجل حالة العقار',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 16),
              if (history.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Text('لا يوجد سجل حركات حالياً'),
                  ),
                )
              else
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: history.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final item = history[index];
                      final status = PropertyStatus.values.firstWhere(
                        (e) => e.name == item['status'],
                        orElse: () => PropertyStatus.active,
                      );
                      final date = item['timestamp'] != null
                          ? DateTime.parse(item['timestamp'])
                          : DateTime.now();
                      final reason = item['reason'] as String?;

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: _getStatusColor(status),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              if (index != history.length - 1)
                                Container(
                                  width: 2,
                                  height: 40,
                                  color: Colors.grey.shade200,
                                ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      status.arabicName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      DateFormat('yyyy/MM/dd HH:mm').format(
                                        date,
                                      ),
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                                if (reason != null && reason.isNotEmpty)
                                  Container(
                                    margin: const EdgeInsets.only(top: 4),
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'السبب: $reason',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade700,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'إغلاق',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getStatusColor(PropertyStatus status) {
    switch (status) {
      case PropertyStatus.active:
        return AppColors.primary;
      case PropertyStatus.sold:
        return Colors.redAccent;
      case PropertyStatus.underInstallment:
        return Colors.orange;
    }
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 100,
      height: 100,
      color: Colors.grey.shade100,
      child: const Icon(Icons.image_not_supported_outlined, color: Colors.grey),
    );
  }

  Widget _buildActionItem(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
