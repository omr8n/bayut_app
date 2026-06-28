class AppConfigModel {
  final String appName;
  final String appVersion;
  final String contactEmail;
  final String contactPhone;
  final double featuredPropertyPrice;
  final int maxImagesPerProperty;
  final List<String> allowedCities;
  final List<String> allowedPropertyTypes;
  final bool requireAdminApproval;
  final bool maintenanceMode;
  final String termsOfService;
  final String privacyPolicy;

  AppConfigModel({
    required this.appName,
    required this.appVersion,
    required this.contactEmail,
    required this.contactPhone,
    required this.featuredPropertyPrice,
    required this.maxImagesPerProperty,
    required this.allowedCities,
    required this.allowedPropertyTypes,
    required this.requireAdminApproval,
    required this.maintenanceMode,
    required this.termsOfService,
    required this.privacyPolicy,
  });

  Map<String, dynamic> toJson() => {
        'appName': appName,
        'appVersion': appVersion,
        'contactEmail': contactEmail,
        'contactPhone': contactPhone,
        'featuredPropertyPrice': featuredPropertyPrice,
        'maxImagesPerProperty': maxImagesPerProperty,
        'allowedCities': allowedCities,
        'allowedPropertyTypes': allowedPropertyTypes,
        'requireAdminApproval': requireAdminApproval,
        'maintenanceMode': maintenanceMode,
        'termsOfService': termsOfService,
        'privacyPolicy': privacyPolicy,
      };

  factory AppConfigModel.fromJson(Map<String, dynamic> json) => AppConfigModel(
        appName: json['appName'] ?? 'بيوت سوريا',
        appVersion: json['appVersion'] ?? '1.0.0',
        contactEmail: json['contactEmail'] ?? '',
        contactPhone: json['contactPhone'] ?? '',
        featuredPropertyPrice: (json['featuredPropertyPrice'] as num?)?.toDouble() ?? 50.0,
        maxImagesPerProperty: json['maxImagesPerProperty'] ?? 10,
        allowedCities: List<String>.from(json['allowedCities'] ?? ['دمشق', 'حلب', 'حمص', 'اللاذقية', 'طرطوس', 'حماة']),
        allowedPropertyTypes: List<String>.from(json['allowedPropertyTypes'] ?? ['شقة', 'فيلا', 'مكتب', 'محل تجاري', 'أرض']),
        requireAdminApproval: json['requireAdminApproval'] ?? false,
        maintenanceMode: json['maintenanceMode'] ?? false,
        termsOfService: json['termsOfService'] ?? '',
        privacyPolicy: json['privacyPolicy'] ?? '',
      );

  AppConfigModel copyWith({
    String? appName,
    String? appVersion,
    String? contactEmail,
    String? contactPhone,
    double? featuredPropertyPrice,
    int? maxImagesPerProperty,
    List<String>? allowedCities,
    List<String>? allowedPropertyTypes,
    bool? requireAdminApproval,
    bool? maintenanceMode,
    String? termsOfService,
    String? privacyPolicy,
  }) {
    return AppConfigModel(
      appName: appName ?? this.appName,
      appVersion: appVersion ?? this.appVersion,
      contactEmail: contactEmail ?? this.contactEmail,
      contactPhone: contactPhone ?? this.contactPhone,
      featuredPropertyPrice: featuredPropertyPrice ?? this.featuredPropertyPrice,
      maxImagesPerProperty: maxImagesPerProperty ?? this.maxImagesPerProperty,
      allowedCities: allowedCities ?? this.allowedCities,
      allowedPropertyTypes: allowedPropertyTypes ?? this.allowedPropertyTypes,
      requireAdminApproval: requireAdminApproval ?? this.requireAdminApproval,
      maintenanceMode: maintenanceMode ?? this.maintenanceMode,
      termsOfService: termsOfService ?? this.termsOfService,
      privacyPolicy: privacyPolicy ?? this.privacyPolicy,
    );
  }
}
