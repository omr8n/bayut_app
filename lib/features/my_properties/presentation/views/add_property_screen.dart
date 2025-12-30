import 'package:flutter/material.dart';
import 'package:test_graduation/core/models/property_model.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/core/utils/strings_ar.dart';
import 'package:test_graduation/core/widgets/custom_primary_button.dart';
import 'package:test_graduation/core/widgets/custom_text_form_field.dart';
import 'package:test_graduation/core/widgets/type_chip.dart';

class AddPropertyScreen extends StatefulWidget {
  const AddPropertyScreen({super.key});

  @override
  State<AddPropertyScreen> createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _areaController = TextEditingController(); 
  final TextEditingController _buildingAreaController = TextEditingController();
  final TextEditingController _buildingAgeController = TextEditingController();
  final TextEditingController _downPaymentController = TextEditingController();
  final TextEditingController _monthlyInstallmentController =
      TextEditingController();
  final TextEditingController _installmentDurationController =
      TextEditingController();
  final TextEditingController _installmentNotesController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  // Specs Controllers
  final TextEditingController _roomsController = TextEditingController();
  final TextEditingController _bathroomsController = TextEditingController();
  final TextEditingController _floorNumberController = TextEditingController();
  final TextEditingController _totalFloorsController = TextEditingController();
  final TextEditingController _frontageWidthController = TextEditingController();
  final TextEditingController _commercialActivityController = TextEditingController();
  final TextEditingController _frontagesController = TextEditingController();
  final TextEditingController _streetWidthController = TextEditingController();
  final TextEditingController _cropsController = TextEditingController();
  final TextEditingController _examinationRoomsController = TextEditingController();
  final TextEditingController _medicalEquipmentController = TextEditingController();
  final TextEditingController _warehouseHeightController = TextEditingController();
  final TextEditingController _hallCapacityController = TextEditingController();
  final TextEditingController _workshopTypeController = TextEditingController();
  final TextEditingController _workshopHeightController = TextEditingController();

  // FocusNodes
  final FocusNode _areaNode = FocusNode();
  final FocusNode _buildingAreaNode = FocusNode();
  final FocusNode _ageNode = FocusNode();
  final FocusNode _priceNode = FocusNode();
  final FocusNode _durationNode = FocusNode();
  final FocusNode _frontageNode = FocusNode();
  final FocusNode _streetWidthNode = FocusNode();
  final FocusNode _warehouseHeightNode = FocusNode();
  final FocusNode _hallCapacityNode = FocusNode();
  final FocusNode _workshopHeightNode = FocusNode();

  // State Variables
  PropertyType _selectedPropertyType = PropertyType.housesAndApartments;
  ListingType _selectedListingType = ListingType.sale;
  bool _hasInstallment = false;
  bool _isLicensed = false;
  
  String _selectedFinishType = 'سوبر ديلوكس';
  String _selectedOwnershipType = 'طابو أخضر';
  String _selectedDirection = 'قبلي';
  String _selectedHeatingType = 'شوفاج';
  String _selectedGovernorate = 'دمشق';
  String _selectedCurrency = r'$';
  String _selectedShopLocation = 'شارع رئيسي';
  String _selectedLandType = 'سكنية';
  String _selectedFarmType = 'نباتية';
  String _selectedIrrigationType = 'تنقيط';
  String _selectedPoolType = 'خاص';
  String _selectedPoolSize = 'متوسط';
  String _selectedWarehouseFloorType = 'بيتون';

