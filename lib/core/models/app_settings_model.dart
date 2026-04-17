import 'package:equatable/equatable.dart';

// إعدادات التطبيق
class AppSettings extends Equatable {
  final String appName;
  final String appVersion;
  final bool maintenanceMode; // وضع الصيانة
  final String supportEmail;
  final String supportPhone;
  final double featuredPropertyPrice; // سعر العقار المميز
  final int maxImagesPerProperty; // أقصى عدد صور للعقار
  final List<String> allowedCities; // المدن المسموحة
  final List<String> allowedPropertyTypes; // أنواع العقارات المسموحة
  final bool requireAdminApproval; // يتطلب موافقة الأدمن على العقارات الجديدة

  const AppSettings({
    required this.appName,
    required this.appVersion,
    required this.maintenanceMode,
    required this.supportEmail,
    required this.supportPhone,
    required this.featuredPropertyPrice,
    required this.maxImagesPerProperty,
    required this.allowedCities,
    required this.allowedPropertyTypes,
    required this.requireAdminApproval,
  });

  AppSettings copyWith({
    String? appName,
    String? appVersion,
    bool? maintenanceMode,
    String? supportEmail,
    String? supportPhone,
    double? featuredPropertyPrice,
    int? maxImagesPerProperty,
    List<String>? allowedCities,
    List<String>? allowedPropertyTypes,
    bool? requireAdminApproval,
  }) {
    return AppSettings(
      appName: appName ?? this.appName,
      appVersion: appVersion ?? this.appVersion,
      maintenanceMode: maintenanceMode ?? this.maintenanceMode,
      supportEmail: supportEmail ?? this.supportEmail,
      supportPhone: supportPhone ?? this.supportPhone,
      featuredPropertyPrice:
          featuredPropertyPrice ?? this.featuredPropertyPrice,
      maxImagesPerProperty: maxImagesPerProperty ?? this.maxImagesPerProperty,
      allowedCities: allowedCities ?? this.allowedCities,
      allowedPropertyTypes: allowedPropertyTypes ?? this.allowedPropertyTypes,
      requireAdminApproval: requireAdminApproval ?? this.requireAdminApproval,
    );
  }

  @override
  List<Object?> get props => [
    appName,
    appVersion,
    maintenanceMode,
    supportEmail,
    supportPhone,
    featuredPropertyPrice,
    maxImagesPerProperty,
    allowedCities,
    allowedPropertyTypes,
    requireAdminApproval,
  ];
}
