import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:test_graduation/core/routing/app_routes.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import 'package:test_graduation/features/my_properties/presentation/manager/my_properties_cubit.dart';

class MyPropertyItem extends StatelessWidget {
  const MyPropertyItem({super.key, required this.property, this.onReserved});

  final PropertyEntity property;
  final VoidCallback? onReserved; // 🔥 دالة الانتقال للـ Tab المحجوز

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,###');
    final String displayImage = property.media.isNotEmpty
        ? property.media[0]
        : (property.images.isNotEmpty ? property.images[0] : '');

    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      child: InkWell(
        onTap: () => GoRouter.of(
          context,
        ).push(AppRoutes.addPropertyScreen, extra: property),
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
                          // 🔥 زر الحجز: يغير الحالة وينتقل للـ Tab المحجوز
                          _buildActionItem(
                            property.isReserved
                                ? Icons.lock_rounded
                                : Icons.lock_person_rounded,
                            'محجوز',
                            Colors.teal,
                            () {
                              context.read<MyPropertiesCubit>().toggleReserved(
                                property,
                              );
                              if (!property.isReserved) {
                                onReserved
                                    ?.call(); // تنفيذ الانتقال للـ Tab الآخر
                              }
                            },
                          ),
                          const SizedBox(width: 16),
                          _buildActionItem(
                            Icons.visibility_outlined,
                            '${property.views}',
                            Colors.grey,
                            () {},
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

  Widget _buildStatusChip() {
    String label = 'نشط';
    Color color = AppColors.primary;
    if (property.isReserved) {
      label = 'محجوز';
      color = Colors.redAccent;
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