  // Dropdown Lists
  final List<String> _finishTypes = ['سوبر ديلوكس', 'ديلوكس', 'عادي', 'على العظم', 'قديم'];
  final List<String> _ownershipTypes = ['طابو أخضر', 'سجل مؤقت', 'كاتب عدل', 'حكم محكمة', 'أسهم', 'وكالة', 'إسكان', 'جمعية سكنية', 'فروغ', 'تملك مالي'];
  final List<String> _directions = ['قبلي', 'شمالي', 'شرقي', 'غربي', 'أكثر من جهة', 'واجهة بحرية', 'واجهة على الشارع', 'إطلالة جبلية', 'إطلالة على مسبح', 'إطلالة على حديقة', 'إطلالة داخلية', 'إطلالة على مدينة'];
  final List<String> _heatingTypes = ['شوفاج', 'تكييف', 'طاقة شمسية', 'مدفأة غاز', 'مدفأة مازوت', 'حطب', 'غير متوفر'];
  final List<String> _governorates = ['دمشق', 'ريف دمشق', 'حلب', 'حمص', 'حماة', 'اللاذقية', 'طرطوس', 'إدلب', 'دير الزور', 'الرقة', 'الحسكة', 'درعا', 'السويداء', 'القنيطرة'];
  final List<String> _shopLocationTypes = ['شارع رئيسي', 'شارع فرعي', 'داخل سوق', 'مول تجاري', 'زاوية'];
  final List<String> _landTypes = ['سكنية', 'زراعية', 'تجارية', 'صناعية', 'سياحية'];
  final List<String> _farmTypes = ['نباتية', 'حيوانية', 'مختلطة', 'سياحية'];
  final List<String> _irrigationTypes = ['تنقيط', 'رش', 'غمر', 'بئر', 'نهر', 'بعلي', 'سقي', 'رذاذ', 'غير متوفر'];
  final List<String> _poolTypes = ['خاص', 'عام', 'أطفال', 'مغطى', 'مفتوح', 'نصف مغطى'];
  final List<String> _poolSizes = ['صغير', 'متوسط', 'كبير', 'أولمبي'];
  final List<String> _warehouseFloorTypes = ['بيتون', 'بلاط', 'إيبوكسي', 'أسفلت', 'تراب'];

  // المرافق
  final Map<String, Map<String, dynamic>> _commonFacilities = {
    'مصعد': {'value': false, 'icon': Icons.elevator_outlined},
    'موقف سيارة': {'value': false, 'icon': Icons.local_parking_outlined},
    'بلكون/شرفة': {'value': false, 'icon': Icons.balcony_outlined},
    'مستودع/قبو': {'value': false, 'icon': Icons.storage_outlined},
    'حديقة': {'value': false, 'icon': Icons.park_outlined},
    'تكييف': {'value': false, 'icon': Icons.ac_unit_outlined},
    'مفروش': {'value': false, 'icon': Icons.chair_outlined},
    'صرف صحي': {'value': false, 'icon': Icons.plumbing_outlined},
    'غاز طبيعي': {'value': false, 'icon': Icons.gas_meter_outlined},
    'إنترنت': {'value': false, 'icon': Icons.wifi_outlined},
    'هاتف أرضي': {'value': false, 'icon': Icons.phone_android_outlined},
    'طاقة شمسية': {'value': false, 'icon': Icons.solar_power_outlined},
  };

  final Map<String, Map<String, dynamic>> _villaFacilities = {
    'مسبح': {'value': false, 'icon': Icons.pool_outlined},
    'حديقة': {'value': false, 'icon': Icons.yard_outlined},
    'كراج': {'value': false, 'icon': Icons.garage_outlined},
    'نظام أمني': {'value': false, 'icon': Icons.security_outlined},
    'غرفة خادمة': {'value': false, 'icon': Icons.person_outline},
    'غرفة سائق': {'value': false, 'icon': Icons.person_pin_circle_outlined},
    'مفروش': {'value': false, 'icon': Icons.chair_outlined},
  };

  final Map<String, Map<String, dynamic>> _shopFacilities = {
    'مخزن': {'value': false, 'icon': Icons.warehouse_outlined},
    'حمام': {'value': false, 'icon': Icons.wc_outlined},
    'مجهز': {'value': false, 'icon': Icons.build_outlined},
    'تكييف': {'value': false, 'icon': Icons.ac_unit_outlined},
  };

  final Map<String, Map<String, dynamic>> _landFacilities = {
    'رخصة بناء': {'value': false, 'icon': Icons.assignment_outlined},
    'كهرباء': {'value': false, 'icon': Icons.electric_bolt_outlined},
    'ماء': {'value': false, 'icon': Icons.water_drop_outlined},
    'صرف صحي': {'value': false, 'icon': Icons.plumbing_outlined},
  };

  final Map<String, Map<String, dynamic>> _farmFacilities = {
    'بئر ماء': {'value': false, 'icon': Icons.water_drop_outlined},
    'منزل في المزرعة': {'value': false, 'icon': Icons.home_outlined},
    'كهرباء': {'value': false, 'icon': Icons.electric_bolt_outlined},
    'مستودع': {'value': false, 'icon': Icons.warehouse_outlined},
  };

  final Map<String, Map<String, dynamic>> _poolFacilities = {
    'نظام تدفئة': {'value': false, 'icon': Icons.fireplace_outlined},
    'نظام تنقية': {'value': false, 'icon': Icons.water_outlined},
    'غرف تبديل': {'value': false, 'icon': Icons.checkroom_outlined},
    'حمامات': {'value': false, 'icon': Icons.wc_outlined},
    'موقف سيارات': {'value': false, 'icon': Icons.local_parking_outlined},
  };

