import 'package:test_graduation/core/data/mock_data.dart';
import 'package:test_graduation/core/models/admin_stats_model.dart';
import 'package:test_graduation/core/models/app_settings_model.dart';
import 'package:test_graduation/core/models/notification_model.dart';
import 'package:test_graduation/core/models/report_model.dart';
import 'package:test_graduation/core/models/user_model.dart';
import 'package:test_graduation/features/reports/domain/entities/report_entity.dart';

class AdminMockData {
  static final List<User> users = [
    User(
      id: 'user1',
      fullName: 'أحمد محمد',
      email: 'ahmed@example.com',
      phone: '+971501234567',
      userType: UserType.agent,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      favoriteProperties: ['1', '2'],
    ),
  ];

  static final List<Report> reports = [
    Report(
      id: 'report1',
      propertyId: '1',
      propertyTitle: 'شقة فاخرة في دبي مارينا',
      reporterId: 'user3',
      reporterName: 'خالد حسن',
      reporterEmail: 'khaled@example.com',
      reportedUserId: 'user1',
      reportedUserName: 'أحمد محمد',
      reason: ReportReason.wrongInfo,
      description: 'المعلومات المذكورة عن المساحة غير صحيحة',
      status: ReportStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
  ];

  static AdminStats get stats {
    return AdminStats(
      totalUsers: 150,
      totalProperties: 85,
      totalReports: 12,
      pendingReports: 4,
      propertiesForSale: 50,
      propertiesForRent: 35,
      featuredProperties: 10,
      userGrowth: const [
        ChartDataPoint('1/5', 10),
        ChartDataPoint('2/5', 15),
        ChartDataPoint('3/5', 8),
        ChartDataPoint('4/5', 20),
        ChartDataPoint('5/5', 25),
        ChartDataPoint('6/5', 18),
        ChartDataPoint('7/5', 30),
      ],
      propertyGrowth: const [
        ChartDataPoint('1/5', 5),
        ChartDataPoint('2/5', 8),
        ChartDataPoint('3/5', 12),
        ChartDataPoint('4/5', 7),
        ChartDataPoint('5/5', 15),
        ChartDataPoint('6/5', 10),
        ChartDataPoint('7/5', 20),
      ],
      salesGrowth: const [
        ChartDataPoint('1/5', 2),
        ChartDataPoint('2/5', 4),
        ChartDataPoint('3/5', 1),
        ChartDataPoint('4/5', 5),
        ChartDataPoint('5/5', 3),
        ChartDataPoint('6/5', 6),
        ChartDataPoint('7/5', 8),
      ],
      rentGrowth: const [
        ChartDataPoint('1/5', 3),
        ChartDataPoint('2/5', 2),
        ChartDataPoint('3/5', 5),
        ChartDataPoint('4/5', 4),
        ChartDataPoint('5/5', 6),
        ChartDataPoint('6/5', 5),
        ChartDataPoint('7/5', 7),
      ],
      daily: const DailySummary(
        newUsers: 5,
        newProperties: 3,
        soldProperties: 1,
        rentedProperties: 2,
      ),
      weekly: const WeeklySummary(
        newUsers: 35,
        newProperties: 20,
        soldProperties: 10,
        rentedProperties: 15,
      ),
      yearly: const YearlySummary(
        totalUsers: 150,
        totalProperties: 85,
        totalRevenue: 50000.0,
      ),
      propertiesByType: {},
      propertiesByCity: {},
      propertiesByStatus: {},
      usersByRole: {},
    );
  }

  static final List<AppNotification> notifications = [];

  static AppSettings settings = const AppSettings(
    appName: 'بيوت سوريا',
    appVersion: '1.0.0',
    maintenanceMode: false,
    supportEmail: 'support@bayut-syria.com',
    supportPhone: '+963000000',
    featuredPropertyPrice: 500.0,
    maxImagesPerProperty: 10,
    allowedCities: ['دمشق', 'حلب'],
    allowedPropertyTypes: ['شقة', 'فيلا'],
    requireAdminApproval: false,
  );
}
