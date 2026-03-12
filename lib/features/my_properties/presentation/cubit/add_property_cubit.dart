import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/repos/media_repo/media_repo.dart';
import '../../domain/entities/add_property_params.dart';
import '../../domain/entities/property_entity.dart';
import '../../domain/repos/add_property_repo.dart';
import 'add_property_state.dart';

class AddPropertyCubit extends Cubit<AddPropertyState> {
  final MediaRepo mediaRepo;
  final AddPropertyRepo addPropertiesRepo;

  AddPropertyCubit({required this.mediaRepo, required this.addPropertiesRepo})
    : super(AddPropertyInitial());

  final Map<int, bool> _activeUploads = {};

  Future<void> submitProperty(AddPropertyParams params) async {
    final int notificationId = Random().nextInt(100000);
    _activeUploads[notificationId] = true;

    // 🔥 الأهم: نرسل Success فوراً لكي يقوم الـ Listener بعمل pop
    emit(AddPropertySuccess()); 
    
    // 🔥 تصفير الحالة فوراً لكي لا تظهر شاشة انتظار عند الدخول مرة أخرى
    emit(AddPropertyInitial());

    _showProgressNotification(notificationId, params.title, 0, params.mediaFiles.length);
    
    // بدء المعالجة بدون await لكي لا ينتظر الكيوبيت انتهاء الرفع
    _processPropertyUpload(notificationId, params);
  }

  Future<void> editProperty({
    required AddPropertyParams params,
    required PropertyEntity originalProperty,
  }) async {
    final int notificationId = Random().nextInt(100000);
    _activeUploads[notificationId] = true;

    emit(AddPropertySuccess());
    emit(AddPropertyInitial());

    _showProgressNotification(notificationId, params.title, 0, params.mediaFiles.length);
    _processPropertyUpload(notificationId, params, existingId: originalProperty.id);
  }

  // --- بقية الدوال (المعالجة والستارة) تبقى كما هي بدون أي تغيير ---
  Future<void> _processPropertyUpload(int id, AddPropertyParams params, {String? existingId}) async {
    List<String> uploadedUrls = [];
    bool hasError = false;
    String errorMsg = "";
    try {
      for (int i = 0; i < params.mediaFiles.length; i++) {
        _showProgressNotification(id, params.title, i + 1, params.mediaFiles.length);
        final result = await mediaRepo.uploadMedia(params.mediaFiles[i]);
        result.fold((failure) { hasError = true; errorMsg = failure.message; }, (url) => uploadedUrls.add(url));
        if (hasError) break;
      }
      if (hasError) {
        _showErrorNotification(id, params.title, errorMsg);
      } else {
        final finalProperty = _mapParamsToEntity(params, uploadedUrls, id: existingId);
        final result = await addPropertiesRepo.addProperty(finalProperty);
        result.fold((failure) => _showErrorNotification(id, params.title, failure.message), (_) => _showSuccessNotification(id, params.title));
      }
    } catch (e) {
      _showErrorNotification(id, params.title, "حدث خطأ غير متوقع");
    } finally {
      _activeUploads.remove(id);
    }
  }

  void _showProgressNotification(int id, String title, int current, int total) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id, channelKey: 'upload_channel', title: 'جاري رفع عقار: $title',
        body: 'رفع الملف $current من $total...', category: NotificationCategory.Progress,
        notificationLayout: NotificationLayout.ProgressBar, progress: total > 0 ? (current / total) * 100 : 0, locked: true,
      ),
    );
  }

  void _showSuccessNotification(int id, String title) {
    AwesomeNotifications().createNotification(content: NotificationContent(id: id, channelKey: 'upload_channel', title: 'تم الرفع بنجاح! ✅', body: 'تمت العملية لـ ($title) بنجاح.'));
  }

  void _showErrorNotification(int id, String title, String error) {
    AwesomeNotifications().createNotification(content: NotificationContent(id: id, channelKey: 'upload_channel', title: 'فشل الرفع! ❌', body: 'خطأ في ($title): $error'));
  }

  PropertyEntity _mapParamsToEntity(AddPropertyParams params, List<String> urls, {String? id}) {
    return PropertyEntity(
      id: id ?? const Uuid().v4(), title: params.title, description: params.description, type: params.type,
      listingType: params.listingType, price: params.price, currency: params.currency, area: params.area,
      createdAt: DateTime.now(), media: urls, images: urls, facilities: params.facilities,
      governorate: params.governorate, city: params.city, location: params.location,
      phone: params.phone, whatsapp: params.whatsapp, sellerName: "المعلن",
      buildingAge: params.buildingAge, finishType: params.finishType, ownershipType: params.ownershipType,
      direction: params.direction, isLicensed: params.isLicensed, hasInstallment: params.hasInstallment,
      downPayment: params.downPayment, monthlyInstallment: params.monthlyInstallment,
      installmentDuration: params.installmentDuration, installmentNotes: params.installmentNotes,
      totalRooms: params.totalRooms, bedrooms: params.bedrooms, bathrooms: params.bathrooms,
      floorNumber: params.floorNumber, totalFloors: params.totalFloors, heatingType: params.heatingType,
      landType: params.landType, frontagesCount: params.frontagesCount, streetWidth: params.streetWidth,
      farmType: params.farmType, irrigationType: params.irrigationType, crops: params.crops,
      frontageWidth: params.frontageWidth, shopLocation: params.shopLocation, commercialActivity: params.commercialActivity,
      poolType: params.poolType, poolSize: params.poolSize, examinationRooms: params.examinationRooms,
      medicalEquipment: params.medicalEquipment, warehouseHeight: params.warehouseHeight,
      warehouseFloorType: params.warehouseFloorType, hallCapacity: params.hallCapacity,
      workshopType: params.workshopType, workshopHeight: params.workshopHeight,
    );
  }
}
