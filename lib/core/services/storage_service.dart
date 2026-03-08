import 'package:image_picker/image_picker.dart';

abstract class StorageService {
  /// Upload image or video to cloud
  /// [file] => XFile (image or video)
  /// [path] => folder name in the cloud
  /// [isVideo] => true if the file is a video
  Future<String> uploadFile({
    required XFile file,
    required String path,
    required bool isVideo,
  });
}
