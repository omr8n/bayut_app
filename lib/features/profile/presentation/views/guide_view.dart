import 'package:flutter/material.dart';
import 'package:test_graduation/core/utils/colors.dart';

class GuideView extends StatelessWidget {
  const GuideView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('دليل استخدام التطبيق'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          GuideExpansionTile(
            icon: Icons.add_business_outlined,
            title: 'كيف يمكنني إضافة عقار جديد؟',
            content: 'من الشريط السفلي، اضغط على أيقونة “إضافة” (+) ثم املأ كافة الحقول المطلوبة مثل نوع العقار، السعر، المساحة، وارفع صوراً واضحة. كلما كانت التفاصيل أدق، زادت فرصة بيع أو تأجير عقارك بسرعة.',
            iconColor: Colors.blue,
          ),
          GuideExpansionTile(
            icon: Icons.search_outlined,
            title: 'كيف أستخدم الفلتر للبحث الدقيق؟',
            content: 'في صفحة البحث، اضغط على أيقونة الفلتر. يمكنك تحديد نوع العقار، المحافظة، نطاق السعر والمساحة، عدد الغرف، وغيرها من المواصفات للوصول إلى العقار الذي يناسبك تماماً.',
            iconColor: Colors.green,
          ),
          GuideExpansionTile(
            icon: Icons.star_outline,
            title: 'ما هي العقارات المميزة؟',
            content: 'هي إعلانات ممولة تظهر في أعلى الصفحة الرئيسية لزيادة فرصة مشاهدتها. يمكنك تمييز إعلانك عند إضافته عبر تفعيل خيار “تمييز العقار” (قد تكون هناك رسوم إضافية لهذه الخدمة).',
            iconColor: Colors.amber,
          ),
          GuideExpansionTile(
            icon: Icons.report_outlined,
            title: 'كيف يمكنني الإبلاغ عن إعلان مخالف؟',
            content: 'في صفحة تفاصيل العقار، اضغط على أيقونة العلم (إبلاغ) في الشريط العلوي، ثم اختر سبب الإبلاغ مع إضافة تفاصيل إذا لزم الأمر. فريقنا سيقوم بمراجعة البلاغ واتخاذ الإجراء المناسب.',
            iconColor: Colors.red,
          ),
        ],
      ),
    );
  }
}

class GuideExpansionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  final Color iconColor;

  const GuideExpansionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.content,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ExpansionTile(
        leading: Icon(icon, color: iconColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        children: [
          Text(
            content,
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 14, height: 1.5, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
