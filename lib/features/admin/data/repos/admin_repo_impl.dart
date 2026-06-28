import 'package:dartz/dartz.dart';
import 'package:test_graduation/core/enums/property_enums.dart';
import 'package:test_graduation/core/errors/failures.dart';
import 'package:test_graduation/core/models/admin_stats_model.dart';
import 'package:test_graduation/core/models/property_model.dart';
import 'package:test_graduation/core/services/data_service.dart';
import 'package:test_graduation/core/utils/backend_endpoint.dart';
import 'package:test_graduation/features/admin/domain/repos/admin_repo.dart';
import 'package:test_graduation/features/auth/domain/entites/user_entity.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import 'package:test_graduation/features/auth/data/models/user_model.dart';
import 'package:test_graduation/features/reports/data/models/report_model.dart';
import 'package:test_graduation/features/reports/domain/entities/report_entity.dart';

class AdminRepoImpl implements AdminRepo {
  final DatabaseService _databaseService;

  AdminRepoImpl(this._databaseService);

  @override
  Future<Either<Failure, AdminStats>> getAdminStats({
    String timeFilter = 'week',
    DateTime? targetDate,
  }) async {
    try {
      final usersDocs = await _databaseService.getCollectionDocuments(
        path: BackendEndpoint.getUsersData,
      );
      final propertiesDocs = await _databaseService.getCollectionDocuments(
        path: BackendEndpoint.propertyCollection,
      );
      final reportsDocs = await _databaseService.getCollectionDocuments(
        path: BackendEndpoint.addReport,
      );

      final now = targetDate ?? DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);
      
      DateTime filterStart;
      switch (timeFilter) {
        case 'day':
          filterStart = todayStart;
          break;
        case 'month':
          filterStart = DateTime(now.year, now.month, 1);
          break;
        case 'year':
          filterStart = DateTime(now.year, 1, 1);
          break;
        case 'week':
        default:
          filterStart = now.subtract(const Duration(days: 7));
          break;
      }

      final users = usersDocs.map((d) => UserModel.fromJson(d)).toList();
      final properties = propertiesDocs
          .map((d) => PropertyModel.fromJson(d))
          .toList();
      final reports = reportsDocs.map((d) => ReportModel.fromJson(d)).toList();

      // --- Precise Time-based Statistics Calculation ---

      final int newUsersToday = users
          .where(
            (u) =>
                u.createdAt != null &&
                u.createdAt!.toDate().isAfter(todayStart),
          )
          .length;

      final int newPropsToday = properties
          .where((p) => p.createdAt.isAfter(todayStart))
          .length;

      final int soldToday = properties
          .where((p) => p.status == PropertyStatus.sold && p.createdAt.isAfter(todayStart))
          .length; 
      final int rentedToday = properties
          .where((p) => p.status == PropertyStatus.rented && p.createdAt.isAfter(todayStart))
          .length;

      // --- Distribution Statistics ---
      Map<String, int> propsByType = {};
      for (var p in properties) {
        propsByType[p.type.name] = (propsByType[p.type.name] ?? 0) + 1;
      }

      Map<String, int> propsByCity = {};
      for (var p in properties) {
        propsByCity[p.city] = (propsByCity[p.city] ?? 0) + 1;
      }

      Map<String, int> propsByStatus = {};
      for (var p in properties) {
        propsByStatus[p.status.name] = (propsByStatus[p.status.name] ?? 0) + 1;
      }

      Map<String, int> usersRoleMap = {};
      for (var u in users) {
        final role = u.role ?? 'user';
        usersRoleMap[role] = (usersRoleMap[role] ?? 0) + 1;
      }

      return Right(
        AdminStats(
          totalUsers: users.length,
          totalProperties: properties.length,
          totalReports: reports.length,
          pendingReports: reports
              .where((r) => r.status == ReportStatus.pending)
              .length,
          propertiesForSale: properties
              .where((p) => p.listingType == ListingType.sale)
              .length,
          propertiesForRent: properties
              .where((p) => p.listingType == ListingType.rent)
              .length,
          featuredProperties: properties.where((p) => p.isFeatured).length,
          pendingPremiumRequests: properties
              .where((p) => p.premiumStatus == PremiumStatus.pending)
              .length,
          pendingProperties: properties.where((p) => !p.isApproved).length, // Calculate unapproved properties

          // Dynamic Chart Data Points
          userGrowth: _generateStats(
            users.map((u) => u.createdAt?.toDate()).toList(),
            timeFilter,
          ),
          propertyGrowth: _generateStats(
            properties.map((p) => p.createdAt).toList(),
            timeFilter,
          ),
          salesGrowth: _generateStats(
            properties
                .where((p) => p.status == PropertyStatus.sold)
                .map((p) => p.createdAt)
                .toList(),
            timeFilter,
          ),
          rentGrowth: _generateStats(
            properties
                .where((p) => p.status == PropertyStatus.rented)
                .map((p) => p.createdAt)
                .toList(),
            timeFilter,
          ),

          daily: DailySummary(
            newUsers: newUsersToday,
            newProperties: newPropsToday,
            soldProperties: soldToday,
            rentedProperties: rentedToday,
          ),
          weekly: WeeklySummary(
            newUsers: users
                .where(
                  (u) =>
                      u.createdAt != null &&
                      u.createdAt!.toDate().isAfter(now.subtract(const Duration(days: 7))),
                )
                .length,
            newProperties: properties
                .where((p) => p.createdAt.isAfter(now.subtract(const Duration(days: 7))))
                .length,
            soldProperties: properties
                .where((p) => p.status == PropertyStatus.sold && p.createdAt.isAfter(now.subtract(const Duration(days: 7))))
                .length,
            rentedProperties: properties
                .where((p) => p.status == PropertyStatus.rented && p.createdAt.isAfter(now.subtract(const Duration(days: 7))))
                .length,
          ),
          yearly: YearlySummary(
            totalUsers: users.length,
            totalProperties: properties.length,
            totalRevenue: properties
                .where((p) => p.status == PropertyStatus.sold)
                .fold(0.0, (sum, p) => sum + p.price),
          ),
          propertiesByType: propsByType,
          propertiesByCity: propsByCity,
          propertiesByStatus: propsByStatus,
          usersByRole: usersRoleMap,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  List<ChartDataPoint> _generateStats(List<DateTime?> dates, String filter) {
    Map<String, double> counts = {};
    final now = DateTime.now();

    if (filter == 'day') {
      for (int i = 23; i >= 0; i--) {
        final hour = now.subtract(Duration(hours: i)).hour;
        counts["$hour:00"] = 0;
      }
      for (var date in dates) {
        if (date != null && date.day == now.day && date.month == now.month && date.year == now.year) {
          final label = "${date.hour}:00";
          if (counts.containsKey(label)) counts[label] = counts[label]! + 1;
        }
      }
    } else if (filter == 'month') {
      // Show all days of the current month
      final lastDay = DateTime(now.year, now.month + 1, 0).day;
      for (int i = 1; i <= lastDay; i++) {
        counts["$i"] = 0;
      }
      for (var date in dates) {
        if (date != null && date.month == now.month && date.year == now.year) {
          final label = "${date.day}";
          if (counts.containsKey(label)) counts[label] = counts[label]! + 1;
        }
      }
    } else if (filter == 'year') {
      // Months of the year
      for (int i = 1; i <= 12; i++) {
        counts["$i"] = 0;
      }
      for (var date in dates) {
        if (date != null && date.year == now.year) {
          final label = "${date.month}";
          if (counts.containsKey(label)) counts[label] = counts[label]! + 1;
        }
      }
    } else {
      // Week (Default)
      for (int i = 6; i >= 0; i--) {
        final date = now.subtract(Duration(days: i));
        final label = "${date.day}/${date.month}";
        counts[label] = 0;
      }
      for (var date in dates) {
        if (date == null) continue;
        final label = "${date.day}/${date.month}";
        if (counts.containsKey(label)) counts[label] = counts[label]! + 1;
      }
    }

    return counts.entries.map((e) => ChartDataPoint(e.key, e.value)).toList();
  }


  // --- Other functions (User & Property Management) ---
  @override
  Future<Either<Failure, List<UserEntity>>> getAllUsers() async {
    try {
      final docs = await _databaseService.getCollectionDocuments(
        path: BackendEndpoint.getUsersData,
      );
      return Right(docs.map((data) => UserModel.fromJson(data)).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getUserById(String uId) async {
    try {
      final data = await _databaseService.getData(
        path: BackendEndpoint.getUsersData,
        documentId: uId,
      );
      if (data == null) return Left(ServerFailure("User not found"));
      return Right(UserModel.fromJson(data));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> blockUser({
    required String uId,
    required bool block,
  }) async {
    try {
      await _databaseService.updateData(
        path: BackendEndpoint.updateUserData,
        documentId: uId,
        data: {
          'status': block ? 'banned' : 'active',
          'updatedAt': DateTime.now().toIso8601String(),
        },
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser({required String uId}) async {
    try {
      await _databaseService.deleteData(
        path: BackendEndpoint.getUsersData,
        documentId: uId,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserRole({
    required String uId,
    required String role,
  }) async {
    try {
      await _databaseService.updateData(
        path: BackendEndpoint.updateUserData,
        documentId: uId,
        data: {'role': role},
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateAdminNotes({
    required String uId,
    required String notes,
  }) async {
    try {
      await _databaseService.updateData(
        path: BackendEndpoint.updateUserData,
        documentId: uId,
        data: {'adminNotes': notes},
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PropertyEntity>>> getAllProperties() async {
    try {
      final docs = await _databaseService.getCollectionDocuments(
        path: BackendEndpoint.propertyCollection,
      );
      return Right(docs.map((data) => PropertyModel.fromJson(data)).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> togglePropertyApproval({
    required String propertyId,
    required bool isApproved,
  }) async {
    try {
      await _databaseService.updateData(
        path: BackendEndpoint.propertyCollection,
        documentId: propertyId,
        data: {'isApproved': isApproved},
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProperty({
    required String propertyId,
  }) async {
    try {
      await _databaseService.deleteData(
        path: BackendEndpoint.propertyCollection,
        documentId: propertyId,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> togglePropertyFeatured({
    required String propertyId,
    required bool isFeatured,
  }) async {
    try {
      await _databaseService.updateData(
        path: BackendEndpoint.propertyCollection,
        documentId: propertyId,
        data: {'isFeatured': isFeatured},
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ReportEntity>>> getAllReports() async {
    try {
      final docs = await _databaseService.getCollectionDocuments(
        path: BackendEndpoint.addReport,
      );
      return Right(
        docs
            .map((data) => ReportModel.fromJson(data as Map<String, dynamic>))
            .toList(),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateReportStatus({
    required String reportId,
    required String status,
    String? adminNote,
  }) async {
    try {
      await _databaseService.updateData(
        path: BackendEndpoint.addReport,
        documentId: reportId,
        data: {
          'status': status,
          if (adminNote != null) 'adminNote': adminNote,
          'updatedAt': DateTime.now().toIso8601String(),
        },
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendGlobalNotification({
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    return const Right(null);
  }
}
