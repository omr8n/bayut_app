import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:test_graduation/core/enums/property_enums.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/routing/app_routes.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import 'package:test_graduation/features/my_properties/presentation/manager/my_properties_cubit.dart';

class MyPropertyItem extends StatelessWidget {
  const MyPropertyItem({super.key, required this.property, this.onSold});

  final PropertyEntity property;
  final VoidCallback? onSold;

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,###');
    final String displayImage = property.media.isNotEmpty
        ? property.media[0]
        : (property.images.isNotEmpty ? property.images[0] : '');

    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          InkWell(
            onTap: () => GoRouter.of(context).push(AppRoutes.propertyDashboard, extra: property),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.r),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. الجزء الأيسر (البيانات)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildOldViewsBadge(), // المشاهدات في أقصى اليسار
                                Text(
                                  property.title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${numberFormat.format(property.price)} ${AppLocalizations.of(context)!.translate(property.currency.trim().toLowerCase())}',
                              style: TextStyle(
                                color: const Color(0xFF1E4C9A), // أزرق ملكي
                                fontWeight: FontWeight.w900,
                                fontSize: 16.sp,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Icon(Icons.location_on, size: 14, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(
                                  '${AppLocalizations.of(context)!.translate(property.governorate)} - ${property.city}',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Icon(Icons.access_time_rounded, size: 14, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(
                                  DateFormat('yyyy/MM/dd').format(property.createdAt),
                                  style: TextStyle(color: Colors.grey, fontSize: 11.sp),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // 2. الجزء الأيمن (الصورة)
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15.r),
                            child: displayImage.isNotEmpty
                                ? Image.network(
                                    displayImage,
                                    width: 100.w,
                                    height: 100.w,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => _buildPlaceholder(),
                                  )
                                : _buildPlaceholder(),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: _buildStatusChip(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(height: 24, thickness: 0.5),
                  // 3. الأزرار السفلية بالفواصل
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildExactActionItem(
                          context,
                          Icons.edit_rounded,
                          'تعديل',
                          Colors.blue,
                          () => GoRouter.of(context).push(AppRoutes.addPropertyScreen, extra: property),
                        ),
                        _buildSeparator(),
                        _buildPremiumActionStatus(context),
                        _buildSeparator(),
                        _buildExactActionItem(
                          context,
                          Icons.hourglass_bottom_rounded,
                          'قيد التقسيط',
                          Colors.orange.shade700,
                          () => context.read<MyPropertiesCubit>().updatePropertyStatus(
                            property,
                            property.status == PropertyStatus.underInstallment
                                ? PropertyStatus.active
                                : PropertyStatus.underInstallment,
                          ),
                        ),
                        if (property.status == PropertyStatus.sold) ...[
                          _buildSeparator(),
                          _buildExactActionItem(
                            context,
                            Icons.local_offer_rounded,
                            'مباع',
                            Colors.teal,
                            () {},
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // زر الحذف في أعلى اليسار
          Positioned(
            top: -10,
            left: -10,
            child: GestureDetector(
              onTap: () => _showDeleteConfirmDialog(context, context.read<MyPropertiesCubit>()),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
                ),
                child: const Icon(Icons.close_rounded, color: Colors.white, size: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOldViewsBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${property.views}',
            style: const TextStyle(color: Color(0xFF1E4C9A), fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.visibility_rounded, size: 16, color: Color(0xFF1E4C9A)),
        ],
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    String label = property.status.localizedName(context);
    Color color = const Color(0xFF1E4C9A); // Blue for active
    if (property.status == PropertyStatus.sold) color = Colors.redAccent;
    if (property.status == PropertyStatus.underInstallment) color = Colors.orange;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8.r)),
      child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildPremiumActionStatus(BuildContext context) {
    switch (property.premiumStatus) {
      case PremiumStatus.pending:
        return _buildExactActionItem(context, Icons.watch_later, 'طلب التميز قيد الانتظار', const Color(0xFF42A5F5), () {});
      case PremiumStatus.active:
        return _buildExactActionItem(context, Icons.emoji_events_rounded, 'عقار مميز', Colors.orange.shade700, () {});
      case PremiumStatus.rejected:
        return _buildExactActionItem(context, Icons.error, 'طلب التميز مرفوض', Colors.redAccent, () => _showPromotionDialog(context));
      default:
        return _buildExactActionItem(context, Icons.rocket_launch_rounded, 'طلب تميز', Colors.orange.shade800, () => _showPromotionDialog(context));
    }
  }

  Widget _buildExactActionItem(BuildContext context, IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 16.sp),
            SizedBox(width: 4.w),
            Text(label, style: TextStyle(color: color, fontSize: 12.sp, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildSeparator() {
    return Text('|', style: TextStyle(color: Colors.grey.shade300, fontSize: 18.sp));
  }

  void _showPromotionDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _PaymentSelectionSheet(property: property),
    );
  }

  void _showDeleteConfirmDialog(BuildContext context, MyPropertiesCubit cubit) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('حذف العقار'),
        content: const Text('هل أنت متأكد من حذف هذا العقار نهائياً؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('إلغاء')),
          TextButton(
            onPressed: () {
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) cubit.deleteProperty(property.id, user.uid);
              Navigator.pop(dialogContext);
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(width: 100.w, height: 100.w, color: Colors.grey.shade100, child: const Icon(Icons.image_not_supported_outlined, color: Colors.grey));
  }
}

// تم نقل الـ Sheets والـ Dialogs لأسفل الملف للحفاظ على الترتيب
class _PaymentSelectionSheet extends StatefulWidget {
  final PropertyEntity property;
  const _PaymentSelectionSheet({required this.property});

  @override
  State<_PaymentSelectionSheet> createState() => _PaymentSelectionSheetState();
}

class _PaymentSelectionSheetState extends State<_PaymentSelectionSheet> {
  int _selectedPackage = 1;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
          SizedBox(height: 24.h),
          const Text('ميز عقارك الآن 🚀', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 32.h),
          _buildPackageItem(0, 'باقة الأسبوع المميزة', '250,000', Icons.bolt_rounded, Colors.blue),
          SizedBox(height: 16.h),
          _buildPackageItem(1, 'الباقة الشهرية الاحترافية', '750,000', Icons.stars_rounded, Colors.amber.shade700),
          SizedBox(height: 32.h),
          ElevatedButton(
            onPressed: () { Navigator.pop(context); _showConfirmPaymentDialog(context); },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, minimumSize: Size(double.infinity, 55.h), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r))),
            child: const Text('الانتقال للدفع الآمن', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageItem(int index, String title, String price, IconData icon, Color color) {
    bool isSelected = _selectedPackage == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedPackage = index),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(color: isSelected ? color.withOpacity(0.05) : Colors.white, borderRadius: BorderRadius.circular(20.r), border: Border.all(color: isSelected ? color : Colors.grey.shade200, width: 2)),
        child: Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(price, style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 18)), Text('ل.س', style: TextStyle(color: color, fontSize: 12)), SizedBox(height: 8.h), Text(title, style: const TextStyle(fontWeight: FontWeight.bold))])), Icon(icon, color: color)]),
      ),
    );
  }

  void _showConfirmPaymentDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => _ConfirmPaymentDialog(property: widget.property, amount: _selectedPackage == 0 ? 250000 : 750000));
  }
}

class _ConfirmPaymentDialog extends StatefulWidget {
  final PropertyEntity property;
  final double amount;
  const _ConfirmPaymentDialog({required this.property, required this.amount});

  @override
  State<_ConfirmPaymentDialog> createState() => _ConfirmPaymentDialogState();
}

class _ConfirmPaymentDialogState extends State<_ConfirmPaymentDialog> {
  int _selectedMethod = 0;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.r)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('تأكيد الدفع 💳', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 24.h),
          _buildMethodTile(0, 'البطاقة المصرفية السورية'),
          _buildMethodTile(1, 'سيريتل كاش / إم تي إن كاش'),
          SizedBox(height: 24.h),
          Row(children: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')), Expanded(child: ElevatedButton(onPressed: () { context.read<MyPropertiesCubit>().requestPromotion(widget.property); Navigator.pop(context); }, style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary), child: const Text('دفع الآن', style: TextStyle(color: Colors.white))))]),
        ],
      ),
    );
  }

  Widget _buildMethodTile(int index, String title) {
    return RadioListTile(value: index, groupValue: _selectedMethod, onChanged: (val) => setState(() => _selectedMethod = val as int), title: Text(title, style: const TextStyle(fontSize: 13)));
  }
}
