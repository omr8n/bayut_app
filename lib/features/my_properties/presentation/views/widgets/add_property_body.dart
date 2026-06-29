import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:image_picker/image_picker.dart';
import 'package:test_graduation/core/constants/app_constants.dart';
import 'package:test_graduation/core/enums/property_enums.dart';
import 'package:test_graduation/core/routing/router_generation_config.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_settings_cubit/admin_settings_cubit.dart';
import 'package:test_graduation/features/my_properties/domain/entities/add_property_params.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import 'package:test_graduation/features/my_properties/presentation/cubit/add_property_cubit.dart';
import 'package:test_graduation/features/my_properties/presentation/views/widgets/add_action_buttons.dart';
import 'package:test_graduation/features/my_properties/presentation/views/widgets/basic_info_card.dart';
import 'package:test_graduation/features/my_properties/presentation/views/widgets/contact_card.dart';
import 'package:test_graduation/features/my_properties/presentation/views/widgets/dynamic_specs_section.dart';
import 'package:test_graduation/features/my_properties/presentation/views/widgets/facilities_card.dart';
import 'package:test_graduation/features/my_properties/presentation/views/widgets/image_section.dart';
import 'package:test_graduation/features/my_properties/presentation/views/widgets/installment_card.dart';
import 'package:test_graduation/features/my_properties/presentation/views/widgets/location_card.dart';
import 'package:test_graduation/features/my_properties/presentation/views/widgets/main_info_card.dart';
import 'package:test_graduation/features/my_properties/presentation/views/widgets/section_header.dart';

import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';

import 'package:test_graduation/features/my_properties/presentation/manager/listing_limit_view_model.dart';
import 'package:test_graduation/features/my_properties/presentation/views/widgets/limit_reached_bottom_sheet.dart';
import 'package:test_graduation/core/helper/functions/get_user.dart';
import 'package:provider/provider.dart';
import 'package:test_graduation/core/services/listing_limit_service.dart';

class AddPropertyBody extends StatefulWidget {
  const AddPropertyBody({super.key, required this.isEdit, this.propertyEntity});

  final bool isEdit;
  final PropertyEntity? propertyEntity;

  @override
  State<AddPropertyBody> createState() => _AddPropertyBodyState();
}

class _AddPropertyBodyState extends State<AddPropertyBody> {
  final _formKey = GlobalKey<FormState>();
  final List<XFile> _mediaFiles = [];
  List<String> _existingMedia = [];
  final ImagePicker _picker = ImagePicker();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _areaController;
  late TextEditingController _buildingAgeController;
  late TextEditingController _downPaymentController;
  late TextEditingController _monthlyInstallmentController;
  late TextEditingController _installmentDurationController;
  late TextEditingController _installmentNotesController;
  late TextEditingController _phoneController;
  late TextEditingController _whatsappController;
  late TextEditingController _locationController;
  late TextEditingController _roomsController;
  late TextEditingController _bathroomsController;
  late TextEditingController _floorNumberController;
  late TextEditingController _totalFloorsController;
  late TextEditingController _frontageWidthController;
  late TextEditingController _commercialActivityController;
  late TextEditingController _frontagesController;
  late TextEditingController _streetWidthController;
  late TextEditingController _cropsController;
  late TextEditingController _examinationRoomsController;
  late TextEditingController _medicalEquipmentController;
  late TextEditingController _warehouseHeightController;
  late TextEditingController _hallCapacityController;
  late TextEditingController _workshopTypeController;
  late TextEditingController _workshopHeightController;

  final FocusNode _priceNode = FocusNode();
  final FocusNode _ageNode = FocusNode();
  final FocusNode _areaNode = FocusNode();
  final FocusNode _durationNode = FocusNode();
  final FocusNode _frontageNode = FocusNode();
  final FocusNode _streetWidthNode = FocusNode();
  final FocusNode _warehouseHeightNode = FocusNode();
  final FocusNode _hallCapacityNode = FocusNode();
  final FocusNode _workshopHeightNode = FocusNode();

