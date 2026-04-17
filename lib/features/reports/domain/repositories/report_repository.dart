import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/report_entity.dart';

abstract class ReportRepository {
  Future<Either<Failure, void>> sendReport(ReportEntity report);
}
