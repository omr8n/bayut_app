// import 'package:test_graduation/core/models/admin_action_model.dart';
// import 'package:test_graduation/features/reports/domain/entities/report_entity.dart';
// import 'package:test_graduation/core/models/app_config_model.dart';

// class AdminMockData {
//   static final List<AdminActionModel> mockActions = [
//     AdminActionModel(
//       id: '1',
//       adminId: 'admin_1',
//       adminName: 'Omar Al-Ali',
//       actionType: 'BLOCK_USER',
//       targetId: 'user_123',
//       description: 'User blocked for violating laws',
//       createdAt: DateTime.now().subtract(const Duration(hours: 2)),
//     ),
//     AdminActionModel(
//       id: '2',
//       adminId: 'admin_1',
//       adminName: 'Omar Al-Ali',
//       actionType: 'DELETE_PROPERTY',
//       targetId: 'prop_456',
//       description: 'Property deleted due to inappropriate photos',
//       createdAt: DateTime.now().subtract(const Duration(hours: 5)),
//     ),
//     AdminActionModel(
//       id: '3',
//       adminId: 'admin_2',
//       adminName: 'Mohammad Yousef',
//       actionType: 'UPDATE_REPORT',
//       targetId: 'rep_789',
//       description: 'Report status changed to under review',
//       createdAt: DateTime.now().subtract(const Duration(days: 1)),
//     ),
//   ];

//   static final List<ReportEntity> mockReports = [
//     ReportEntity(
//       id: 'rep_1',
//       reporterId: 'user_1',
//       reporterName: 'Ahmad Mohammad',
//       reporterEmail: 'ahmad@example.com',
//       propertyId: 'prop_1',
//       propertyTitle: 'Luxury Apartment in Damascus',
//       reportedUserId: 'seller_1',
//       reportedUserName: 'Khaled Hassan',
//       reason: ReportReason.wrongInfo,
//       description: 'The area information provided is incorrect',
//       status: ReportStatus.pending,
//       createdAt: DateTime.now().subtract(const Duration(hours: 3)),
//     ),
//   ];

//   static final AppConfigModel mockConfig = AppConfigModel(
//     appName: 'Bayut Syria',
//     appVersion: '1.0.0',
//     contactEmail: 'support@bayut-syria.com',
//     contactPhone: '+963000000',
//     featuredPropertyPrice: 500.0,
//     maxImagesPerProperty: 10,
//     allowedCities: ['Damascus', 'Aleppo'],
//     allowedPropertyTypes: ['Apartment', 'Villa'],
//     requireAdminApproval: false,
//     maintenanceMode: false,
//     termsOfService: 'Terms of Service...',
//     privacyPolicy: 'Privacy Policy...',
//   );
// }