  late PropertyType _selectedPropertyType;
  late ListingType _selectedListingType;
  late bool _hasInstallment;
  late bool _isLicensed;
  late bool _isFeatured;
  late PropertyStatus _status; // 🔥 التغيير من bool إلى Enum
  late String _selectedFinishType;
  late String _selectedOwnershipType;
  late String _selectedDirection;
  late String _selectedHeatingType;
  late String _selectedGovernorate;
  late String _selectedCurrency;
  late String _selectedShopLocation;
  late String _selectedLandType;
  late String _selectedFarmType;
  late String _selectedIrrigationType;
  late String _selectedPoolType;
  late String _selectedPoolSize;
  late String _selectedWarehouseFloorType;

  late Map<String, Map<String, dynamic>> _currentCommonFacilities;
  late Map<String, Map<String, dynamic>> _currentVillaFacilities;
  late Map<String, Map<String, dynamic>> _currentShopFacilities;
  late Map<String, Map<String, dynamic>> _currentLandFacilities;
  late Map<String, Map<String, dynamic>> _currentFarmFacilities;
  late Map<String, Map<String, dynamic>> _currentPoolFacilities;
  late Map<String, Map<String, dynamic>> _currentClinicFacilities;
  late Map<String, Map<String, dynamic>> _currentWarehouseFacilities;
  late Map<String, Map<String, dynamic>> _currentHallFacilities;
  late Map<String, Map<String, dynamic>> _currentOfficeFacilities;
  late Map<String, Map<String, dynamic>> _currentWorkshopFacilities;

  @override
  void initState() {
    super.initState();
    final p = widget.propertyEntity;

    _existingMedia = List<String>.from(p?.media ?? []);

    _titleController = TextEditingController(text: p?.title ?? '');
    _descriptionController = TextEditingController(text: p?.description ?? '');
    _priceController = TextEditingController(text: p?.price.toString() ?? '');
    _areaController = TextEditingController(text: p?.area.toString() ?? '');
    _buildingAgeController = TextEditingController(
      text: p?.buildingAge?.toString() ?? '',
    );
    _downPaymentController = TextEditingController(
      text: p?.downPayment?.toString() ?? '',
    );
    _monthlyInstallmentController = TextEditingController(
      text: p?.monthlyInstallment?.toString() ?? '',
    );
    _installmentDurationController = TextEditingController(
      text: p?.installmentDuration?.toString() ?? '',
    );
    _installmentNotesController = TextEditingController(
      text: p?.installmentNotes ?? '',
    );
    _phoneController = TextEditingController(text: p?.phone ?? '');
    _whatsappController = TextEditingController(text: p?.whatsapp ?? '');
    _locationController = TextEditingController(text: p?.city ?? '');

    _roomsController = TextEditingController(
      text: p?.totalRooms?.toString() ?? '',
    );
    _bathroomsController = TextEditingController(
      text: p?.bathrooms?.toString() ?? '',
    );
    _floorNumberController = TextEditingController(
      text: p?.floorNumber?.toString() ?? '',
    );
    _totalFloorsController = TextEditingController(
      text: p?.totalFloors?.toString() ?? '',
    );
    _frontageWidthController = TextEditingController(
      text: p?.frontageWidth?.toString() ?? '',
    );
    _commercialActivityController = TextEditingController(
      text: p?.commercialActivity ?? '',
    );
    _frontagesController = TextEditingController(
      text: p?.frontagesCount?.toString() ?? '',
    );
    _streetWidthController = TextEditingController(
      text: p?.streetWidth?.toString() ?? '',
    );
    _cropsController = TextEditingController(text: p?.crops ?? '');
    _examinationRoomsController = TextEditingController(
      text: p?.examinationRooms?.toString() ?? '',
    );
    _medicalEquipmentController = TextEditingController(
      text: p?.medicalEquipment ?? '',
    );
    _warehouseHeightController = TextEditingController(
      text: p?.warehouseHeight?.toString() ?? '',
    );
    _hallCapacityController = TextEditingController(
      text: p?.hallCapacity?.toString() ?? '',
    );
    _workshopTypeController = TextEditingController(
      text: p?.workshopType ?? '',
    );
    _workshopHeightController = TextEditingController(
      text: p?.workshopHeight?.toString() ?? '',
    );

    final config = context.read<AdminSettingsCubit>().currentConfig;
    _selectedPropertyType = p?.type ?? PropertyType.housesAndApartments;
    _selectedListingType = p?.listingType ?? ListingType.sale;
    _hasInstallment = p?.hasInstallment ?? false;
    _isLicensed = p?.isLicensed ?? false;
    _isFeatured = p?.isFeatured ?? false; // 🔥 تأكيد استعادة حالة التميز
    _status =
        p?.status ?? PropertyStatus.active; // 🔥 تأكيد استعادة الحالة (Enum)
    _selectedFinishType = p?.finishType ?? AppConstants.finishTypes.first;
    _selectedOwnershipType =
        p?.ownershipType ?? AppConstants.ownershipTypes.first;
    _selectedDirection = p?.direction ?? AppConstants.directions.first;
    _selectedHeatingType = p?.heatingType ?? AppConstants.heatingTypes.first;
    _selectedGovernorate = p?.governorate ?? AppConstants.governorates.first;
    _selectedCurrency = config?.baseCurrency ?? AppConstants.currencies.first;
    _selectedShopLocation =
        p?.shopLocation ?? AppConstants.shopLocationTypes.first;
    _selectedLandType = p?.landType ?? AppConstants.landType.first;
    _selectedFarmType = p?.farmType ?? AppConstants.farmTypes.first;
    _selectedIrrigationType =
        p?.irrigationType ?? AppConstants.irrigationTypes.first;
    _selectedPoolType = p?.poolType ?? AppConstants.poolTypes.first;
    _selectedPoolSize = p?.poolSize ?? AppConstants.poolSizes.first;
    _selectedWarehouseFloorType =
        p?.warehouseFloorType ?? AppConstants.warehouseFloorTypes.first;

    _currentCommonFacilities = _copyMap(AppConstants.commonFacilities);
    _currentVillaFacilities = _copyMap(AppConstants.villaFacilities);
    _currentShopFacilities = _copyMap(AppConstants.shopFacilities);
    _currentLandFacilities = _copyMap(AppConstants.landFacilities);
    _currentFarmFacilities = _copyMap(AppConstants.farmFacilities);
    _currentPoolFacilities = _copyMap(AppConstants.poolFacilities);
    _currentClinicFacilities = _copyMap(AppConstants.clinicFacilities);
    _currentWarehouseFacilities = _copyMap(AppConstants.warehouseFacilities);
    _currentHallFacilities = _copyMap(AppConstants.hallFacilities);
    _currentOfficeFacilities = _copyMap(AppConstants.officeFacilities);
    _currentWorkshopFacilities = _copyMap(AppConstants.workshopFacilities);

    if (widget.isEdit && p != null) {
      _initializeSelectedFacilities(p.facilities);
    }
  }

