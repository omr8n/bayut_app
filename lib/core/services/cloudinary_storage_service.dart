import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'storage_service.dart';

class CloudinaryStorageService implements StorageService {
  // تأكد من وضع اسم الـ Unsigned Preset الصحيح هنا
  static final CloudinaryPublic _cloudinary = CloudinaryPublic(
    'dumdnc2o9', // Cloud Name بتاعك صح مية بالمية
    'ml_default', // 🔥 لو إنت عملت Preset جديد، غير الاسم ده للاسم الجديد
    cache: false,
  );

  @override
  Future<String> uploadFile({
    required XFile file,
    required String path,
    required bool isVideo,
  }) async {
    try {
      // توليد اسم آمن
      final String safeFileName = 'file_${DateTime.now().millisecondsSinceEpoch}';

      // تحديد النوع
      final resourceType = isVideo
          ? CloudinaryResourceType.Video
          : CloudinaryResourceType.Image;

      CloudinaryResponse response;

      // الرفع المباشر
      if (kIsWeb) {
        final bytes = await file.readAsBytes();
        response = await _cloudinary.uploadFile(
          CloudinaryFile.fromBytesData(
            bytes,
            identifier: safeFileName,
            resourceType: resourceType,
          ),
        );
      } else {
        response = await _cloudinary.uploadFile(
          CloudinaryFile.fromFile(
            file.path,
            identifier: safeFileName,
            resourceType: resourceType,
          ),
        );
      }

      debugPrint("✅ تم الرفع بنجاح لـ Cloudinary: ${response.secureUrl}");
      return response.secureUrl;
    } catch (e) {
      debugPrint("❌ خطأ صريح من Cloudinary: $e");
      // لو لسه بيطلع 400، يبقى الـ Preset Name غلط أو مش Unsigned
      throw Exception('فشل الرفع: تأكد من إعدادات الـ Unsigned Preset في موقع Cloudinary');
    }
  }
}
