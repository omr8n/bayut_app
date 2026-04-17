import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/report_entity.dart';
import '../repositories/report_repository.dart';

class SendReportUseCase {
  final ReportRepository repository;

  SendReportUseCase(this.repository);

  Future<Either<Failure, void>> call(ReportEntity report) async {
    return await repository.sendReport(report);
  }
}
