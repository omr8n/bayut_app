import 'package:flutter/material.dart';
import 'package:test_graduation/core/utils/colors.dart';

class AdminSettingsView extends StatefulWidget {
  const AdminSettingsView({super.key});

  @override
  State<AdminSettingsView> createState() => _AdminSettingsViewState();
}

class _AdminSettingsViewState extends State<AdminSettingsView> {
  bool isMaintenanceMode = false;
  bool enableAds = true;
  double serviceCommission = 2.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        title: const Text('إعدادات المنصة الذكية'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSectionTitle("التحكم العام بالمنصة"),
          const SizedBox(height: 12),
          _buildSettingCard(
            title: "وضع الصيانة",
            subtitle: "إيقاف دخول المستخدمين مؤقتاً لإجراء تحديثات",
            icon: Icons.construction_rounded,
            color: Colors.orange,
            trailing: Switch(
              value: isMaintenanceMode,
              onChanged: (v) => setState(() => isMaintenanceMode = v),
              activeColor: AppColors.primary,
            ),
          ),
          _buildSettingCard(
            title: "إعلانات Google Ads",
            subtitle: "تفعيل أو تعطيل ظهور الإعلانات في التطبيق",
            icon: Icons.ads_click_rounded,
            color: Colors.blue,
            trailing: Switch(
              value: enableAds,
              onChanged: (v) => setState(() => enableAds = v),
              activeColor: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle("الإعدادات المالية"),
          const SizedBox(height: 12),
          _buildSettingCard(
            title: "عمولة التطبيق (%)",
            subtitle: "نسبة المنصة من كل عملية بيع ناجحة",
            icon: Icons.monetization_on_rounded,
            color: Colors.green,
            trailing: Container(
              width: 60,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "% $serviceCommission",
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("تم حفظ الإعدادات وتعميمها على المنصة ✅")),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            child: const Text("حفظ التغييرات", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
    );
  }

  Widget _buildSettingCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Widget trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}