  Map<String, Map<String, dynamic>> _copyMap(
    Map<String, Map<String, dynamic>> original,
  ) {
    return original.map(
      (key, value) => MapEntry(key, Map<String, dynamic>.from(value)),
    );
  }

  void _initializeSelectedFacilities(List<String> selectedList) {
    void update(Map<String, Map<String, dynamic>> targetMap) {
      for (var key in targetMap.keys) {
        if (selectedList.contains(key)) targetMap[key]!['value'] = true;
      }
    }

    update(_currentCommonFacilities);
    update(_currentVillaFacilities);
    update(_currentShopFacilities);
    update(_currentLandFacilities);
    update(_currentFarmFacilities);
    update(_currentPoolFacilities);
    update(_currentClinicFacilities);
    update(_currentWarehouseFacilities);
    update(_currentHallFacilities);
    update(_currentOfficeFacilities);
    update(_currentWorkshopFacilities);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _areaController.dispose();
    _buildingAgeController.dispose();
    _downPaymentController.dispose();
    _monthlyInstallmentController.dispose();
    _installmentDurationController.dispose();
    _installmentNotesController.dispose();
    _phoneController.dispose();
    _whatsappController.dispose();
    _locationController.dispose();
    _roomsController.dispose();
    _bathroomsController.dispose();
    _floorNumberController.dispose();
    _totalFloorsController.dispose();
    _frontageWidthController.dispose();
    _commercialActivityController.dispose();
    _frontagesController.dispose();
    _streetWidthController.dispose();
    _cropsController.dispose();
    _examinationRoomsController.dispose();
    _medicalEquipmentController.dispose();
    _warehouseHeightController.dispose();
    _hallCapacityController.dispose();
    _workshopTypeController.dispose();
    _workshopHeightController.dispose();
    _areaNode.dispose();
    _ageNode.dispose();
    _priceNode.dispose();
    _durationNode.dispose();
    _frontageNode.dispose();
    _streetWidthNode.dispose();
    _warehouseHeightNode.dispose();
    _hallCapacityNode.dispose();
    _workshopHeightNode.dispose();
    super.dispose();
  }

