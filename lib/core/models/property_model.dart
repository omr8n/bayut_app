import 'package:equatable/equatable.dart';

class Property extends Equatable {
  final String id;
  final String title;
  final String description;
  final PropertyType type;
  final ListingType listingType;
  final double price;
  final String currency;
  final double area;
  final DateTime createdAt;
  final int views;
  final bool isFeatured;
  final List<String> images;
  final List<String> facilities;
  final String governorate;
  final String city;
  final String location;
  final String phone;
  final String whatsapp;

  // بيانات البائع الجديدة
  final String sellerName;
  final String? sellerImage;
  final String sellerJoinDate;
  final double sellerRating;

  // الحقول الاختيارية الأخرى
  final int? buildingAge;
  final String? finishType;
  final String? ownershipType;
  final String? direction;
  final bool isLicensed;
  final bool hasInstallment;
  final double? downPayment;
  final double? monthlyInstallment;
  final int? installmentDuration;
  final String? installmentNotes;
  final int? totalRooms;
  final int? bedrooms;
  final int? bathrooms;
  final int? floorNumber;
  final int? totalFloors;
  final String? heatingType;
  final String? landType;
  final int? frontagesCount;
  final double? streetWidth;
  final String? farmType;
  final String? irrigationType;
  final String? crops;
  final double? frontageWidth;
  final String? shopLocation;
  final String? commercialActivity;
  final String? poolType;
  final String? poolSize;
  final int? examinationRooms;
  final String? medicalEquipment;
  final double? warehouseHeight;
  final String? warehouseFloorType;
  final int? hallCapacity;
  final String? workshopType;
  final double? workshopHeight;

