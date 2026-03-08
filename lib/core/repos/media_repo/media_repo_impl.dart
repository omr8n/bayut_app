import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_graduation/core/errors/failures.dart';
import 'package:test_graduation/core/services/storage_service.dart';
import 'media_repo.dart';

class MediaRepoImpl implements MediaRepo {
  final StorageService storageService;

  MediaRepoImpl(this.storageService);

  @override
  Future<Either<Failure, String>> uploadMedia(XFile file) async {
    try {
      // 🔥 فحص دقيق هل الملف فيديو أم صورة (عبر الـ MimeType أو الامتداد)
      final String path = file.path.toLowerCase();
      final bool isVideo =
          file.mimeType?.startsWith('video') ??
          (path.endsWith('.mp4') ||
              path.endsWith('.mov') ||
              path.endsWith('.avi') ||
              path.endsWith('.mkv'));

      debugPrint('🚀 Starting upload: ${file.name}, isVideo: $isVideo');

      final url = await storageService.uploadFile(
        file: file,
        path: isVideo ? 'property_videos' : 'property_images',
        isVideo: isVideo,
      );

      log('✅ Upload successful: $url');
      return Right(url);
    } catch (e) {
      debugPrint("❌ Repo Upload Error: $e");
      return Left(ServerFailure('فشل رفع الوسائط، يرجى المحاولة مرة أخرى.'));
    }
  }
}