  Future<void> _pickMedia() async {
    final context = RouterGenerationConfig
        .goRouter
        .configuration
        .navigatorKey
        .currentContext!;
    final config = context.read<AdminSettingsCubit>().currentConfig;
    final int maxImages = config?.maxImagesPerProperty ?? 10;
    final int maxVideos = config?.maxVideosPerProperty ?? 1;
    final locale = AppLocalizations.of(context)!;

    final List<XFile> pickedFiles = await _picker.pickMultipleMedia();

    if (pickedFiles.isNotEmpty) {
      int newImagesCount = 0;
      int newVideosCount = 0;

      // حساب الملفات الحالية
      int currentImagesCount =
          _existingMedia.where((path) => _isImagePath(path)).length +
          _mediaFiles.where((file) => _isImageFile(file)).length;
      int currentVideosCount =
          _existingMedia.where((path) => _isVideoPath(path)).length +
          _mediaFiles.where((file) => _isVideoFile(file)).length;

      List<XFile> allowedFiles = [];

      for (var file in pickedFiles) {
        if (_isImageFile(file)) {
          if (currentImagesCount + newImagesCount < maxImages) {
            allowedFiles.add(file);
            newImagesCount++;
          } else {
            _showLimitSnackBar(
              locale
                  .translate(LangKeys.limitExceededImages)
                  .replaceFirst('{count}', maxImages.toString()),
            );
            break;
          }
        } else if (_isVideoFile(file)) {
          if (currentVideosCount + newVideosCount < maxVideos) {
            allowedFiles.add(file);
            newVideosCount++;
          } else {
            _showLimitSnackBar(
              locale
                  .translate(LangKeys.limitExceededVideos)
                  .replaceFirst('{count}', maxVideos.toString()),
            );
            break;
          }
        }
      }

      if (allowedFiles.isNotEmpty) {
        setState(() => _mediaFiles.addAll(allowedFiles));
      }
    }
  }

  bool _isImagePath(String path) =>
      path.toLowerCase().contains('.jpg') ||
      path.toLowerCase().contains('.jpeg') ||
      path.toLowerCase().contains('.png');
  bool _isVideoPath(String path) =>
      path.toLowerCase().contains('.mp4') ||
      path.toLowerCase().contains('.mov');
  bool _isImageFile(XFile file) =>
      file.path.toLowerCase().contains('.jpg') ||
      file.path.toLowerCase().contains('.jpeg') ||
      file.path.toLowerCase().contains('.png');
  bool _isVideoFile(XFile file) =>
      file.path.toLowerCase().contains('.mp4') ||
      file.path.toLowerCase().contains('.mov');

  void _showLimitSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _removeMedia(int index) => setState(() => _mediaFiles.removeAt(index));
  void _removeExistingMedia(int index) =>
      setState(() => _existingMedia.removeAt(index));

  void _onFacilityToggle(String key) {
    setState(() {
      Map<String, Map<String, dynamic>> map;
      if (_selectedPropertyType == PropertyType.villas) {
        map = _currentVillaFacilities;
      } else if (_selectedPropertyType == PropertyType.shops ||
          _selectedPropertyType == PropertyType.mallShops) {
        map = _currentShopFacilities;
      } else if (_selectedPropertyType == PropertyType.lands) {
        map = _currentLandFacilities;
      } else if (_selectedPropertyType == PropertyType.farms) {
        map = _currentFarmFacilities;
      } else if (_selectedPropertyType == PropertyType.pools) {
        map = _currentPoolFacilities;
      } else if (_selectedPropertyType == PropertyType.clinics) {
        map = _currentClinicFacilities;
      } else if (_selectedPropertyType == PropertyType.warehouses) {
        map = _currentWarehouseFacilities;
      } else if (_selectedPropertyType == PropertyType.halls) {
        map = _currentHallFacilities;
      } else if (_selectedPropertyType == PropertyType.offices) {
        map = _currentOfficeFacilities;
      } else if (_selectedPropertyType == PropertyType.workshops) {
        map = _currentWorkshopFacilities;
      } else {
        map = _currentCommonFacilities;
      }

      if (map.containsKey(key)) map[key]!['value'] = !map[key]!['value'];
    });
  }

