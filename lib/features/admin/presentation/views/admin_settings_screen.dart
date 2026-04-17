// import 'package:flutter/material.dart';
// import '../../core/utils/colors.dart';

// class AdminSettingsScreen extends StatelessWidget {
//   const AdminSettingsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('الإعدادات'), centerTitle: true),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: const [
//           ListTile(
//             title: Text('تغيير كلمة المرور'),
//             leading: Icon(Icons.lock_outline),
//           ),
//           ListTile(
//             title: Text('الإشعارات'),
//             leading: Icon(Icons.notifications),
//           ),
//           ListTile(
//             title: Text('حول التطبيق'),
//             leading: Icon(Icons.info_outline),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/admin/presentation/views/widgets/data/admin_mock_data.dart';

// شاشة إعدادات التطبيق
class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  late bool _maintenanceMode;
  late bool _requireAdminApproval;
  late double _featuredPrice;
  late int _maxImages;

  @override
  void initState() {
    super.initState();
    _maintenanceMode = AdminMockData.settings.maintenanceMode;
    _requireAdminApproval = AdminMockData.settings.requireAdminApproval;
    _featuredPrice = AdminMockData.settings.featuredPropertyPrice;
    _maxImages = AdminMockData.settings.maxImagesPerProperty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إعدادات التطبيق'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // معلومات التطبيق
          _buildSection('معلومات التطبيق', Icons.info, [
            _buildInfoTile('اسم التطبيق', AdminMockData.settings.appName),
            _buildInfoTile('الإصدار', AdminMockData.settings.appVersion),
            _buildInfoTile('بريد الدعم', AdminMockData.settings.supportEmail),
            _buildInfoTile('هاتف الدعم', AdminMockData.settings.supportPhone),
          ]),
          const SizedBox(height: 16),

          // الإعدادات العامة
          _buildSection('الإعدادات العامة', Icons.settings, [
            SwitchListTile(
              title: const Text('وضع الصيانة'),
              subtitle: const Text('إيقاف التطبيق مؤقتاً'),
              value: _maintenanceMode,
              onChanged: (value) {
                setState(() => _maintenanceMode = value);
                _showSavedMessage();
              },
              activeColor: AppColors.warning,
            ),
            SwitchListTile(
              title: const Text('الموافقة على العقارات'),
              subtitle: const Text('مراجعة العقارات قبل النشر'),
              value: _requireAdminApproval,
              onChanged: (value) {
                setState(() => _requireAdminApproval = value);
                _showSavedMessage();
              },
              activeThumbColor: AppColors.primary,
            ),
          ]),
          const SizedBox(height: 16),

          // إعدادات العقارات
          _buildSection('إعدادات العقارات', Icons.home_work, [
            ListTile(
              title: const Text('سعر العقار المميز'),
              subtitle: Text('$_featuredPrice درهم'),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _showEditDialog(
                  'سعر العقار المميز',
                  _featuredPrice.toString(),
                  (value) {
                    setState(() => _featuredPrice = double.parse(value));
                  },
                ),
              ),
            ),
            ListTile(
              title: const Text('أقصى عدد صور'),
              subtitle: Text('$_maxImages صورة'),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _showEditDialog(
                  'أقصى عدد صور',
                  _maxImages.toString(),
                  (value) {
                    setState(() => _maxImages = int.parse(value));
                  },
                ),
              ),
            ),
          ]),
          const SizedBox(height: 16),

          // المدن المدعومة
          _buildSection('المدن المدعومة', Icons.location_city, [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: AdminMockData.settings.allowedCities.map((city) {
                  return Chip(
                    label: Text(city),
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    labelStyle: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                }).toList(),
              ),
            ),
          ]),
          const SizedBox(height: 16),

          // أنواع العقارات
          _buildSection('أنواع العقارات المدعومة', Icons.category, [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: AdminMockData.settings.allowedPropertyTypes.map((
                  type,
                ) {
                  return Chip(
                    label: Text(type),
                    backgroundColor: AppColors.success.withOpacity(0.1),
                    labelStyle: const TextStyle(
                      color: AppColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                }).toList(),
              ),
            ),
          ]),
          const SizedBox(height: 16),

          // إحصائيات النظام
          _buildSection('إحصائيات النظام', Icons.analytics, [
            _buildInfoTile('عدد المستخدمين', '${AdminMockData.users.length}'),
            _buildInfoTile(
              'عدد العقارات',
              '${AdminMockData.stats.totalProperties}',
            ),
            _buildInfoTile('عدد الإبلاغات', '${AdminMockData.reports.length}'),
          ]),
        ],
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: AppColors.primary, size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return ListTile(
      title: Text(label),
      trailing: Text(
        value,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }

  void _showEditDialog(
    String title,
    String initialValue,
    Function(String) onSave,
  ) {
    final controller = TextEditingController(text: initialValue);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تعديل $title'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.right,
          decoration: InputDecoration(labelText: title),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                onSave(controller.text);
                Navigator.pop(context);
                _showSavedMessage();
              }
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  void _showSavedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم حفظ التغييرات'),
        backgroundColor: AppColors.success,
      ),
    );
  }
}
