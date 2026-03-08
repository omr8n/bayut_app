import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_graduation/core/repos/media_repo/media_repo.dart';

import 'package:test_graduation/features/my_properties/domain/repos/add_property_repo.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/add_property_params.dart';
import '../../domain/entities/property_entity.dart';

import 'add_property_state.dart';

class AddPropertyCubit extends Cubit<AddPropertyState> {
  final MediaRepo mediaRepo;
  final AddPropertyRepo addPropertiesRepo;

  AddPropertyCubit({required this.mediaRepo, required this.addPropertiesRepo})
    : super(AddPropertyInitial());

  /// وظيفة لإضافة عقار جديد
  Future<void> submitProperty(AddPropertyParams params) async {
    if (params.mediaFiles.isEmpty) {
      emit(
        const AddPropertyFailure("يرجى إضافة صور أو فيديوهات للعقار أولاً."),
      );
      return;
    }

    emit(const AddPropertyLoading(message: "جاري البدء في رفع الوسائط..."));

    // 1. رفع الوسائط الجديدة
    final uploadResult = await _uploadMediaFiles(params.mediaFiles);
    if (uploadResult.error != null) {
      emit(AddPropertyFailure(uploadResult.error!));
      return;
    }

    // 2. حفظ البيانات في Firestore
    emit(const AddPropertyLoading(message: "جاري حفظ بيانات العقار..."));

    final finalProperty = _mapParamsToEntity(
      params: params,
      mediaUrls: uploadResult.urls,
      id: const Uuid().v4(),
      createdAt: DateTime.now(),
    );

    final result = await addPropertiesRepo.addProperty(finalProperty);

    result.fold(
      (failure) => emit(AddPropertyFailure(failure.message)),
      (_) => emit(AddPropertySuccess()),
    );
  }

  /// وظيفة لتعديل عقار موجود
  Future<void> editProperty({
    required AddPropertyParams params,
    required PropertyEntity originalProperty,
  }) async {
    emit(const AddPropertyLoading(message: "جاري تحديث بيانات العقار..."));

    List<String> finalMediaUrls = List.from(originalProperty.media);

    // 1. رفع الوسائط الجديدة إذا وجدت
    if (params.mediaFiles.isNotEmpty) {
      emit(const AddPropertyLoading(message: "جاري رفع الوسائط الجديدة..."));
      final uploadResult = await _uploadMediaFiles(params.mediaFiles);

      if (uploadResult.error != null) {
        emit(AddPropertyFailure(uploadResult.error!));
        return;
      }
      finalMediaUrls.addAll(uploadResult.urls);
    }

    // 2. تحديث البيانات في Firestore
    emit(const AddPropertyLoading(message: "جاري حفظ التعديلات..."));

    final updatedProperty = _mapParamsToEntity(
      params: params,
      mediaUrls: finalMediaUrls,
      id: originalProperty.id,
      createdAt: originalProperty.createdAt,
      views: originalProperty.views,
    );

    final result = await addPropertiesRepo.addProperty(updatedProperty);

    result.fold(
      (failure) => emit(AddPropertyFailure(failure.message)),
      (_) => emit(AddPropertySuccess()),
    );
  }

  // --- مساعدات (Helpers) لمنع تكرار الكود ولضمان النظافة ---

  /// وظيفة داخلية لرفع قائمة من الملفات
  Future<({List<String> urls, String? error})> _uploadMediaFiles(
    List<XFile> mediaFiles,
  ) async {
    List<String> urls = [];
    String? errorMsg;

    for (int i = 0; i < mediaFiles.length; i++) {
      emit(
        AddPropertyLoading(
          message: "جاري رفع الملف (${i + 1} من ${mediaFiles.length})...",
        ),
      );

      final result = await mediaRepo.uploadMedia(mediaFiles[i]);

      result.fold(
        (failure) => errorMsg = failure.message,
        (url) => urls.add(url),
      );

      if (errorMsg != null) break;
    }

    if (errorMsg != null) {
      return (urls: <String>[], error: errorMsg);
    }

    return (urls: urls, error: null);
  }

  /// تحويل الـ Params إلى Entity نهائي
  PropertyEntity _mapParamsToEntity({
    required AddPropertyParams params,
    required List<String> mediaUrls,
    required String id,
    required DateTime createdAt,
    int views = 0,
  }) {
    return PropertyEntity(
      id: id,
      title: params.title,
      description: params.description,
      type: params.type,
      listingType: params.listingType,
      price: params.price,
      currency: params.currency,
      area: params.area,
      createdAt: createdAt,
      views: views,
      isFeatured: params.isFeatured,
      media: mediaUrls,
      images: mediaUrls,
      facilities: params.facilities,
      governorate: params.governorate,
      city: params.city,
      location: params.location,
      phone: params.phone,
      whatsapp: params.whatsapp,
      sellerName: "المعلن",
      sellerJoinDate: "عضو جديد",
      sellerRating: 5.0,
      buildingAge: params.buildingAge,
      finishType: params.finishType,
      ownershipType: params.ownershipType,
      direction: params.direction,
      isLicensed: params.isLicensed,
      hasInstallment: params.hasInstallment,
      downPayment: params.downPayment,
      monthlyInstallment: params.monthlyInstallment,
      installmentDuration: params.installmentDuration,
      installmentNotes: params.installmentNotes,
      totalRooms: params.totalRooms,
      bedrooms: params.bedrooms,
      bathrooms: params.bathrooms,
      floorNumber: params.floorNumber,
      totalFloors: params.totalFloors,
      heatingType: params.heatingType,
      landType: params.landType,
      frontagesCount: params.frontagesCount,
      streetWidth: params.streetWidth,
      farmType: params.farmType,
      irrigationType: params.irrigationType,
      crops: params.crops,
      frontageWidth: params.frontageWidth,
      shopLocation: params.shopLocation,
      commercialActivity: params.commercialActivity,
      poolType: params.poolType,
      poolSize: params.poolSize,
      examinationRooms: params.examinationRooms,
      medicalEquipment: params.medicalEquipment,
      warehouseHeight: params.warehouseHeight,
      warehouseFloorType: params.warehouseFloorType,
      hallCapacity: params.hallCapacity,
      workshopType: params.workshopType,
      workshopHeight: params.workshopHeight,
    );
  }

  void reset() {
    emit(AddPropertyInitial());
  }
}
