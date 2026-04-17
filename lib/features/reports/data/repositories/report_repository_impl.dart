import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/data_service.dart';
import '../../../../core/utils/backend_endpoint.dart';
import '../../domain/entities/report_entity.dart';
import '../../domain/repositories/report_repository.dart';
import '../models/report_model.dart';

class ReportRepositoryImpl implements ReportRepository {
  final DatabaseService databaseService;

  ReportRepositoryImpl(this.databaseService);

  @override
  Future<Either<Failure, void>> sendReport(ReportEntity report) async {
    try {
      // 🕵️ فحص ما إذا كان البلاغ موجوداً مسبقاً باستخدام DatabaseService
      final count = await databaseService.countDocuments(
        path: BackendEndpoint.addReport,
        whereField: 'propertyId',
        isEqualTo: report.propertyId,
      );

      // ملاحظة: هنا نحتاج لفحص مزدوج (نفس المستخدم ونفس العقار) 
      // إذا كان الـ DatabaseService يدعم فحصاً واحداً، يفضل جلب الوثائق والتحقق
      final existingReports = await databaseService.getCollectionDocuments(
        path: BackendEndpoint.addReport,
        whereField: 'propertyId',
        isEqualTo: report.propertyId,
      );

      final isAlreadyReported = existingReports.any((doc) => doc['reporterId'] == report.reporterId);

      if (isAlreadyReported) {
        return Left(ServerFailure('لقد قمت بالإبلاغ عن هذا العقار مسبقاً. فريقنا يراجع الأمر حالياً.'));
      }

      final reportModel = ReportModel.fromEntity(report);
      
      await databaseService.setData(
        collectionPath: BackendEndpoint.addReport,
        documentId: reportModel.id,
        data: reportModel.toJson(),
      );

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
