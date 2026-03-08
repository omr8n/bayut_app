import 'package:flutter/material.dart';

class AppConstants {
  static const String productImageUrl =
      "https://m.media-amazon.com/images/I/61dV53UuRVS.__AC_SX300_SY300_QL70_FMwebp_.jpg";

  static List<Color> gridColors = [
    const Color(0xff53B175),
    const Color(0xffF8A44C),
    const Color(0xffF7A593),
    const Color(0xffD3B0E0),
    const Color(0xffFDE598),
    const Color(0xffB7DFF5),
  ];
  // Facilities Maps (Same as before)
  static const Map<String, Map<String, dynamic>> commonFacilities = {
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
  static const Map<String, Map<String, dynamic>> villaFacilities = {
    'مسبح': {'value': false, 'icon': Icons.pool_outlined},
    'حديقة': {'value': false, 'icon': Icons.yard_outlined},
    'كراج': {'value': false, 'icon': Icons.garage_outlined},
    'نظام أمني': {'value': false, 'icon': Icons.security_outlined},
    'غرفة خادمة': {'value': false, 'icon': Icons.person_outline},
    'غرفة سائق': {'value': false, 'icon': Icons.person_pin_circle_outlined},
    'مفروش': {'value': false, 'icon': Icons.chair_outlined},
  };
  static const Map<String, Map<String, dynamic>> shopFacilities = {
    'مخزن': {'value': false, 'icon': Icons.warehouse_outlined},
    'حمام': {'value': false, 'icon': Icons.wc_outlined},
    'مجهز': {'value': false, 'icon': Icons.build_outlined},
    'تكييف': {'value': false, 'icon': Icons.ac_unit_outlined},
  };
  static const Map<String, Map<String, dynamic>> landFacilities = {
    'رخصة بناء': {'value': false, 'icon': Icons.assignment_outlined},
    'كهرباء': {'value': false, 'icon': Icons.electric_bolt_outlined},
    'ماء': {'value': false, 'icon': Icons.water_drop_outlined},
    'صرف صحي': {'value': false, 'icon': Icons.plumbing_outlined},
  };
  static const Map<String, Map<String, dynamic>> farmFacilities = {
    'بئر ماء': {'value': false, 'icon': Icons.water_drop_outlined},
    'منزل في المزرعة': {'value': false, 'icon': Icons.home_outlined},
    'كهرباء': {'value': false, 'icon': Icons.electric_bolt_outlined},
    'مستودع': {'value': false, 'icon': Icons.warehouse_outlined},
  };
  static const Map<String, Map<String, dynamic>> poolFacilities = {
    'نظام تدفئة': {'value': false, 'icon': Icons.fireplace_outlined},
    'نظام تنقية': {'value': false, 'icon': Icons.water_outlined},
    'غرف تبديل': {'value': false, 'icon': Icons.checkroom_outlined},
    'حمامات': {'value': false, 'icon': Icons.wc_outlined},
    'موقف سيارات': {'value': false, 'icon': Icons.local_parking_outlined},
  };
  static const Map<String, Map<String, dynamic>> clinicFacilities = {
    'غرفة انتظار': {'value': false, 'icon': Icons.chair_outlined},
    'استقبال': {'value': false, 'icon': Icons.desk_outlined},
    'غرفة أشعة': {'value': false, 'icon': Icons.settings_overscan_outlined},
    'غرفة عمليات': {'value': false, 'icon': Icons.medical_services_outlined},
    'حمام': {'value': false, 'icon': Icons.wc_outlined},
    'تكييف مركزي': {'value': false, 'icon': Icons.ac_unit_outlined},
  };
  static const Map<String, Map<String, dynamic>> warehouseFacilities = {
    'منصة تحميل': {'value': false, 'icon': Icons.local_shipping_outlined},
    'مكتب': {'value': false, 'icon': Icons.business_center_outlined},
    'رافعة': {'value': false, 'icon': Icons.precision_manufacturing_outlined},
    'حمام': {'value': false, 'icon': Icons.wc_outlined},
    'كهرباء': {'value': false, 'icon': Icons.electric_bolt_outlined},
  };
  static const Map<String, Map<String, dynamic>> hallFacilities = {
    'منصة/مسرح': {'value': false, 'icon': Icons.theater_comedy_outlined},
    'نظام صوت': {'value': false, 'icon': Icons.volume_up_outlined},
    'جهاز عرض': {'value': false, 'icon': Icons.videocam_outlined},
    'مطبخ': {'value': false, 'icon': Icons.kitchen_outlined},
    'تكييف': {'value': false, 'icon': Icons.ac_unit_outlined},
    'موقف سيارات': {'value': false, 'icon': Icons.local_parking_outlined},
  };
  static const Map<String, Map<String, dynamic>> officeFacilities = {
    'قاعة اجتماعات': {'value': false, 'icon': Icons.groups_outlined},
    'مطبخ': {'value': false, 'icon': Icons.kitchen_outlined},
    'حمام': {'value': false, 'icon': Icons.wc_outlined},
    'تكييف مركزي': {'value': false, 'icon': Icons.ac_unit_outlined},
    'مصعد': {'value': false, 'icon': Icons.elevator_outlined},
    'موقف سيارة': {'value': false, 'icon': Icons.local_parking_outlined},
  };
  static const Map<String, Map<String, dynamic>> workshopFacilities = {
    'كهرباء صناعية (380V)': {
      'value': false,
      'icon': Icons.electric_bolt_outlined,
    },
    'تهوية': {'value': false, 'icon': Icons.air_outlined},
    'معدات': {'value': false, 'icon': Icons.handyman_outlined},
    'مكتب': {'value': false, 'icon': Icons.desk_outlined},
    'حمام': {'value': false, 'icon': Icons.wc_outlined},
  };
  static const List<String> finishTypes = [
    'سوبر ديلوكس',
    'ديلوكس',
    'عادي',
    'على العظم',
    'قديم',
  ];
  static const List<String> ownershipTypes = [
    'طابو أخضر',
    'سجل مؤقت',
    'كاتب عدل',
    'حكم محكمة',
    'أسهم',
    'وكالة',
    'إسكان',
    'جمعية سكنية ',
    'فروغ',
    'تملك مالي',
  ];
  static const List<String> directions = [
    'قبلي',
    'شمالي',
    'شرقي',
    'غربي',
    'أكثر من جهة',
    'واجهة بحرية',
    'واجهة على الشارع',
    'إطلالة جبلية',
    'إطلالة على مسبح',
    'إطلالة على حديقة',
    'إطلالة داخلية',
    'إطلالة على مدينة',
  ];
  static const List<String> shopLocationTypes = [
    'شارع رئيسي',
    'شارع فرعي',
    'داخل سوق',
    'مول تجاري',
    'زاوية',
  ];
  static const List<String> landType = [
    'سكنية',
    'زراعية',
    'تجارية',
    'صناعية',
    'سياحية',
  ];
  static const List<String> farmTypes = [
    'نباتية',
    'حيوانية',
    'مختلطة',
    'سياحية',
  ];
  static const List<String> irrigationTypes = [
    'تنقيط',
    'رش',
    'غمر',
    'بئر',
    'نهر',
    'بعلي',
    'سقي',
    'رذاذ',
    'غير متوفر',
  ];
  static const List<String> poolTypes = [
    'خاص',
    'عام',
    'أطفال',
    'مغطى',
    'مفتوح',
    'نصف مغطى',
  ];
  static const List<String> poolSizes = ['صغير', 'متوسط', 'كبير', 'أولمبي'];
  static const List<String> heatingTypes = [
    'شوفاج',
    'تكييف',
    'مركزي',
    'طاقة شمسية',
    'مدفأة غاز',
    'حطب',
    'مدفأة مازوت',
    'غير متوفر',
  ];
  static const List<String> warehouseFloorTypes = [
    'بيتون',
    'بلاط',
    'إيبوكسي',
    'أسفلت',
    'تراب',
  ];
  static const List<String> governorates = [
    "دمشق",
    "ريف دمشق",
    "حلب",
    "حمص",
    "حماة",
    "اللاذقية",
    "طرطوس",
    "إدلب",
    "الرقة",
    "دير الزور",
    "الحسكة",
    "درعا",
    "السويداء",
    "القنيطرة",
  ];
  static String selectedFinishType = 'سوبر ديلوكس';
  static String selectedOwnershipType = 'طابو أخضر';
  static String selectedDirection = 'قبلي';
  static String selectedHeatingType = 'شوفاج';
  static String selectedGovernorate = 'دمشق';
  static String selectedCurrency = r'$';
  static String selectedShopLocation = 'شارع رئيسي';
  static String selectedLandType = 'سكنية';
  static String selectedFarmType = 'نباتية';
  static String selectedIrrigationType = 'تنقيط';
  static String selectedPoolType = 'خاص';
  static String selectedPoolSize = 'متوسط';
  static String selectedWarehouseFloorType = 'بيتون';

  // وظيفة موحدة لاختيار الصور والفيديوها
}
