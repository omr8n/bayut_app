import 'package:image_picker/image_picker.dart';
import '../../../../core/enums/property_enums.dart';

class AddPropertyParams {
  final String title;
  final String description;
  final PropertyType type;
  final ListingType listingType;
  final double price;
  final String currency;
  final double area;
  final String governorate;
  final String city;
  final String location;
  final String phone;
  final String whatsapp;
  final List<XFile> mediaFiles;
  final List<String> facilities;

  // الحقول الاختيارية
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
  final bool isFeatured;

  AddPropertyParams({
    required this.title,
    required this.description,
    required this.type,
    required this.listingType,
    required this.price,
    required this.currency,
    required this.area,
    required this.governorate,
    required this.city,
    required this.location,
    required this.phone,
    required this.whatsapp,
    required this.mediaFiles,
    required this.facilities,
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
    this.isFeatured = false,
  });
}
