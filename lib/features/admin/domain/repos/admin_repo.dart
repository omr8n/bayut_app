import 'package:dartz/dartz.dart';
import 'package:test_graduation/core/errors/failures.dart';
import 'package:test_graduation/core/models/admin_stats_model.dart';
import 'package:test_graduation/features/auth/domain/entites/user_entity.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';

import 'package:test_graduation/features/reports/domain/entities/report_entity.dart';

abstract class AdminRepo {
  // Stats
  Future<Either<Failure, AdminStats>> getAdminStats({
    String timeFilter = 'week',
    DateTime? targetDate,
  });

  // User Management
  Future<Either<Failure, List<UserEntity>>> getAllUsers();
  Future<Either<Failure, void>> blockUser({required String uId, required bool block});
  Future<Either<Failure, void>> deleteUser({required String uId});
  Future<Either<Failure, void>> updateUserRole({required String uId, required String role});
  Future<Either<Failure, void>> updateAdminNotes({required String uId, required String notes});

  // Property Management
  Future<Either<Failure, List<PropertyEntity>>> getAllProperties();
  Future<Either<Failure, void>> togglePropertyApproval({required String propertyId, required bool isApproved});
  Future<Either<Failure, void>> deleteProperty({required String propertyId});
  Future<Either<Failure, void>> togglePropertyFeatured({required String propertyId, required bool isFeatured});

  // Reports Management
  Future<Either<Failure, List<ReportEntity>>> getAllReports();
  Future<Either<Failure, void>> updateReportStatus({required String reportId, required String status, String? adminNote});

  // Notifications
  Future<Either<Failure, void>> sendGlobalNotification({
    required String title,
    required String body,
    Map<String, dynamic>? data,
  });
}