  const Property({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.listingType,
    required this.price,
    required this.currency,
    required this.area,
    required this.createdAt,
    this.views = 0,
    this.isFeatured = false,
    required this.images,
    required this.facilities,
    required this.governorate,
    required this.city,
    required this.location,
    required this.phone,
    required this.whatsapp,
    required this.sellerName,
    this.sellerImage,
    this.sellerJoinDate = 'عضو منذ سنة',
    this.sellerRating = 4.5,
    this.buildingAge,
    this.finishType,
    this.ownershipType,
    this.direction,
    this.isLicensed = false,
    this.hasInstallment = false,
    this.downPayment,
    this.monthlyInstallment,
    this.installmentDuration,
    this.installmentNotes,
    this.totalRooms,
    this.bedrooms,
    this.bathrooms,
    this.floorNumber,
    this.totalFloors,
    this.heatingType,
    this.landType,
    this.frontagesCount,
    this.streetWidth,
    this.farmType,
    this.irrigationType,
    this.crops,
    this.frontageWidth,
    this.shopLocation,
    this.commercialActivity,
    this.poolType,
    this.poolSize,
    this.examinationRooms,
    this.medicalEquipment,
    this.warehouseHeight,
    this.warehouseFloorType,
    this.hallCapacity,
    this.workshopType,
    this.workshopHeight,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: PropertyType.values.firstWhere((e) => e.name == json['type']),
      listingType: ListingType.values.firstWhere((e) => e.name == json['listingType']),
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String,
      area: (json['area'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      views: json['views'] as int? ?? 0,
      isFeatured: json['isFeatured'] as bool? ?? false,
      images: List<String>.from(json['images'] as List),
      facilities: List<String>.from(json['facilities'] as List),
      governorate: json['governorate'] as String,
      city: json['city'] as String,
      location: json['location'] as String,
      phone: json['phone'] as String,
      whatsapp: json['whatsapp'] as String,
      sellerName: json['sellerName'] as String? ?? 'Mohammad',
      sellerImage: json['sellerImage'] as String?,
      sellerJoinDate: json['sellerJoinDate'] as String? ?? 'عضو منذ سنة',
      sellerRating: (json['sellerRating'] as num? ?? 4.5).toDouble(),
      buildingAge: json['buildingAge'] as int?,
      finishType: json['finishType'] as String?,
      ownershipType: json['ownershipType'] as String?,
      direction: json['direction'] as String?,
      isLicensed: json['isLicensed'] as bool? ?? false,
      hasInstallment: json['hasInstallment'] as bool? ?? false,
      downPayment: (json['downPayment'] as num?)?.toDouble(),
      monthlyInstallment: (json['monthlyInstallment'] as num?)?.toDouble(),
      installmentDuration: json['installmentDuration'] as int?,
      installmentNotes: json['installmentNotes'] as String?,
      totalRooms: json['totalRooms'] as int?,
      bedrooms: json['bedrooms'] as int?,
      bathrooms: json['bathrooms'] as int?,
      floorNumber: json['floorNumber'] as int?,
      totalFloors: json['totalFloors'] as int?,
      heatingType: json['heatingType'] as String?,
      landType: json['landType'] as String?,
      frontagesCount: json['frontagesCount'] as int?,
      streetWidth: (json['streetWidth'] as num?)?.toDouble(),
      farmType: json['farmType'] as String?,
      irrigationType: json['irrigationType'] as String?,
      crops: json['crops'] as String?,
      frontageWidth: (json['frontageWidth'] as num?)?.toDouble(),
      shopLocation: json['shopLocation'] as String?,
      commercialActivity: json['commercialActivity'] as String?,
      poolType: json['poolType'] as String?,
      poolSize: json['poolSize'] as String?,
      examinationRooms: json['examinationRooms'] as int?,
      medicalEquipment: json['medicalEquipment'] as String?,
      warehouseHeight: (json['warehouseHeight'] as num?)?.toDouble(),
      warehouseFloorType: json['warehouseFloorType'] as String?,
      hallCapacity: json['hallCapacity'] as int?,
      workshopType: json['workshopType'] as String?,
      workshopHeight: (json['workshopHeight'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.name,
      'listingType': listingType.name,
      'price': price,
      'currency': currency,
      'area': area,
      'createdAt': createdAt.toIso8601String(),
      'views': views,
      'isFeatured': isFeatured,
      'images': images,
      'facilities': facilities,
      'governorate': governorate,
      'city': city,
      'location': location,
      'phone': phone,
      'whatsapp': whatsapp,
      'sellerName': sellerName,
      'sellerImage': sellerImage,
      'sellerJoinDate': sellerJoinDate,
      'sellerRating': sellerRating,
      'buildingAge': buildingAge,
      'finishType': finishType,
      'ownershipType': ownershipType,
      'direction': direction,
      'isLicensed': isLicensed,
      'hasInstallment': hasInstallment,
      'downPayment': downPayment,
      'monthlyInstallment': monthlyInstallment,
      'installmentDuration': installmentDuration,
      'installmentNotes': installmentNotes,
      'totalRooms': totalRooms,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'floorNumber': floorNumber,
      'totalFloors': totalFloors,
      'heatingType': heatingType,
      'landType': landType,
      'frontagesCount': frontagesCount,
      'streetWidth': streetWidth,
      'farmType': farmType,
      'irrigationType': irrigationType,
      'crops': crops,
      'frontageWidth': frontageWidth,
      'shopLocation': shopLocation,
      'commercialActivity': commercialActivity,
      'poolType': poolType,
      'poolSize': poolSize,
      'examinationRooms': examinationRooms,
      'medicalEquipment': medicalEquipment,
      'warehouseHeight': warehouseHeight,
      'warehouseFloorType': warehouseFloorType,
      'hallCapacity': hallCapacity,
      'workshopType': workshopType,
      'workshopHeight': workshopHeight,
    };
  }

  @override
  List<Object?> get props => [id, title, type, listingType, price, area, city, phone];
}

enum PropertyType {
  buildings, housesAndApartments, underConstruction, villas, shops,
  mallShops, lands, farms, pools, clinics, warehouses, halls, offices, workshops
}

enum ListingType { sale, rent }

extension PropertyTypeExtension on PropertyType {
  String get arabicName {
    switch (this) {
      case PropertyType.buildings: return 'مباني';
      case PropertyType.housesAndApartments: return 'المنازل والشقق';
      case PropertyType.underConstruction: return 'منازل وشقق قيد الإنشاء';
      case PropertyType.villas: return 'الفيلات';
      case PropertyType.shops: return 'محلات';
      case PropertyType.mallShops: return 'محلات في مراكز تجارية';
      case PropertyType.lands: return 'أراضي';
      case PropertyType.farms: return 'مزارع';
      case PropertyType.pools: return 'مسابح';
      case PropertyType.clinics: return 'عيادات';
      case PropertyType.warehouses: return 'مستودعات';
      case PropertyType.halls: return 'صالات';
      case PropertyType.offices: return 'مكاتب';
      case PropertyType.workshops: return 'ورش';
    }
  }
}

extension ListingTypeExtension on ListingType {
  String get arabicName {
    switch (this) {
      case ListingType.sale: return 'للبيع';
      case ListingType.rent: return 'للإيجار';
    }
  }
}
