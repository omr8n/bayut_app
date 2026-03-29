import 'dart:developer';
import 'dart:math' hide log;
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:test_graduation/core/helper/functions/get_user.dart';
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

    if (!isClosed) emit(AddPropertySuccess());
    if (!isClosed) emit(AddPropertyInitial());

    _showProgressNotification(
      notificationId,
      params.title,
      0,
      params.mediaFiles.length,
      isUpdate: false,
    );
    _processPropertyUpload(notificationId, params, isUpdate: false);
  }

  Future<void> editProperty({
    required AddPropertyParams params,
    required PropertyEntity originalProperty,
  }) async {
    final int notificationId = Random().nextInt(100000);
    _activeUploads[notificationId] = true;

    // 🔥 إصدار حالة التعديل بدلاً من النجاح العام
    if (!isClosed) emit(UpdatePropertySuccess());
    if (!isClosed) emit(AddPropertyInitial());

    _showProgressNotification(
      notificationId,
      params.title,
      0,
      params.mediaFiles.length,
      isUpdate: true,
    );
    _processPropertyUpload(
      notificationId,
      params,
      existingProperty: originalProperty,
      isUpdate: true,
    );
  }

  Future<void> _processPropertyUpload(
    int id,
    AddPropertyParams params, {
    PropertyEntity? existingProperty,
    required bool isUpdate,
  }) async {
    List<String> finalUrls =
        existingProperty?.media ?? []; // نبدأ بالصور الموجودة مسبقاً
    bool hasError = false;
    String errorMsg = "";

    try {
      // 🎯 رفع الملفات الجديدة فقط
      if (params.mediaFiles.isNotEmpty) {
        for (int i = 0; i < params.mediaFiles.length; i++) {
          _showProgressNotification(
            id,
            params.title,
            i + 1,
            params.mediaFiles.length,
            isUpdate: isUpdate,
          );
          final result = await mediaRepo.uploadMedia(params.mediaFiles[i]);

          result.fold(
            (failure) {
              hasError = true;
              errorMsg = failure.message;
            },
            (url) => finalUrls.add(url), // إضافة الروابط الجديدة للقائمة
          );
          if (hasError) break;
        }
      }

      if (hasError) {
        _showErrorNotification(id, params.title, errorMsg, isUpdate: isUpdate);
      } else {
        final user = await getUser();
        final finalProperty = _mapParamsToEntity(
          params,
          finalUrls, // القائمة النهائية المدمجة
          id: existingProperty?.id,
          user: user,
        );

        final result = await addPropertiesRepo.addProperty(finalProperty);
        result.fold(
          (failure) => _showErrorNotification(
            id,
            params.title,
            failure.message,
            isUpdate: isUpdate,
          ),
          (_) => _showSuccessNotification(id, params.title, isUpdate: isUpdate),
        );
      }
    } catch (e, stack) {
      log("🔥 Critical Error in Process: $e");
      _showErrorNotification(
        id,
        params.title,
        "فشل في معالجة البيانات: $e",
        isUpdate: isUpdate,
      );
    } finally {
      _activeUploads.remove(id);
    }
  }

  void _showProgressNotification(
    int id,
    String title,
    int current,
    int total, {
    required bool isUpdate,
  }) {
    final action = isUpdate ? 'تعديل' : 'رفع';
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'upload_channel',
        title: 'جاري $action عقار: $title',
        body: total > 0
            ? 'معالجة الملف $current من $total...'
            : 'جاري حفظ البيانات...',
        category: NotificationCategory.Progress,
        notificationLayout: NotificationLayout.ProgressBar,
        progress: total > 0 ? (current / total) * 100 : 0,
        locked: true,
      ),
    );
  }

  void _showSuccessNotification(
    int id,
    String title, {
    required bool isUpdate,
  }) {
    final status = isUpdate ? 'التعديل' : 'الرفع';
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'upload_channel',
        title: 'تم $status بنجاح! ✅',
        body: 'تمت العملية لـ ($title) بنجاح.',
      ),
    );
  }

  void _showErrorNotification(
    int id,
    String title,
    String error, {
    required bool isUpdate,
  }) {
    final status = isUpdate ? 'التعديل' : 'الرفع';
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'upload_channel',
        title: 'فشل $status! ❌',
        body: '$error',
      ),
    );
  }

  PropertyEntity _mapParamsToEntity(
    AddPropertyParams params,
    List<String> urls, {
    String? id,
    dynamic user,
  }) {
    return PropertyEntity(
      id: id ?? const Uuid().v4(),
      title: params.title,
      description: params.description,
      type: params.type,
      listingType: params.listingType,
      price: params.price,
      currency: params.currency,
      area: params.area,
      createdAt: DateTime.now(),
      media: urls,
      images: urls,
      facilities: params.facilities,
      governorate: params.governorate,
      city: params.city,
      location: params.location,
      phone: params.phone,
      whatsapp: params.whatsapp,
      sellerId: user?.uId ?? "unknown",
      sellerName: user?.name ?? "معلن موثوق",
      sellerImage: user?.profilePic,
      sellerJoinDate: 'عضو جديد',
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
}
