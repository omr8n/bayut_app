class AppConfigModel {
  final double featuredPropertyPrice;
  final String contactEmail;
  final String contactPhone;
  final String termsOfService;
  final String privacyPolicy;
  final bool maintenanceMode;

  AppConfigModel({
    required this.featuredPropertyPrice,
    required this.contactEmail,
    required this.contactPhone,
    required this.termsOfService,
    required this.privacyPolicy,
    required this.maintenanceMode,
  });

  Map<String, dynamic> toJson() => {
        'featuredPropertyPrice': featuredPropertyPrice,
        'contactEmail': contactEmail,
        'contactPhone': contactPhone,
        'termsOfService': termsOfService,
        'privacyPolicy': privacyPolicy,
        'maintenanceMode': maintenanceMode,
      };

  factory AppConfigModel.fromJson(Map<String, dynamic> json) => AppConfigModel(
        featuredPropertyPrice: (json['featuredPropertyPrice'] as num).toDouble(),
        contactEmail: json['contactEmail'] ?? '',
        contactPhone: json['contactPhone'] ?? '',
        termsOfService: json['termsOfService'] ?? '',
        privacyPolicy: json['privacyPolicy'] ?? '',
        maintenanceMode: json['maintenanceMode'] ?? false,
      );
}