  final Map<String, Map<String, dynamic>> _clinicFacilities = {
    'غرفة انتظار': {'value': false, 'icon': Icons.chair_outlined},
    'استقبال': {'value': false, 'icon': Icons.desk_outlined},
    'غرفة أشعة': {'value': false, 'icon': Icons.settings_overscan_outlined},
    'غرفة عمليات': {'value': false, 'icon': Icons.medical_services_outlined},
    'حمام': {'value': false, 'icon': Icons.wc_outlined},
    'تكييف مركزي': {'value': false, 'icon': Icons.ac_unit_outlined},
  };

  final Map<String, Map<String, dynamic>> _warehouseFacilities = {
    'منصة تحميل': {'value': false, 'icon': Icons.local_shipping_outlined},
    'مكتب': {'value': false, 'icon': Icons.business_center_outlined},
    'رافعة': {'value': false, 'icon': Icons.precision_manufacturing_outlined},
    'حمام': {'value': false, 'icon': Icons.wc_outlined},
    'كهرباء': {'value': false, 'icon': Icons.electric_bolt_outlined},
  };

  final Map<String, Map<String, dynamic>> _hallFacilities = {
    'منصة/مسرح': {'value': false, 'icon': Icons.theater_comedy_outlined},
    'نظام صوت': {'value': false, 'icon': Icons.volume_up_outlined},
    'جهاز عرض': {'value': false, 'icon': Icons.videocam_outlined},
    'مطبخ': {'value': false, 'icon': Icons.kitchen_outlined},
    'تكييف': {'value': false, 'icon': Icons.ac_unit_outlined},
    'موقف سيارات': {'value': false, 'icon': Icons.local_parking_outlined},
  };

  final Map<String, Map<String, dynamic>> _officeFacilities = {
    'قاعة اجتماعات': {'value': false, 'icon': Icons.groups_outlined},
    'مطبخ': {'value': false, 'icon': Icons.kitchen_outlined},
    'حمام': {'value': false, 'icon': Icons.wc_outlined},
    'تكييف مركزي': {'value': false, 'icon': Icons.ac_unit_outlined},
    'مصعد': {'value': false, 'icon': Icons.elevator_outlined},
    'موقف سيارة': {'value': false, 'icon': Icons.local_parking_outlined},
  };

  final Map<String, Map<String, dynamic>> _workshopFacilities = {
    'كهرباء صناعية (380V)': {'value': false, 'icon': Icons.electric_bolt_outlined},
    'تهوية': {'value': false, 'icon': Icons.air_outlined},
    'معدات': {'value': false, 'icon': Icons.handyman_outlined},
    'مكتب': {'value': false, 'icon': Icons.desk_outlined},
    'حمام': {'value': false, 'icon': Icons.wc_outlined},
  };

