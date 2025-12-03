import 'package:equatable/equatable.dart';

// نموذج العقار
class Property extends Equatable {
  final String id;
  final String title;
  final String description;
  final PropertyType type; // شقة، فيلا، إلخ
  final ListingType listingType; // بيع أو إيجار
  final double price;
  final double area; // بالمتر المربع
  final int bedrooms;
  final int bathrooms;
  final String location;
  final String city;
  final List<String> images;
  final List<String> features; // المميزات (مسبح، حديقة، إلخ)
  final bool isFeatured; // عقار مميز
  final String agentName;
  final String agentPhone;
  final String agentEmail;
  final DateTime createdAt;
  final int views; // عدد المشاهدات

  const Property({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.listingType,
    required this.price,
    required this.area,
    required this.bedrooms,
    required this.bathrooms,
    required this.location,
    required this.city,
    required this.images,
    required this.features,
    this.isFeatured = false,
    required this.agentName,
    required this.agentPhone,
    required this.agentEmail,
    required this.createdAt,
    this.views = 0,
  });

  // من JSON (للتكامل مع Firebase لاحقاً)
  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: PropertyType.values.firstWhere(
        (e) => e.toString() == 'PropertyType.${json['type']}',
      ),
      listingType: ListingType.values.firstWhere(
        (e) => e.toString() == 'ListingType.${json['listingType']}',
      ),
      price: (json['price'] as num).toDouble(),
      area: (json['area'] as num).toDouble(),
      bedrooms: json['bedrooms'] as int,
      bathrooms: json['bathrooms'] as int,
      location: json['location'] as String,
      city: json['city'] as String,
      images: List<String>.from(json['images'] as List),
      features: List<String>.from(json['features'] as List),
      isFeatured: json['isFeatured'] as bool? ?? false,
      agentName: json['agentName'] as String,
      agentPhone: json['agentPhone'] as String,
      agentEmail: json['agentEmail'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      views: json['views'] as int? ?? 0,
    );
  }

  // إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.toString().split('.').last,
      'listingType': listingType.toString().split('.').last,
      'price': price,
      'area': area,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'location': location,
      'city': city,
      'images': images,
      'features': features,
      'isFeatured': isFeatured,
      'agentName': agentName,
      'agentPhone': agentPhone,
      'agentEmail': agentEmail,
      'createdAt': createdAt.toIso8601String(),
      'views': views,
    };
  }

  // نسخ مع تعديلات
  Property copyWith({
    String? id,
    String? title,
    String? description,
    PropertyType? type,
    ListingType? listingType,
    double? price,
    double? area,
    int? bedrooms,
    int? bathrooms,
    String? location,
    String? city,
    List<String>? images,
    List<String>? features,
    bool? isFeatured,
    String? agentName,
    String? agentPhone,
    String? agentEmail,
    DateTime? createdAt,
    int? views,
  }) {
    return Property(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      listingType: listingType ?? this.listingType,
      price: price ?? this.price,
      area: area ?? this.area,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      location: location ?? this.location,
      city: city ?? this.city,
      images: images ?? this.images,
      features: features ?? this.features,
      isFeatured: isFeatured ?? this.isFeatured,
      agentName: agentName ?? this.agentName,
      agentPhone: agentPhone ?? this.agentPhone,
      agentEmail: agentEmail ?? this.agentEmail,
      createdAt: createdAt ?? this.createdAt,
      views: views ?? this.views,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    type,
    listingType,
    price,
    area,
    bedrooms,
    bathrooms,
    location,
    city,
    images,
    features,
    isFeatured,
    agentName,
    agentPhone,
    agentEmail,
    createdAt,
    views,
  ];
}

// أنواع العقارات
enum PropertyType {
  apartment, // شقة
  villa, // فيلا
  office, // مكتب
  land, // أرض
  shop, // محل تجاري
  warehouse, // مستودع
}

// نوع الإعلان
enum ListingType {
  sale, // للبيع
  rent, // للإيجار
}

// Extension للحصول على النص العربي
extension PropertyTypeExtension on PropertyType {
  String get arabicName {
    switch (this) {
      case PropertyType.apartment:
        return 'شقة';
      case PropertyType.villa:
        return 'فيلا';
      case PropertyType.office:
        return 'مكتب';
      case PropertyType.land:
        return 'أرض';
      case PropertyType.shop:
        return 'محل تجاري';
      case PropertyType.warehouse:
        return 'مستودع';
    }
  }
}

extension ListingTypeExtension on ListingType {
  String get arabicName {
    switch (this) {
      case ListingType.sale:
        return 'للبيع';
      case ListingType.rent:
        return 'للإيجار';
    }
  }
}
