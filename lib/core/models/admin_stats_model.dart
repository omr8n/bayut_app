import 'package:equatable/equatable.dart';

class AdminStats extends Equatable {
  final int totalUsers;
  final int totalProperties;
  final int totalReports;
  final int pendingReports;
  final int propertiesForSale;
  final int propertiesForRent;
  final int featuredProperties;
  
  // إحصائيات زمنية
  final List<ChartDataPoint> userGrowth; // نمو المستخدمين
  final List<ChartDataPoint> propertyGrowth; // العقارات المضافة
  final List<ChartDataPoint> salesGrowth; // العقارات المباعة
  final List<ChartDataPoint> rentGrowth; // العقارات المؤجرة
  
  // إحصائيات يومية/أسبوعية/سنوية (ملخصات)
  final DailySummary daily;
  final WeeklySummary weekly;
  final YearlySummary yearly;

  // إحصائيات التوزيع
  final Map<String, int> propertiesByType;
  final Map<String, int> propertiesByCity;
  final Map<String, int> propertiesByStatus;
  final Map<String, int> usersByRole;

  const AdminStats({
    required this.totalUsers,
    required this.totalProperties,
    required this.totalReports,
    required this.pendingReports,
    required this.propertiesForSale,
    required this.propertiesForRent,
    required this.featuredProperties,
    required this.userGrowth,
    required this.propertyGrowth,
    required this.salesGrowth,
    required this.rentGrowth,
    required this.daily,
    required this.weekly,
    required this.yearly,
    required this.propertiesByType,
    required this.propertiesByCity,
    required this.propertiesByStatus,
    required this.usersByRole,
  });

  @override
  List<Object?> get props => [
        totalUsers,
        totalProperties,
        totalReports,
        pendingReports,
        propertiesForSale,
        propertiesForRent,
        featuredProperties,
        userGrowth,
        propertyGrowth,
        salesGrowth,
        rentGrowth,
        daily,
        weekly,
        yearly,
        propertiesByType,
        propertiesByCity,
        propertiesByStatus,
        usersByRole,
      ];
}

// نقطة بيانات للرسم البياني
class ChartDataPoint extends Equatable {
  final String label; // اليوم أو الشهر
  final double value;

  const ChartDataPoint(this.label, this.value);

  @override
  List<Object?> get props => [label, value];
}

class DailySummary extends Equatable {
  final int newUsers;
  final int newProperties;
  final int soldProperties;
  final int rentedProperties;

  const DailySummary({required this.newUsers, required this.newProperties, required this.soldProperties, required this.rentedProperties});

  @override
  List<Object?> get props => [newUsers, newProperties, soldProperties, rentedProperties];
}

class WeeklySummary extends Equatable {
  final int newUsers;
  final int newProperties;
  final int soldProperties;
  final int rentedProperties;

  const WeeklySummary({required this.newUsers, required this.newProperties, required this.soldProperties, required this.rentedProperties});

  @override
  List<Object?> get props => [newUsers, newProperties, soldProperties, rentedProperties];
}

class YearlySummary extends Equatable {
  final int totalUsers;
  final int totalProperties;
  final double totalRevenue; // مثال: إذا كان هناك عمولات

  const YearlySummary({required this.totalUsers, required this.totalProperties, required this.totalRevenue});

  @override
  List<Object?> get props => [totalUsers, totalProperties, totalRevenue];
}