  @override
  void initState() {
    super.initState();
    _areaNode.addListener(() => setState(() {}));
    _buildingAreaNode.addListener(() => setState(() {}));
    _ageNode.addListener(() => setState(() {}));
    _priceNode.addListener(() => setState(() {}));
    _durationNode.addListener(() => setState(() {}));
    _frontageNode.addListener(() => setState(() {}));
    _streetWidthNode.addListener(() => setState(() {}));
    _warehouseHeightNode.addListener(() => setState(() {}));
    _hallCapacityNode.addListener(() => setState(() {}));
    _workshopHeightNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _titleController.dispose(); _descriptionController.dispose(); _priceController.dispose();
    _areaController.dispose(); _buildingAreaController.dispose(); _buildingAgeController.dispose();
    _downPaymentController.dispose(); _monthlyInstallmentController.dispose();
    _installmentDurationController.dispose(); _installmentNotesController.dispose();
    _phoneController.dispose(); _whatsappController.dispose(); _locationController.dispose();
    _roomsController.dispose(); _bathroomsController.dispose(); _floorNumberController.dispose();
    _totalFloorsController.dispose(); _frontageWidthController.dispose(); _commercialActivityController.dispose();
    _frontagesController.dispose(); _streetWidthController.dispose(); _cropsController.dispose();
    _examinationRoomsController.dispose(); _medicalEquipmentController.dispose(); _warehouseHeightController.dispose();
    _hallCapacityController.dispose(); _workshopTypeController.dispose(); _workshopHeightController.dispose();
    _areaNode.dispose(); _buildingAreaNode.dispose(); _ageNode.dispose(); _priceNode.dispose(); 
    _durationNode.dispose(); _frontageNode.dispose(); _streetWidthNode.dispose(); _warehouseHeightNode.dispose();
    _hallCapacityNode.dispose(); _workshopHeightNode.dispose();
    super.dispose();
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
          decoration: const InputDecoration(hintText: 'اكتب تفاصيل التقسيط هنا...', border: OutlineInputBorder()),
        ),
        actions: [
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Navigator.pop(context), style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary), child: const Text('تم الحفظ', style: TextStyle(color: Colors.white)))),
        ],
      ),
    ).then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      appBar: AppBar(title: const Text('إضافة عقار جديد'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildImageSection(),
              const SizedBox(height: 16),
              _buildMainInfoCard(),
              const SizedBox(height: 16),
              _buildSectionHeader('المعلومات الأساسية', Icons.info_outline, Colors.blue),
              _buildBasicInfoCard(),
              const SizedBox(height: 16),
              
              _buildDynamicSpecsSection(),
              const SizedBox(height: 16),

              _buildSectionHeader('هل العقار متاح بالتقسيط؟', Icons.credit_card, Colors.green),
              _buildInstallmentCard(),
              const SizedBox(height: 16),
              _buildSectionHeader('المرافق والخدمات المتوفرة', Icons.check_circle_outline, Colors.green),
              _buildFacilitiesCard(),
              const SizedBox(height: 16),
              _buildSectionHeader('الموقع', Icons.location_on, AppColors.primary),
              _buildLocationCard(),
              const SizedBox(height: 16),
              _buildSectionHeader('معلومات التواصل', Icons.phone, AppColors.primary),
              _buildContactCard(),
              const SizedBox(height: 32),
              _buildActionButtons(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDynamicSpecsSection() {
    if (_selectedPropertyType == PropertyType.workshops) {
      return Column(children: [_buildSectionHeader('مواصفات ورشات', Icons.engineering_outlined, Colors.blue), Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [CustomTextFormField(controller: _workshopTypeController, textAlign: TextAlign.right, labelText: 'نوع الورشة', prefixIcon: Icons.handyman_outlined, hintText: 'مثل: حدادة، نجارة، ميكانيك، إلخ'), const SizedBox(height: 16), CustomTextFormField(controller: _workshopHeightController, focusNode: _workshopHeightNode, textAlign: TextAlign.right, labelText: 'الارتفاع', prefixIcon: Icons.height_outlined, keyboardType: TextInputType.number, suffixText: _workshopHeightNode.hasFocus || _workshopHeightController.text.isNotEmpty ? 'متر' : null)])))]);
    } else if (_selectedPropertyType == PropertyType.offices) {
      return Column(children: [_buildSectionHeader('مواصفات مكاتب', Icons.work_outline, Colors.blue), Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [CustomTextFormField(controller: _roomsController, textAlign: TextAlign.right, labelText: 'عدد الغرف', prefixIcon: Icons.door_front_door_outlined, keyboardType: TextInputType.number), const SizedBox(height: 16), CustomTextFormField(controller: _floorNumberController, textAlign: TextAlign.right, labelText: 'رقم الطابق', prefixIcon: Icons.layers_outlined, keyboardType: TextInputType.number)])))]);
    } else if (_selectedPropertyType == PropertyType.halls) {
      return Column(children: [_buildSectionHeader('مواصفات صالات', Icons.meeting_room_outlined, Colors.blue), Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [CustomTextFormField(controller: _hallCapacityController, focusNode: _hallCapacityNode, textAlign: TextAlign.right, labelText: 'السعة', prefixIcon: Icons.people_outline, keyboardType: TextInputType.number, suffixText: _hallCapacityNode.hasFocus || _hallCapacityController.text.isNotEmpty ? 'شخص' : null)])))]);
    } else if (_selectedPropertyType == PropertyType.warehouses) {
      return Column(children: [_buildSectionHeader('مواصفات مستودعات', Icons.warehouse_outlined, Colors.blue), Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [CustomTextFormField(controller: _warehouseHeightController, focusNode: _warehouseHeightNode, textAlign: TextAlign.right, labelText: 'الارتفاع', prefixIcon: Icons.height_outlined, keyboardType: TextInputType.number, suffixText: _warehouseHeightNode.hasFocus || _warehouseHeightController.text.isNotEmpty ? 'متر' : null), const SizedBox(height: 16), _buildDropdownField('نوع الأرضية', Icons.layers_outlined, _selectedWarehouseFloorType, _warehouseFloorTypes, (val) => setState(() => _selectedWarehouseFloorType = val!)) ])))]);
    } else if (_selectedPropertyType == PropertyType.clinics) {
      return Column(children: [_buildSectionHeader('مواصفات عيادات', Icons.medical_services_outlined, Colors.blue), Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [CustomTextFormField(controller: _examinationRoomsController, textAlign: TextAlign.right, labelText: 'عدد غرف الكشف', prefixIcon: Icons.medical_information_outlined, keyboardType: TextInputType.number), const SizedBox(height: 16), CustomTextFormField(controller: _floorNumberController, textAlign: TextAlign.right, labelText: 'رقم الطابق', prefixIcon: Icons.layers_outlined, keyboardType: TextInputType.number), const SizedBox(height: 16), CustomTextFormField(controller: _medicalEquipmentController, textAlign: TextAlign.right, labelText: 'التجهيزات الطبية المتوفرة', prefixIcon: Icons.medication_liquid_outlined, hintText: 'اذكر الأجهزة والمعدات المتوفرة', maxLines: 3)])))]);
    } else if (_selectedPropertyType == PropertyType.pools) {
      return Column(children: [_buildSectionHeader('مواصفات مسابح', Icons.pool_outlined, Colors.blue), Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [_buildDropdownField('نوع المسبح', Icons.pool_outlined, _selectedPoolType, _poolTypes, (val) => setState(() => _selectedPoolType = val!)), const SizedBox(height: 16), _buildDropdownField('حجم المسبح', Icons.architecture_outlined, _selectedPoolSize, _poolSizes, (val) => setState(() => _selectedPoolSize = val!)) ])))]);
    } else if (_selectedPropertyType == PropertyType.farms) {
      return Column(children: [_buildSectionHeader('مواصفات مزارع', Icons.agriculture_outlined, Colors.blue), Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [_buildDropdownField('نوع المزرعة', Icons.agriculture_outlined, _selectedFarmType, _farmTypes, (val) => setState(() => _selectedFarmType = val!)), const SizedBox(height: 16), CustomTextFormField(controller: _areaController, focusNode: _areaNode, textAlign: TextAlign.right, labelText: 'مساحة الأرض *', prefixIcon: Icons.terrain_outlined, keyboardType: TextInputType.number, suffixText: _areaNode.hasFocus || _areaController.text.isNotEmpty ? 'م²' : null), const SizedBox(height: 16), _buildDropdownField('نوع الري', Icons.waves_outlined, _selectedIrrigationType, _irrigationTypes, (val) => setState(() => _selectedIrrigationType = val!)), const SizedBox(height: 16), CustomTextFormField(controller: _cropsController, textAlign: TextAlign.right, labelText: 'أنواع الأشجار/المحاصيل', prefixIcon: Icons.park_outlined, hintText: 'مثل: زيتون، حمضيات، خضروات') ])))]);
    } else if (_selectedPropertyType == PropertyType.lands) {
      return Column(children: [_buildSectionHeader('مواصفات أراضي', Icons.terrain_outlined, Colors.blue), Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [_buildDropdownField('نوع الأرض *', Icons.terrain, _selectedLandType, _landTypes, (val) => setState(() => _selectedLandType = val!)), const SizedBox(height: 16), CustomTextFormField(controller: _frontagesController, textAlign: TextAlign.right, labelText: 'عدد الواجهات', prefixIcon: Icons.check_box_outline_blank, keyboardType: TextInputType.number), const SizedBox(height: 16), CustomTextFormField(controller: _streetWidthController, focusNode: _streetWidthNode, textAlign: TextAlign.right, labelText: 'عرض الشارع', prefixIcon: Icons.polyline_outlined, keyboardType: TextInputType.number, suffixText: _streetWidthNode.hasFocus || _streetWidthController.text.isNotEmpty ? 'متر' : null)])))]);
    } else if (_selectedPropertyType == PropertyType.shops || _selectedPropertyType == PropertyType.mallShops) {
      String header = _selectedPropertyType == PropertyType.shops ? 'مواصفات محلات' : 'مواصفات محلات في مراكز تجارية';
      return Column(children: [_buildSectionHeader(header, Icons.storefront_outlined, Colors.blue), Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [CustomTextFormField(controller: _frontageWidthController, focusNode: _frontageNode, textAlign: TextAlign.right, labelText: 'عرض الواجهة', prefixIcon: Icons.store_outlined, keyboardType: TextInputType.number, suffixText: _frontageNode.hasFocus || _frontageWidthController.text.isNotEmpty ? 'م' : null), const SizedBox(height: 16), _buildDropdownField('موقع المحل', Icons.location_on_outlined, _selectedShopLocation, _shopLocationTypes, (val) => setState(() => _selectedShopLocation = val!)), const SizedBox(height: 16), CustomTextFormField(controller: _commercialActivityController, textAlign: TextAlign.right, labelText: 'النشاط التجاري المسموح', prefixIcon: Icons.business_outlined, hintText: 'مثل: تجاري، مطعم، صيدلية، إلخ', maxLines: 2)])))]);
    } else if (_selectedPropertyType == PropertyType.villas) {
      return Column(children: [_buildSectionHeader('مواصفات الفيلات', Icons.business, Colors.blue), Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [CustomTextFormField(controller: _areaController, focusNode: _areaNode, textAlign: TextAlign.right, labelText: 'مساحة الأرض *', prefixIcon: Icons.terrain, keyboardType: TextInputType.number, suffixText: _areaNode.hasFocus || _areaController.text.isNotEmpty ? 'م²' : null), const SizedBox(height: 16), CustomTextFormField(controller: _buildingAreaController, focusNode: _buildingAreaNode, textAlign: TextAlign.right, labelText: 'مساحة البناء', prefixIcon: Icons.home_outlined, keyboardType: TextInputType.number, suffixText: _buildingAreaNode.hasFocus || _buildingAreaController.text.isNotEmpty ? 'م²' : null), const SizedBox(height: 16), CustomTextFormField(controller: _totalFloorsController, textAlign: TextAlign.right, labelText: 'عدد الطوابق', prefixIcon: Icons.stairs_outlined, keyboardType: TextInputType.number), const SizedBox(height: 16), CustomTextFormField(controller: _roomsController, textAlign: TextAlign.right, labelText: 'عدد الغرف *', prefixIcon: Icons.bed_outlined, keyboardType: TextInputType.number), const SizedBox(height: 16), CustomTextFormField(controller: _bathroomsController, textAlign: TextAlign.right, labelText: 'عدد الحمامات', prefixIcon: Icons.dialpad_outlined, keyboardType: TextInputType.number)])))]);
    } else if (_selectedPropertyType == PropertyType.buildings || _selectedPropertyType == PropertyType.housesAndApartments || _selectedPropertyType == PropertyType.underConstruction) {
      String header = _selectedPropertyType == PropertyType.buildings ? 'مواصفات مباني' : 'مواصفات المنازل والشقق';
      return Column(children: [_buildSectionHeader(header, Icons.business, Colors.blue), Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [CustomTextFormField(controller: _roomsController, textAlign: TextAlign.right, labelText: 'عدد الغرف *', prefixIcon: Icons.door_front_door_outlined), const SizedBox(height: 16), CustomTextFormField(controller: _bathroomsController, textAlign: TextAlign.right, labelText: 'عدد الحمامات', prefixIcon: Icons.bathtub_outlined), const SizedBox(height: 16), CustomTextFormField(controller: _floorNumberController, textAlign: TextAlign.right, labelText: 'رقم الطابق', prefixIcon: Icons.layers_outlined, hintText: '0 للطابق الأرضي'), const SizedBox(height: 16), CustomTextFormField(controller: _totalFloorsController, textAlign: TextAlign.right, labelText: 'عدد طوابق البناء', prefixIcon: Icons.apartment_outlined), const SizedBox(height: 16), _buildDropdownField('نوع التدفئة', Icons.fireplace_outlined, _selectedHeatingType, _heatingTypes, (val) => setState(() => _selectedHeatingType = val!)) ])))]);
    }
    return const SizedBox.shrink();
  }

  Widget _buildFacilitiesCard() {
    Map<String, Map<String, dynamic>> facilities;
    if (_selectedPropertyType == PropertyType.villas) {
      facilities = _villaFacilities;
    } else if (_selectedPropertyType == PropertyType.shops || _selectedPropertyType == PropertyType.mallShops) {
      facilities = _shopFacilities;
    } else if (_selectedPropertyType == PropertyType.lands) {
      facilities = _landFacilities;
    } else if (_selectedPropertyType == PropertyType.farms) {
      facilities = _farmFacilities;
    } else if (_selectedPropertyType == PropertyType.pools) {
      facilities = _poolFacilities;
    } else if (_selectedPropertyType == PropertyType.clinics) {
      facilities = _clinicFacilities;
    } else if (_selectedPropertyType == PropertyType.warehouses) {
      facilities = _warehouseFacilities;
    } else if (_selectedPropertyType == PropertyType.halls) {
      facilities = _hallFacilities;
    } else if (_selectedPropertyType == PropertyType.offices) {
      facilities = _officeFacilities;
    } else if (_selectedPropertyType == PropertyType.workshops) {
      facilities = _workshopFacilities;
    } else {
      facilities = _commonFacilities;
    }

    return Column(
      children: facilities.keys.map((key) {
        bool isSelected = facilities[key]!['value'] as bool;
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: InkWell(
            onTap: () => setState(() => facilities[key]!['value'] = !isSelected),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue.withValues(alpha: 0.05) : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade300, width: isSelected ? 1.5 : 1),
              ),
              child: Row(
                children: [
                  Container(
                    width: 22, height: 22,
                    decoration: BoxDecoration(color: isSelected ? AppColors.primary : Colors.white, border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade400), borderRadius: BorderRadius.circular(6)),
                    child: isSelected ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                  ),
                  const Spacer(),
                  Text(key, style: TextStyle(fontSize: 15, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? AppColors.primary : Colors.black87)),
                  const SizedBox(width: 12),
                  Icon(facilities[key]!['icon'] as IconData, color: isSelected ? AppColors.primary : Colors.grey.shade600, size: 24),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('صور العقار', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Text('يمكنك إضافة حتى 10 صور', style: TextStyle(color: Colors.grey, fontSize: 13)),
        const SizedBox(height: 12),
        Row(children: [Container(width: 100, height: 100, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300)), child: const Icon(Icons.add_a_photo_outlined, color: Colors.grey, size: 32))]),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 8.0), child: Row(children: [Icon(icon, color: color, size: 20), const SizedBox(width: 8), Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color))]));
  }

  Widget _buildMainInfoCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextFormField(controller: _titleController, textAlign: TextAlign.right, labelText: 'اسم العقار', prefixIcon: Icons.title),
            const SizedBox(height: 16),
            CustomTextFormField(controller: _descriptionController, textAlign: TextAlign.right, labelText: 'وصف العقار', maxLines: 3, prefixIcon: Icons.description),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(child: CustomTextFormField(controller: _priceController, focusNode: _priceNode, textAlign: TextAlign.right, labelText: 'السعر', prefixIcon: Icons.attach_money, keyboardType: TextInputType.number, suffixText: _priceNode.hasFocus || _priceController.text.isNotEmpty ? _selectedCurrency : null)),
              const SizedBox(width: 8),
              _buildCurrencySelector(),
            ]),
            const SizedBox(height: 24),
            const Text('الغرض', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: TypeChip(label: AppStrings.forSale, isSelected: _selectedListingType == ListingType.sale, onTap: () => setState(() => _selectedListingType = ListingType.sale))),
              const SizedBox(width: 12),
              Expanded(child: TypeChip(label: AppStrings.forRent, isSelected: _selectedListingType == ListingType.rent, onTap: () => setState(() => _selectedListingType = ListingType.rent))),
            ]),
            const SizedBox(height: 24),
            const Text('نوع العقار', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(spacing: 8, runSpacing: 8, children: PropertyType.values.map((type) => TypeChip(label: type.arabicName, isSelected: _selectedPropertyType == type, onTap: () => setState(() => _selectedPropertyType = type))).toList()),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencySelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(border: Border.all(color: Colors.blue.shade200), borderRadius: BorderRadius.circular(8)),
      child: Row(children: [
        DropdownButtonHideUnderline(child: DropdownButton<String>(value: _selectedCurrency, items: [r'$', 'ل.س', 'AED'].map((curr) => DropdownMenuItem(value: curr, child: Text(curr))).toList(), onChanged: (val) => setState(() => _selectedCurrency = val!))),
        const Icon(Icons.sync, color: Colors.grey, size: 20),
      ]),
    );
  }

  Widget _buildBasicInfoCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(children: [
              Expanded(child: CustomTextFormField(controller: _buildingAgeController, focusNode: _ageNode, textAlign: TextAlign.right, labelText: 'عمر البناء', prefixIcon: Icons.calendar_today, keyboardType: TextInputType.number, suffixText: _ageNode.hasFocus || _buildingAgeController.text.isNotEmpty ? 'سنة' : null, hintText: _ageNode.hasFocus ? '' : 'اتركه فارغاً للجديد')),
            ]),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(child: _buildDropdownField('نوع الكسوة', Icons.format_paint, _selectedFinishType, _finishTypes, (val) => setState(() => _selectedFinishType = val!))),
              const SizedBox(width: 12),
              Expanded(child: _buildDropdownField('نوع الملكية', Icons.assignment, _selectedOwnershipType, _ownershipTypes, (val) => setState(() => _selectedOwnershipType = val!))),
            ]),
            const SizedBox(height: 16),
            _buildDropdownField('الاتجاه والإطلالة', Icons.explore, _selectedDirection, _directions, (val) => setState(() => _selectedDirection = val!)),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
              child: CheckboxListTile(
                title: const Text('العقار مرخص (رخصة بناء)', style: TextStyle(fontSize: 14)),
                value: _isLicensed,
                secondary: const Icon(Icons.assignment_turned_in_outlined, color: Colors.blue),
                onChanged: (val) => setState(() => _isLicensed = val!),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstallmentCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(decoration: BoxDecoration(border: Border.all(color: Colors.blue.shade100), borderRadius: BorderRadius.circular(8)), child: CheckboxListTile(title: const Text('نعم متاح بالتقسيط'), value: _hasInstallment, secondary: const Icon(Icons.credit_card), onChanged: (val) => setState(() => _hasInstallment = val!))),
            if (_hasInstallment) ...[
              const SizedBox(height: 16),
              Row(children: [
                Expanded(child: CustomTextFormField(controller: _downPaymentController, textAlign: TextAlign.right, labelText: 'الدفعة الأولى', prefixIcon: Icons.account_balance_wallet, keyboardType: TextInputType.number)),
                const SizedBox(width: 12),
                Expanded(child: CustomTextFormField(controller: _monthlyInstallmentController, textAlign: TextAlign.right, labelText: 'القسط الشهري', prefixIcon: Icons.calendar_month, keyboardType: TextInputType.number)),
              ]),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(child: CustomTextFormField(controller: _installmentDurationController, focusNode: _durationNode, textAlign: TextAlign.right, labelText: 'مدة التقسيط', prefixIcon: Icons.access_time, keyboardType: TextInputType.number, suffixText: _durationNode.hasFocus || _installmentDurationController.text.isNotEmpty ? 'شهر' : null)),
                const SizedBox(width: 12),
                Expanded(child: GestureDetector(onTap: _showNotesDialog, behavior: HitTestBehavior.opaque, child: AbsorbPointer(child: CustomTextFormField(controller: _installmentNotesController, textAlign: TextAlign.right, labelText: 'ملاحظات', prefixIcon: Icons.note_alt)))),
              ]),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLocationCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [_buildDropdownField('المحافظة', Icons.map_outlined, _selectedGovernorate, _governorates, (val) => setState(() => _selectedGovernorate = val!)), const SizedBox(height: 16), CustomTextFormField(controller: _locationController, textAlign: TextAlign.right, labelText: 'المدينة أو المنطقة', hintText: 'مثال: المزة', prefixIcon: Icons.business_outlined)]))
    );
  }

  Widget _buildContactCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('رقم الهاتف', style: TextStyle(color: Colors.grey, fontSize: 12)),
            CustomTextFormField(
              controller: _phoneController, textAlign: TextAlign.right, hintText: '0935922621', prefixText: '+963 ', keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) return 'يرجى إدخال رقم الهاتف';
                if (!RegExp(r'^[3-9]\d{7}$').hasMatch(value)) return 'يرجى إدخال رقم سوري صحيح';
                return null;
              },
            ),
            const Padding(padding: EdgeInsets.only(top: 8.0, bottom: 16), child: Text('تذكر إضافة رمز الدولة (مثلاً +963 لسوريا)', style: TextStyle(color: Colors.grey, fontSize: 11))),
            Row(children: [
              Expanded(child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(8)), child: Row(children: [const Icon(Icons.chat_outlined, color: Colors.green), const SizedBox(width: 8), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('رقم واتساب', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)), Text('رقم واتساب إذا كان مختلف أو انسخ رقم ال...', style: TextStyle(color: Colors.grey.shade600, fontSize: 10))])]))),
              const SizedBox(width: 8),
              Container(decoration: BoxDecoration(border: Border.all(color: Colors.blue.shade200), borderRadius: BorderRadius.circular(8)), child: IconButton(onPressed: () {}, icon: const Icon(Icons.copy, color: Colors.blue, size: 20)))
            ])
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(children: [
      Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context), style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))), child: const Text('إلغاء'))),
      const SizedBox(width: 16),
      Expanded(child: CustomPriamryButton(onPressed: _submitForm, title: 'إضافة العقار')),
    ]);
  }

  Widget _buildDropdownField(String label, IconData icon, String value, List<String> items, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value, isExpanded: true,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon, size: 20), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
      items: items.map((String val) => DropdownMenuItem<String>(value: val, alignment: AlignmentDirectional.centerEnd, child: Text(val, textAlign: TextAlign.right))).toList(),
      onChanged: onChanged,
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إضافة العقار بنجاح!'), backgroundColor: AppColors.success));
    }
  }
}
