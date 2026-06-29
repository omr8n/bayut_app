// import 'dart:io';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' as p;
// import 'package:test_graduation/core/services/error_tracker_service.dart';

// class ImageOptimizerService {
//   /// ضغط الصورة قبل الرفع مع الحفاظ على الجودة البصرية
//   /// [targetWidth] العرض الأقصى للصورة (الافتراضي 1280 بكسل للتطبيقات الاحترافية)
//   /// [quality] جودة الضغط (80-85% تعطي أفضل توازن بين الحجم والجودة)
//   static Future<File?> compressImage(File file, {int targetWidth = 1280, int quality = 80}) async {
//     try {
//       final String dir = (await getTemporaryDirectory()).path;
//       final String targetPath = p.join(dir, "${DateTime.now().millisecondsSinceEpoch}_compressed.jpg");

//       final XFile? compressedXFile = await FlutterImageCompress.compressAndGetFile(
//         file.absolute.path,
//         targetPath,
//         quality: quality,
//         minWidth: targetWidth,
//         minHeight: (targetWidth * 0.75).toInt(), // الحفاظ على النسبة التقريبية 4:3
//         format: CompressFormat.jpeg,
//       );

//       if (compressedXFile != null) {
//         final File compressedFile = File(compressedXFile.path);

//         // التحقق من أن الملف الجديد أصغر فعلياً
//         final int originalSize = await file.length();
//         final int compressedSize = await compressedFile.length();

//         if (compressedSize < originalSize) {
//           ErrorTrackerService.logInfo("✅ Image compressed successfully: ${(originalSize - compressedSize) / 1024} KB saved.");
//           return compressedFile;
//         }
//       }
//       return file; // العودة للملف الأصلي إذا فشل الضغط أو لم يوفر مساحة
//     } catch (e, stackTrace) {
//       ErrorTrackerService.logError(e, stackTrace: stackTrace, message: "Failed to compress image");
//       return file;
//     }
//   }

//   /// ضغط مجموعة من الصور
//   static Future<List<File>> compressMultipleImages(List<File> files) async {
//     List<File> optimizedFiles = [];
//     for (var file in files) {
//       final compressed = await compressImage(file);
//       optimizedFiles.add(compressed ?? file);
//     }
//     return optimizedFiles;
//   }
// }
