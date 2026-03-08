import 'package:equatable/equatable.dart';
import '../../../../core/enums/property_enums.dart';

class PropertyEntity extends Equatable {
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
  final List<String> images; // للحفاظ على التوافق القديم
  final List<String> media; // للصور والفيديوهات الجديدة
  final List<String> facilities;
  final String governorate;
  final String city;
  final String location;
  final String phone;
  final String whatsapp;

  // بيانات البائع
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

  const PropertyEntity({
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
    required this.media,
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
  PropertyEntity copyWith({
    String? id,
    String? title,
    String? description,
    PropertyType? type,
    ListingType? listingType,
    double? price,
    String? currency,
    double? area,
    DateTime? createdAt,
    int? views,
    bool? isFeatured,
    List<String>? images,
    List<String>? media,
    List<String>? facilities,
    String? governorate,
    String? city,
    String? location,
    String? phone,
    String? whatsapp,
    String? sellerName,
    String? sellerImage,
    String? sellerJoinDate,
    double? sellerRating,
    int? buildingAge,
    String? finishType,
    String? ownershipType,
    String? direction,
    bool? isLicensed,
    bool? hasInstallment,
    double? downPayment,
    double? monthlyInstallment,
    int? installmentDuration,
    String? installmentNotes,
    int? totalRooms,
    int? bedrooms,
    int? bathrooms,
    int? floorNumber,
    int? totalFloors,
    String? heatingType,
    String? landType,
    int? frontagesCount,
    double? streetWidth,
    String? farmType,
    String? irrigationType,
    String? crops,
    double? frontageWidth,
    String? shopLocation,
    String? commercialActivity,
    String? poolType,
    String? poolSize,
    int? examinationRooms,
    String? medicalEquipment,
    double? warehouseHeight,
    String? warehouseFloorType,
    int? hallCapacity,
    String? workshopType,
    double? workshopHeight,
  }) {
    return PropertyEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      listingType: listingType ?? this.listingType,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      area: area ?? this.area,
      createdAt: createdAt ?? this.createdAt,
      views: views ?? this.views,
      isFeatured: isFeatured ?? this.isFeatured,
      images: images ?? this.images,
      media: media ?? this.media,
      facilities: facilities ?? this.facilities,
      governorate: governorate ?? this.governorate,
      city: city ?? this.city,
      location: location ?? this.location,
      phone: phone ?? this.phone,
      whatsapp: whatsapp ?? this.whatsapp,
      sellerName: sellerName ?? this.sellerName,
      sellerImage: sellerImage ?? this.sellerImage,
      sellerJoinDate: sellerJoinDate ?? this.sellerJoinDate,
      sellerRating: sellerRating ?? this.sellerRating,
      buildingAge: buildingAge ?? this.buildingAge,
      finishType: finishType ?? this.finishType,
      ownershipType: ownershipType ?? this.ownershipType,
      direction: direction ?? this.direction,
      isLicensed: isLicensed ?? this.isLicensed,
      hasInstallment: hasInstallment ?? this.hasInstallment,
      downPayment: downPayment ?? this.downPayment,
      monthlyInstallment: monthlyInstallment ?? this.monthlyInstallment,
      installmentDuration: installmentDuration ?? this.installmentDuration,
      installmentNotes: installmentNotes ?? this.installmentNotes,
      totalRooms: totalRooms ?? this.totalRooms,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      floorNumber: floorNumber ?? this.floorNumber,
      totalFloors: totalFloors ?? this.totalFloors,
      heatingType: heatingType ?? this.heatingType,
      landType: landType ?? this.landType,
      frontagesCount: frontagesCount ?? this.frontagesCount,
      streetWidth: streetWidth ?? this.streetWidth,
      farmType: farmType ?? this.farmType,
      irrigationType: irrigationType ?? this.irrigationType,
      crops: crops ?? this.crops,
      frontageWidth: frontageWidth ?? this.frontageWidth,
      shopLocation: shopLocation ?? this.shopLocation,
      commercialActivity: commercialActivity ?? this.commercialActivity,
      poolType: poolType ?? this.poolType,
      poolSize: poolSize ?? this.poolSize,
      examinationRooms: examinationRooms ?? this.examinationRooms,
      medicalEquipment: medicalEquipment ?? this.medicalEquipment,
      warehouseHeight: warehouseHeight ?? this.warehouseHeight,
      warehouseFloorType: warehouseFloorType ?? this.warehouseFloorType,
      hallCapacity: hallCapacity ?? this.hallCapacity,
      workshopType: workshopType ?? this.workshopType,
      workshopHeight: workshopHeight ?? this.workshopHeight,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    type,
    listingType,
    price,
    area,
    city,
    phone,
    media,
    images,
  ];
}
