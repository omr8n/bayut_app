import 'package:flutter/material.dart';
import 'package:test_graduation/core/utils/colors.dart';

class TermsView extends StatelessWidget {
  const TermsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('شروط الاستخدام'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text(
            'مرحباً بك في تطبيق البيت السوري. باستخدامك للتطبيق، فإنك توافق على الشروط والأحكام التالية:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.right,
          ),
          SizedBox(height: 20),
          TermItem(
            title: '1. صحة المعلومات',
            content: 'يتحمل المستخدم كامل المسؤولية عن صحة ودقة المعلومات التي يقدمها في الإعلانات، بما في ذلك الأسعار والمساحات والمواصفات. يمنع منعاً باتاً نشر أي معلومات مضللة أو غير حقيقية.',
          ),
          TermItem(
            title: '2. المحتوى الممنوع',
            content: 'يُمنع استخدام التطبيق لنشر أي محتوى غير قانوني أو مسيء أو ينتهك حقوق الملكية الفكرية. تحتفظ إدارة التطبيق بحقها في حذف أي إعلان مخالف دون سابق إنذار.',
          ),
          TermItem(
            title: '3. حدود المسؤولية',
            content: 'تطبيق البيت السوري هو منصة وسيطة لعرض العقارات، ولا نتحمل أي مسؤولية عن أي معاملات أو اتفاقيات تتم بين المستخدمين خارج المنصة. ننصح دائماً باتخاذ كافة الإجراءات القانونية اللازمة عند إتمام أي عملية بيع أو شراء.',
          ),
          TermItem(
            title: '4. الإبلاغ عن المخالفات',
            content: 'نحن نشجع المستخدمين على الإبلاغ عن أي إعلان أو مستخدم مخالف للشروط. سيتم مراجعة جميع البلاغات بسرية تامة واتخاذ الإجراء المناسب.',
          ),
          SizedBox(height: 20),
          Text(
            'تحتفظ إدارة التطبيق بحقها في تحديث هذه الشروط في أي وقت. آخر تحديث: 2024/07/26',
            style: TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class TermItem extends StatelessWidget {
  final String title;
  final String content;

  const TermItem({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: const TextStyle(fontSize: 15, height: 1.6, color: AppColors.textSecondary),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}
