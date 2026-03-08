import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import '../../errors/failures.dart';

abstract class MediaRepo {
  Future<Either<Failure, String>> uploadMedia(XFile file);
}
