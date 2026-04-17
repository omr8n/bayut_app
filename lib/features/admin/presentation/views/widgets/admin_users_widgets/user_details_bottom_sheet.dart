import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_cubit.dart';
import 'package:test_graduation/features/auth/domain/entites/user_entity.dart';

class UserDetailsBottomSheet extends StatefulWidget {
  const UserDetailsBottomSheet({
    super.key,
    required this.user,
    required this.adminCubit,
  });

  final UserEntity user;
  final AdminCubit adminCubit;

  @override
  State<UserDetailsBottomSheet> createState() => _UserDetailsBottomSheetState();
}

class _UserDetailsBottomSheetState extends State<UserDetailsBottomSheet> {
  late TextEditingController notesController;
  bool isEmailVisible = false;

  @override
  void initState() {
    super.initState();
    notesController = TextEditingController(text: widget.user.adminNotes ?? '');
  }

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.adminCubit,
      child: DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF8F9FA),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: ListView(
            controller: controller,
            padding: const EdgeInsets.all(24),
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildInfoCard(),
              const SizedBox(height: 24),
              const Text('الملاحظات الإدارية (سرية)', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _buildNotesField(),
              const SizedBox(height: 24),
              const Text('إجراءات الحساب', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildActionButtons(context),
              const SizedBox(height: 32),
              _buildDangerZone(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 35,
          backgroundColor: AppColors.primary.withOpacity(0.1),
          backgroundImage: widget.user.profilePic != null ? NetworkImage(widget.user.profilePic!) : null,
          child: widget.user.profilePic == null ? const Icon(Icons.person, size: 35, color: AppColors.primary) : null,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.user.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text(widget.user.role == 'admin' ? 'مدير نظام (Admin)' : 'مستخدم', 
                   style: TextStyle(color: widget.user.role == 'admin' ? AppColors.info : Colors.grey, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey[200]!)),
      child: Column(
        children: [
          _buildInfoRow(Icons.email, widget.user.email),
          const Divider(),
          _buildInfoRow(Icons.phone, widget.user.phoneNumber ?? 'لا يوجد رقم هاتف'),
          const Divider(),
          _buildInfoRow(Icons.calendar_today, "تاريخ الانضمام: ${_formatDate(widget.user.createdAt)}"),
        ],
      ),
    );
  }

  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return "غير معروف";
    if (timestamp is DateTime) return "${timestamp.year}-${timestamp.month}-${timestamp.day}";
    return "نشط منذ فترة";
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [Icon(icon, size: 18, color: Colors.grey), const SizedBox(width: 12), Text(text, style: const TextStyle(fontSize: 14))]),
    );
  }

  Widget _buildNotesField() {
    return Column(
      children: [
        TextField(
          controller: notesController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'اكتب ملاحظاتك عن هذا المستخدم هنا... لن يراها أبداً.',
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey[200]!)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey[100]!)),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () => widget.adminCubit.updateAdminNotes(widget.user.uId, notesController.text),
            icon: const Icon(Icons.save, size: 16),
            label: const Text('حفظ الملاحظة'),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _launchEmail(widget.user.email),
            icon: const Icon(Icons.mail_outline, color: Colors.white),
            label: const Text('مراسلة بالبريد', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.info, padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => widget.adminCubit.toggleUserBlock(widget.user.uId, !widget.user.isBanned),
            icon: Icon(widget.user.isBanned ? Icons.lock_open : Icons.block, color: Colors.white),
            label: Text(widget.user.isBanned ? 'فك الحظر' : 'حظر الحساب', style: const TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(backgroundColor: widget.user.isBanned ? AppColors.success : AppColors.error, padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
        ),
      ],
    );
  }

  Widget _buildDangerZone(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.red[100]!)),
      child: Column(
        children: [
          const Text('منطقة خطرة', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => _confirmDelete(context),
              style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red)),
              child: const Text('حذف المستخدم نهائياً', style: TextStyle(color: Colors.red)),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف نهائي'),
        content: const Text('هل أنت متأكد من حذف هذا الحساب تماماً من قاعدة البيانات؟ لا يمكن التراجع.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
              widget.adminCubit.deleteUser(widget.user.uId);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('تأكيد الحذف'),
          ),
        ],
      ),
    );
  }

  void _launchEmail(String email) async {
    final Uri params = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(params)) await launchUrl(params);
  }
}
