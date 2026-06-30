class AppConfigModel {
  final String appName;
  final String appVersion;
  final String contactEmail;
  final String contactPhone;
  final String whatsappNumber;
  final String facebookUrl;
  final String instagramUrl;
  final double weeklyFeaturedPrice;
  final double monthlyFeaturedPrice;
  final int freePropertyLimitPerDay;
  final double extraPropertyPrice;
  final int maxImagesPerProperty;
  final int maxVideosPerProperty;
  final String baseCurrency;
  final List<String> allowedCities;
  final List<String> allowedPropertyTypes;
  final bool maintenanceMode;
  final String termsOfService;
  final String privacyPolicy;

  AppConfigModel({
    required this.appName,
    required this.appVersion,
    required this.contactEmail,
    required this.contactPhone,
    required this.whatsappNumber,
    required this.facebookUrl,
    required this.instagramUrl,
    required this.weeklyFeaturedPrice,
    required this.monthlyFeaturedPrice,
    required this.freePropertyLimitPerDay,
    required this.extraPropertyPrice,
    required this.maxImagesPerProperty,
    required this.maxVideosPerProperty,
    required this.baseCurrency,
    required this.allowedCities,
    required this.allowedPropertyTypes,
    required this.maintenanceMode,
    required this.termsOfService,
    required this.privacyPolicy,
  });

  Map<String, dynamic> toJson() => {
        'appName': appName,
        'appVersion': appVersion,
        'contactEmail': contactEmail,
        'contactPhone': contactPhone,
        'whatsappNumber': whatsappNumber,
        'facebookUrl': facebookUrl,
        'instagramUrl': instagramUrl,
        'weeklyFeaturedPrice': weeklyFeaturedPrice,
        'monthlyFeaturedPrice': monthlyFeaturedPrice,
        'freePropertyLimitPerDay': freePropertyLimitPerDay,
        'extraPropertyPrice': extraPropertyPrice,
        'maxImagesPerProperty': maxImagesPerProperty,
        'maxVideosPerProperty': maxVideosPerProperty,
        'baseCurrency': baseCurrency,
        'allowedCities': allowedCities,
        'allowedPropertyTypes': allowedPropertyTypes,
        'maintenanceMode': maintenanceMode,
        'termsOfService': termsOfService,
        'privacyPolicy': privacyPolicy,
      };

  factory AppConfigModel.fromJson(Map<String, dynamic> json) => AppConfigModel(
        appName: json['appName'] ?? 'بيوت سوريا',
        appVersion: json['appVersion'] ?? '1.0.0',
        contactEmail: json['contactEmail'] ?? 'support@baytesy.com',
        contactPhone: json['contactPhone'] ?? '+963 935 922 621',
        whatsappNumber: json['whatsappNumber'] ?? '+963935922621',
        facebookUrl: json['facebookUrl'] ?? 'https://facebook.com/baytesy',
        instagramUrl: json['instagramUrl'] ?? 'https://instagram.com/baytesy',
        weeklyFeaturedPrice: (json['weeklyFeaturedPrice'] as num?)?.toDouble() ?? 5000.0,
        monthlyFeaturedPrice: (json['monthlyFeaturedPrice'] as num?)?.toDouble() ?? 15000.0,
        freePropertyLimitPerDay: json['freePropertyLimitPerDay'] ?? 3,
        extraPropertyPrice: (json['extraPropertyPrice'] as num?)?.toDouble() ?? 5000.0,
        maxImagesPerProperty: json['maxImagesPerProperty'] ?? 10,
        maxVideosPerProperty: json['maxVideosPerProperty'] ?? 1,
        baseCurrency: json['baseCurrency'] ?? 'ل.س',
        allowedCities: List<String>.from(json['allowedCities'] ?? ['دمشق', 'حلب', 'حمص', 'اللاذقية', 'طرطوس', 'حماة']),
        allowedPropertyTypes: List<String>.from(json['allowedPropertyTypes'] ?? ['شقة', 'فيلا', 'مكتب', 'محل تجاري', 'أرض']),
        maintenanceMode: json['maintenanceMode'] ?? false,
        termsOfService: json['termsOfService'] ?? '',
        privacyPolicy: json['privacyPolicy'] ?? '',
      );

  AppConfigModel copyWith({
    String? appName,
    String? appVersion,
    String? contactEmail,
    String? contactPhone,
    String? whatsappNumber,
    String? facebookUrl,
    String? instagramUrl,
    double? weeklyFeaturedPrice,
    double? monthlyFeaturedPrice,
    int? freePropertyLimitPerDay,
    double? extraPropertyPrice,
    int? maxImagesPerProperty,
    int? maxVideosPerProperty,
    String? baseCurrency,
    List<String>? allowedCities,
    List<String>? allowedPropertyTypes,
    bool? maintenanceMode,
    String? termsOfService,
    String? privacyPolicy,
  }) {
    return AppConfigModel(
      appName: appName ?? this.appName,
      appVersion: appVersion ?? this.appVersion,
      contactEmail: contactEmail ?? this.contactEmail,
      contactPhone: contactPhone ?? this.contactPhone,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      facebookUrl: facebookUrl ?? this.facebookUrl,
      instagramUrl: instagramUrl ?? this.instagramUrl,
      weeklyFeaturedPrice: weeklyFeaturedPrice ?? this.weeklyFeaturedPrice,
      monthlyFeaturedPrice: monthlyFeaturedPrice ?? this.monthlyFeaturedPrice,
      freePropertyLimitPerDay: freePropertyLimitPerDay ?? this.freePropertyLimitPerDay,
      extraPropertyPrice: extraPropertyPrice ?? this.extraPropertyPrice,
      maxImagesPerProperty: maxImagesPerProperty ?? this.maxImagesPerProperty,
      maxVideosPerProperty: maxVideosPerProperty ?? this.maxVideosPerProperty,
      baseCurrency: baseCurrency ?? this.baseCurrency,
      allowedCities: allowedCities ?? this.allowedCities,
      allowedPropertyTypes: allowedPropertyTypes ?? this.allowedPropertyTypes,
      maintenanceMode: maintenanceMode ?? this.maintenanceMode,
      termsOfService: termsOfService ?? this.termsOfService,
      privacyPolicy: privacyPolicy ?? this.privacyPolicy,
    );
  }
}
