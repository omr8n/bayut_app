import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_graduation/core/constants/app_constants.dart';
import 'package:test_graduation/core/enums/property_enums.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/my_properties/domain/entities/add_property_params.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import 'package:test_graduation/features/my_properties/presentation/cubit/add_property_cubit.dart';
import 'package:test_graduation/features/my_properties/presentation/views/widgets/action_buttons.dart';
import 'package:test_graduation/features/my_properties/presentation/views/widgets/basic_info_card.dart';
import 'package:test_graduation/features/my_properties/presentation/views/widgets/contact_card.dart';
import 'package:test_graduation/features/my_properties/presentation/views/widgets/dynamic_specs_section.dart';
import 'package:test_graduation/features/my_properties/presentation/views/widgets/facilities_card.dart';
import 'package:test_graduation/features/my_properties/presentation/views/widgets/image_section.dart';
import 'package:test_graduation/features/my_properties/presentation/views/widgets/installment_card.dart';
import 'package:test_graduation/features/my_properties/presentation/views/widgets/location_card.dart';
import 'package:test_graduation/features/my_properties/presentation/views/widgets/main_info_card.dart';
import 'package:test_graduation/features/my_properties/presentation/views/widgets/section_header.dart';

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
  final ImagePicker _picker = ImagePicker();

  // Controllers
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _areaController;
  late TextEditingController _buildingAgeController;
  late TextEditingController _downPaymentController;
  late TextEditingController _monthlyInstallmentController;
  late TextEditingController _installmentDurationController;
  late TextEditingController _installmentNotesController;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _roomsController = TextEditingController();
  final TextEditingController _bathroomsController = TextEditingController();
  final TextEditingController _floorNumberController = TextEditingController();
  final TextEditingController _totalFloorsController = TextEditingController();
  final TextEditingController _frontageWidthController =
      TextEditingController();
  final TextEditingController _commercialActivityController =
      TextEditingController();
  final TextEditingController _frontagesController = TextEditingController();
  final TextEditingController _streetWidthController = TextEditingController();
  final TextEditingController _cropsController = TextEditingController();
  final TextEditingController _examinationRoomsController =
      TextEditingController();
  final TextEditingController _medicalEquipmentController =
      TextEditingController();
  final TextEditingController _warehouseHeightController =
      TextEditingController();
  final TextEditingController _hallCapacityController = TextEditingController();
  final TextEditingController _workshopTypeController = TextEditingController();
  final TextEditingController _workshopHeightController =
      TextEditingController();

  // FocusNodes
  final FocusNode _priceNode = FocusNode();
  final FocusNode _ageNode = FocusNode();
  final FocusNode _areaNode = FocusNode();
  final FocusNode _durationNode = FocusNode();
  final FocusNode _frontageNode = FocusNode();
  final FocusNode _streetWidthNode = FocusNode();
  final FocusNode _warehouseHeightNode = FocusNode();
  final FocusNode _hallCapacityNode = FocusNode();
  final FocusNode _workshopHeightNode = FocusNode();

  // State Variables
  late PropertyType _selectedPropertyType;
  late ListingType _selectedListingType;
  late bool _hasInstallment;
  late bool _isLicensed;
  late bool _isFeatured;
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

    _selectedPropertyType = p?.type ?? PropertyType.housesAndApartments;
    _selectedListingType = p?.listingType ?? ListingType.sale;
    _hasInstallment = p?.hasInstallment ?? false;
    _isLicensed = p?.isLicensed ?? false;
    _isFeatured = p?.isFeatured ?? false;
    _selectedFinishType = p?.finishType ?? AppConstants.selectedFinishType;
    _selectedOwnershipType =
        p?.ownershipType ?? AppConstants.selectedOwnershipType;
    _selectedDirection = p?.direction ?? AppConstants.selectedDirection;
    _selectedHeatingType = p?.heatingType ?? AppConstants.selectedHeatingType;
    _selectedGovernorate = p?.governorate ?? AppConstants.selectedGovernorate;
    _selectedCurrency = p?.currency ?? AppConstants.selectedCurrency;
    _selectedShopLocation =
        p?.shopLocation ?? AppConstants.selectedShopLocation;
    _selectedLandType = p?.landType ?? AppConstants.selectedLandType;
    _selectedFarmType = p?.farmType ?? AppConstants.selectedFarmType;
    _selectedIrrigationType =
        p?.irrigationType ?? AppConstants.selectedIrrigationType;
    _selectedPoolType = p?.poolType ?? AppConstants.selectedPoolType;
    _selectedPoolSize = p?.poolSize ?? AppConstants.selectedPoolSize;
    _selectedWarehouseFloorType =
        p?.warehouseFloorType ?? AppConstants.selectedWarehouseFloorType;

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
    final List<XFile> pickedFiles = await _picker.pickMultipleMedia();
    if (pickedFiles.isNotEmpty) setState(() => _mediaFiles.addAll(pickedFiles));
  }

  void _removeMedia(int index) => setState(() => _mediaFiles.removeAt(index));

  void _onFacilityToggle(String key) {
    setState(() {
      Map<String, Map<String, dynamic>> map;
      if (_selectedPropertyType == PropertyType.villas)
        map = _currentVillaFacilities;
      else if (_selectedPropertyType == PropertyType.shops ||
          _selectedPropertyType == PropertyType.mallShops)
        map = _currentShopFacilities;
      else if (_selectedPropertyType == PropertyType.lands)
        map = _currentLandFacilities;
      else if (_selectedPropertyType == PropertyType.farms)
        map = _currentFarmFacilities;
      else if (_selectedPropertyType == PropertyType.pools)
        map = _currentPoolFacilities;
      else if (_selectedPropertyType == PropertyType.clinics)
        map = _currentClinicFacilities;
      else if (_selectedPropertyType == PropertyType.warehouses)
        map = _currentWarehouseFacilities;
      else if (_selectedPropertyType == PropertyType.halls)
        map = _currentHallFacilities;
      else if (_selectedPropertyType == PropertyType.offices)
        map = _currentOfficeFacilities;
      else if (_selectedPropertyType == PropertyType.workshops)
        map = _currentWorkshopFacilities;
      else
        map = _currentCommonFacilities;

      if (map.containsKey(key)) map[key]!['value'] = !map[key]!['value'];
    });
  }

  void _uploadOrEditProperty() {
    if (!_formKey.currentState!.validate()) return;

    if (_mediaFiles.isEmpty &&
        (widget.propertyEntity == null ||
            widget.propertyEntity!.media.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى إضافة صور أو فيديوهات للعقار أولاً'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
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

    final cubit = context.read<AddPropertyCubit>();
    if (widget.isEdit) {
      cubit.editProperty(
        params: params,
        originalProperty: widget.propertyEntity!,
      );
    } else {
      cubit.submitProperty(params);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ImageSection(
              mediaFiles: _mediaFiles,
              onAddMedia: _pickMedia,
              onRemoveMedia: _removeMedia,
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
            const SectionHeader(
              title: 'المعلومات الأساسية',
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
              isFeatured: _isFeatured,
              onFeaturedChanged: (v) => setState(() => _isFeatured = v!),
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
              const SectionHeader(
                title: 'هل العقار متاح بالتقسيط؟',
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
            const SectionHeader(
              title: 'المرافق والخدمات المتوفرة',
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
            const SectionHeader(
              title: 'الموقع',
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
            const SectionHeader(
              title: 'معلومات التواصل',
              icon: Icons.phone,
              color: AppColors.primary,
            ),
            ContactCard(
              phoneController: _phoneController,
              whatsappController: _whatsappController,
            ),
            const SizedBox(height: 32),
            ActionButtons(onSubmit: _uploadOrEditProperty),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _showNotesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('ملاحظات عن التقسيط', textAlign: TextAlign.center),
        content: TextField(
          controller: _installmentNotesController,
          maxLines: 5,
          textAlign: TextAlign.right,
          decoration: const InputDecoration(
            hintText: 'اكتب تفاصيل التقسيط هنا...',
            border: OutlineInputBorder(),
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
              child: const Text(
                'تم الحفظ',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    ).then((_) => setState(() {}));
  }
}
