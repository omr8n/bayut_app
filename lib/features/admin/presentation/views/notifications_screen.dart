import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإشعارات')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // ستتم إضافة منطق إنشاء الإشعار لاحقاً
          showDialog(
            context: context,
            builder: (_) => const _CreateNotificationDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5, // Placeholder – سيتم ربطها بالداتا لاحقاً
        itemBuilder: (context, index) {
          return _NotificationTile(
            title: 'عنوان إشعار تجريبي $index',
            body: 'هذا نص الإشعار، سيتم استبداله لاحقاً من Firestore.',
            date: 'قبل 3 ساعات',
            onDelete: () {
              // Placeholder – سيتم ربطه بمنطق الحذف
            },
          );
        },
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final String title;
  final String body;
  final String date;
  final VoidCallback onDelete;

  const _NotificationTile({
    required this.title,
    required this.body,
    required this.date,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(body),
            const SizedBox(height: 8),
            Text(
              date,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}

class _CreateNotificationDialog extends StatelessWidget {
  const _CreateNotificationDialog();

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();

    return AlertDialog(
      title: const Text('إنشاء إشعار جديد'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'العنوان'),
          ),
          TextField(
            controller: bodyController,
            decoration: const InputDecoration(labelText: 'المحتوى'),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: () {
            // سيتم إضافة منطق الإرسال لاحقاً
            Navigator.pop(context);
          },
          child: const Text('إرسال'),
        ),
      ],
    );
  }
}