  void _uploadOrEditProperty() async {
    if (!_formKey.currentState!.validate()) return;
    final locale = AppLocalizations.of(context);
    final user = await getUser();

    // 🔥 التحقق من حدود النشر إذا لم يكن تعديلاً
    if (!widget.isEdit) {
      final limitResult = await ListingLimitService().checkListingLimit(user);
      if (limitResult['canListFree'] == false) {
        _showLimitReachedSheet(user);
        return;
      }
    }

    List<String> allSelectedFacilities = [];
    void collect(Map<String, Map<String, dynamic>> m) {
      allSelectedFacilities.addAll(
        m.entries.where((e) => e.value['value'] == true).map((e) => e.key),
      );
    }

    collect(_currentCommonFacilities);
    collect(_currentVillaFacilities);
    collect(_currentShopFacilities);
    collect(_currentLandFacilities);
    collect(_currentFarmFacilities);
    collect(_currentPoolFacilities);
    collect(_currentClinicFacilities);
    collect(_currentWarehouseFacilities);
    collect(_currentHallFacilities);
    collect(_currentOfficeFacilities);
    collect(_currentWorkshopFacilities);

    final params = AddPropertyParams(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      type: _selectedPropertyType,
      listingType: _selectedListingType,
      price: double.tryParse(_priceController.text.trim()) ?? 0.0,
      currency: _selectedCurrency,
      area: double.tryParse(_areaController.text.trim()) ?? 0.0,
      governorate: _selectedGovernorate,
      city: _locationController.text.trim(),
      location: _locationController.text.trim(),
      phone: _phoneController.text.trim(),
      whatsapp: _whatsappController.text.trim(),
      mediaFiles: _mediaFiles,
      facilities: allSelectedFacilities.toSet().toList(),
      buildingAge: int.tryParse(_buildingAgeController.text.trim()),
      finishType: _selectedFinishType,
      ownershipType: _selectedOwnershipType,
      direction: _selectedDirection,
      isLicensed: _isLicensed,
      hasInstallment: _hasInstallment,
      downPayment: double.tryParse(_downPaymentController.text.trim()),
      monthlyInstallment: double.tryParse(
        _monthlyInstallmentController.text.trim(),
      ),
      installmentDuration: int.tryParse(
        _installmentDurationController.text.trim(),
      ),
      installmentNotes: _installmentNotesController.text.trim(),
      totalRooms: int.tryParse(_roomsController.text.trim()),
      bathrooms: int.tryParse(_bathroomsController.text.trim()),
      floorNumber: int.tryParse(_floorNumberController.text.trim()),
      totalFloors: int.tryParse(_totalFloorsController.text.trim()),
      isFeatured: _isFeatured, // 🔥 إرسال حالة التميز المحدثة
      heatingType: _selectedHeatingType,
      landType: _selectedLandType,
      frontagesCount: int.tryParse(_frontagesController.text.trim()),
      streetWidth: double.tryParse(_streetWidthController.text.trim()),
      farmType: _selectedFarmType,
      irrigationType: _selectedIrrigationType,
      crops: _cropsController.text.trim(),
      frontageWidth: double.tryParse(_frontageWidthController.text.trim()),
      shopLocation: _selectedShopLocation,
      commercialActivity: _commercialActivityController.text.trim(),
      poolType: _selectedPoolType,
      poolSize: _selectedPoolSize,
      examinationRooms: int.tryParse(_examinationRoomsController.text.trim()),
      medicalEquipment: _medicalEquipmentController.text.trim(),
      warehouseHeight: double.tryParse(_warehouseHeightController.text.trim()),
      warehouseFloorType: _selectedWarehouseFloorType,
      hallCapacity: int.tryParse(_hallCapacityController.text.trim()),
      workshopType: _workshopTypeController.text.trim(),
      workshopHeight: double.tryParse(_workshopHeightController.text.trim()),
    );

    final cubit = context.read<AddPropertyCubit>();
    if (widget.isEdit) {
      // تمرير الحالة الحالية لضمان عدم ضياعها أثناء التعديل
      final updatedOriginal = widget.propertyEntity!.copyWith(
        media: _existingMedia,
        status: _status, // 🔥
        isFeatured: _isFeatured,
      );
      cubit.editProperty(params: params, originalProperty: updatedOriginal);
    } else {
      cubit.submitProperty(params);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(locale!.translate(LangKeys.processingStarted)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ImageSection(
              mediaFiles: _mediaFiles,
              existingMedia: _existingMedia,
              onAddMedia: _pickMedia,
              onRemoveMedia: _removeMedia,
              onRemoveExistingMedia: _removeExistingMedia,
            ),
            const SizedBox(height: 16),
            MainInfoCard(
              titleController: _titleController,
              descriptionController: _descriptionController,
              priceController: _priceController,
              priceNode: _priceNode,
              selectedCurrency: _selectedCurrency,
              onCurrencyChanged: (v) => setState(() => _selectedCurrency = v!),
              selectedListingType: _selectedListingType,
              onListingTypeChanged: (v) => setState(() {
                _selectedListingType = v;
                if (v == ListingType.rent) _hasInstallment = false;
              }),
              selectedPropertyType: _selectedPropertyType,
              onPropertyTypeChanged: (v) =>
                  setState(() => _selectedPropertyType = v),
            ),
            const SizedBox(height: 16),
            SectionHeader(
              title: locale!.translate(LangKeys.basicInfo),
              icon: Icons.info_outline,
              color: Colors.blue,
            ),
            BasicInfoCard(
              buildingAgeController: _buildingAgeController,
              ageNode: _ageNode,
              selectedFinishType: _selectedFinishType,
              finishTypes: AppConstants.finishTypes,
              onFinishTypeChanged: (v) =>
                  setState(() => _selectedFinishType = v!),
              selectedOwnershipType: _selectedOwnershipType,
              ownershipTypes: AppConstants.ownershipTypes,
              onOwnershipTypeChanged: (v) =>
                  setState(() => _selectedOwnershipType = v!),
              selectedDirection: _selectedDirection,
              directions: AppConstants.directions,
              onDirectionChanged: (v) =>
                  setState(() => _selectedDirection = v!),
              isLicensed: _isLicensed,
              onLicensedChanged: (v) => setState(() => _isLicensed = v!),
            ),
            const SizedBox(height: 16),
            DynamicSpecsSection(
              selectedPropertyType: _selectedPropertyType,
              roomsController: _roomsController,
              bathroomsController: _bathroomsController,
              floorNumberController: _floorNumberController,
              totalFloorsController: _totalFloorsController,
              frontageWidthController: _frontageWidthController,
              frontageNode: _frontageNode,
              commercialActivityController: _commercialActivityController,
              selectedShopLocation: _selectedShopLocation,
              shopLocationTypes: AppConstants.shopLocationTypes,
              onShopLocationChanged: (v) =>
                  setState(() => _selectedShopLocation = v!),
              selectedLandType: _selectedLandType,
              landTypes: AppConstants.landType,
              onLandTypeChanged: (v) => setState(() => _selectedLandType = v!),
              frontagesController: _frontagesController,
              streetWidthController: _streetWidthController,
              streetWidthNode: _streetWidthNode,
              selectedFarmType: _selectedFarmType,
              farmTypes: AppConstants.farmTypes,
              onFarmTypeChanged: (v) => setState(() => _selectedFarmType = v!),
              areaController: _areaController,
              areaNode: _areaNode,
              selectedIrrigationType: _selectedIrrigationType,
              irrigationTypes: AppConstants.irrigationTypes,
              onIrrigationTypeChanged: (v) =>
                  setState(() => _selectedIrrigationType = v!),
              cropsController: _cropsController,
              selectedPoolType: _selectedPoolType,
              poolTypes: AppConstants.poolTypes,
              onPoolTypeChanged: (v) => setState(() => _selectedPoolType = v!),
              selectedPoolSize: _selectedPoolSize,
              poolSizes: AppConstants.poolSizes,
              onPoolSizeChanged: (v) => setState(() => _selectedPoolSize = v!),
              buildingAreaController: TextEditingController(),
              buildingAreaNode: FocusNode(),
              selectedHeatingType: _selectedHeatingType,
              heatingTypes: AppConstants.heatingTypes,
              onHeatingTypeChanged: (v) =>
                  setState(() => _selectedHeatingType = v!),
              examinationRoomsController: _examinationRoomsController,
              medicalEquipmentController: _medicalEquipmentController,
              warehouseHeightController: _warehouseHeightController,
              warehouseHeightNode: _warehouseHeightNode,
              selectedWarehouseFloorType: _selectedWarehouseFloorType,
              warehouseFloorTypes: AppConstants.warehouseFloorTypes,
              onWarehouseFloorTypeChanged: (v) =>
                  setState(() => _selectedWarehouseFloorType = v!),
              hallCapacityController: _hallCapacityController,
              hallCapacityNode: _hallCapacityNode,
              workshopTypeController: _workshopTypeController,
              workshopHeightController: _workshopHeightController,
              workshopHeightNode: _workshopHeightNode,
            ),
            const SizedBox(height: 16),
            if (_selectedListingType == ListingType.sale) ...[
              SectionHeader(
                title: locale.translate(LangKeys.installmentAvailableQuestion),
                icon: Icons.credit_card,
                color: Colors.green,
              ),
              InstallmentCard(
                hasInstallment: _hasInstallment,
                onInstallmentChanged: (v) =>
                    setState(() => _hasInstallment = v!),
                downPaymentController: _downPaymentController,
                monthlyInstallmentController: _monthlyInstallmentController,
                installmentDurationController: _installmentDurationController,
                durationNode: _durationNode,
                installmentNotesController: _installmentNotesController,
                showNotesDialog: _showNotesDialog,
              ),
              const SizedBox(height: 16),
            ],
            SectionHeader(
              title: locale.translate(LangKeys.availableFacilities),
              icon: Icons.check_circle_outline,
              color: Colors.green,
            ),
            FacilitiesCard(
              selectedPropertyType: _selectedPropertyType,
              commonFacilities: _currentCommonFacilities,
              villaFacilities: _currentVillaFacilities,
              shopFacilities: _currentShopFacilities,
              landFacilities: _currentLandFacilities,
              farmFacilities: _currentFarmFacilities,
              poolFacilities: _currentPoolFacilities,
              clinicFacilities: _currentClinicFacilities,
              warehouseFacilities: _currentWarehouseFacilities,
              hallFacilities: _currentHallFacilities,
              officeFacilities: _currentOfficeFacilities,
              workshopFacilities: _currentWorkshopFacilities,
              onFacilityToggle: _onFacilityToggle,
            ),
            const SizedBox(height: 16),
            SectionHeader(
              title: locale.translate(LangKeys.location),
              icon: Icons.location_on,
              color: AppColors.primary,
            ),
            LocationCard(
              selectedGovernorate: _selectedGovernorate,
              governorates: AppConstants.governorates,
              onGovernorateChanged: (v) =>
                  setState(() => _selectedGovernorate = v!),
              locationController: _locationController,
            ),
            const SizedBox(height: 16),
            SectionHeader(
              title: locale.translate(LangKeys.contactInfo),
              icon: Icons.phone,
              color: AppColors.primary,
            ),
            ContactCard(
              phoneController: _phoneController,
              whatsappController: _whatsappController,
            ),
            const SizedBox(height: 32),
            AddActionButtons(
              onSubmit: _uploadOrEditProperty,
              isEdit: widget.isEdit,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _showNotesDialog() {
    final locale = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          locale!.translate(LangKeys.installmentNotes),
          textAlign: TextAlign.center,
        ),
        content: TextField(
          controller: _installmentNotesController,
          maxLines: 5,
          textAlign: locale.isEnLocale ? TextAlign.left : TextAlign.right,
          decoration: InputDecoration(
            hintText: locale.translate(LangKeys.writeInstallmentNotes),
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: Text(
                locale.translate(LangKeys.saved),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    ).then((_) => setState(() {}));
  }

  void _showLimitReachedSheet(dynamic user) {
    final config = context.read<AdminSettingsCubit>().currentConfig;
    final double extraPrice = config?.extraPropertyPrice ?? 5000.0;
    final String currency = config?.baseCurrency ?? 'ل.س';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ChangeNotifierProvider(
        create: (_) => ListingLimitViewModel()..checkLimits(user),
        child: LimitReachedBottomSheet(
          onPayAndPublish: () async {
            // محاكاة عملية الدفع
            final cubit = context.read<AddPropertyCubit>();
            Navigator.pop(context); // إغلاق الشيت

            // إظهار تنبيه جاري المعالجة
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(
                    context,
                  )!.translate(LangKeys.waitingForPayment),
                ),
              ),
            );

            final success = await cubit.paymentService
                .processExtraListingPayment(
                  user: user,
                  amount: extraPrice,
                  propertyTitle: _titleController.text.trim(),
                );

            if (success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppLocalizations.of(
                      context,
                    )!.translate(LangKeys.paymentSuccess),
                  ),
                  backgroundColor: Colors.green,
                ),
              );
              // تنفيذ عملية الرفع الفعلي
              _executeUpload(user);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppLocalizations.of(
                      context,
                    )!.translate(LangKeys.paymentFailed),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
      ),
    );
  }

  void _executeUpload(dynamic user) {
    List<String> allSelectedFacilities = [];
    void collect(Map<String, Map<String, dynamic>> m) {
      allSelectedFacilities.addAll(
        m.entries.where((e) => e.value['value'] == true).map((e) => e.key),
      );
    }

    collect(_currentCommonFacilities);
    collect(_currentVillaFacilities);
    collect(_currentShopFacilities);
    collect(_currentLandFacilities);
    collect(_currentFarmFacilities);
    collect(_currentPoolFacilities);
    collect(_currentClinicFacilities);
    collect(_currentWarehouseFacilities);
    collect(_currentHallFacilities);
    collect(_currentOfficeFacilities);
    collect(_currentWorkshopFacilities);

    final params = AddPropertyParams(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      type: _selectedPropertyType,
      listingType: _selectedListingType,
      price: double.tryParse(_priceController.text.trim()) ?? 0.0,
      currency: _selectedCurrency,
      area: double.tryParse(_areaController.text.trim()) ?? 0.0,
      governorate: _selectedGovernorate,
      city: _locationController.text.trim(),
      location: _locationController.text.trim(),
      phone: _phoneController.text.trim(),
      whatsapp: _whatsappController.text.trim(),
      mediaFiles: _mediaFiles,
      facilities: allSelectedFacilities.toSet().toList(),
      buildingAge: int.tryParse(_buildingAgeController.text.trim()),
      finishType: _selectedFinishType,
      ownershipType: _selectedOwnershipType,
      direction: _selectedDirection,
      isLicensed: _isLicensed,
      hasInstallment: _hasInstallment,
      downPayment: double.tryParse(_downPaymentController.text.trim()),
      monthlyInstallment: double.tryParse(
        _monthlyInstallmentController.text.trim(),
      ),
      installmentDuration: int.tryParse(
        _installmentDurationController.text.trim(),
      ),
      installmentNotes: _installmentNotesController.text.trim(),
      totalRooms: int.tryParse(_roomsController.text.trim()),
      bathrooms: int.tryParse(_bathroomsController.text.trim()),
      floorNumber: int.tryParse(_floorNumberController.text.trim()),
      totalFloors: int.tryParse(_totalFloorsController.text.trim()),
      isFeatured: _isFeatured,
      heatingType: _selectedHeatingType,
      landType: _selectedLandType,
      frontagesCount: int.tryParse(_frontagesController.text.trim()),
      streetWidth: double.tryParse(_streetWidthController.text.trim()),
      farmType: _selectedFarmType,
      irrigationType: _selectedIrrigationType,
      crops: _cropsController.text.trim(),
      frontageWidth: double.tryParse(_frontageWidthController.text.trim()),
      shopLocation: _selectedShopLocation,
      commercialActivity: _commercialActivityController.text.trim(),
      poolType: _selectedPoolType,
      poolSize: _selectedPoolSize,
      examinationRooms: int.tryParse(_examinationRoomsController.text.trim()),
      medicalEquipment: _medicalEquipmentController.text.trim(),
      warehouseHeight: double.tryParse(_warehouseHeightController.text.trim()),
      warehouseFloorType: _selectedWarehouseFloorType,
      hallCapacity: int.tryParse(_hallCapacityController.text.trim()),
      workshopType: _workshopTypeController.text.trim(),
      workshopHeight: double.tryParse(_workshopHeightController.text.trim()),
    );

    context.read<AddPropertyCubit>().submitProperty(params);
  }
}
