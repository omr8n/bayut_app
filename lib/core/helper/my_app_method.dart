import 'package:flutter/material.dart';
import 'package:test_graduation/core/utils/app_images.dart';
import 'package:test_graduation/features/profile/presentation/views/widgets/add_rating_dialog.dart';

class MyAppMethods {
  static void showAddRatingDialog(
    BuildContext context, {
    required String sellerId,
  }) {
    showDialog(
      context: context,
      builder: (context) => AddRatingDialog(sellerId: sellerId),
    );
  }

  static Future<void> showErrorORWarningDialog({
    required BuildContext context,
    required String subtitle,
    required VoidCallback fct,
    bool isError = true,
  }) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          // 🔥 الحل: تحديد قيود العرض والارتفاع لمنع الـ Infinite Size
          content: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.8,
              maxHeight: MediaQuery.of(context).size.height * 0.4,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  Image.asset(Assets.imagesWarning, height: 60, width: 60),
                  const SizedBox(height: 16.0),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  const SizedBox(height: 24.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (!isError)
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("إلغاء", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                        ),
                      TextButton(
                        onPressed: () {
                          fct();
                          Navigator.pop(context);
                        },
                        child: const Text("موافق", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Future<void> imagePickerDialog({
    required BuildContext context,
    required VoidCallback cameraFCT,
    required VoidCallback galleryFCT,
    required VoidCallback removeFCT,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text("اختر عملية")),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                TextButton.icon(
                  onPressed: () {
                    cameraFCT();
                    if (Navigator.canPop(context)) Navigator.pop(context);
                  },
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("الكاميرا"),
                ),
                TextButton.icon(
                  onPressed: () {
                    galleryFCT();
                    if (Navigator.canPop(context)) Navigator.pop(context);
                  },
                  icon: const Icon(Icons.image),
                  label: const Text("المعرض"),
                ),
                TextButton.icon(
                  onPressed: () {
                    removeFCT();
                    if (Navigator.canPop(context)) Navigator.pop(context);
                  },
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text("حذف الصورة", style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
