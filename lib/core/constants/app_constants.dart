import 'package:flutter/material.dart';

class AppConstants {
  static const Map<String, Map<String, dynamic>> clinicFacilities = {
    'waiting_room': {'value': false, 'icon': Icons.chair_outlined},
    'reception': {'value': false, 'icon': Icons.desk_outlined},
    'x_ray_room': {'value': false, 'icon': Icons.settings_overscan_outlined},
    'surgery_room': {'value': false, 'icon': Icons.medical_services_outlined},
    'bathroom': {'value': false, 'icon': Icons.wc_outlined},
    'central_ac': {'value': false, 'icon': Icons.ac_unit_outlined},
  };

  static const Map<String, Map<String, dynamic>> commonFacilities = {
    'elevator': {'value': false, 'icon': Icons.elevator_outlined},
    'parking': {'value': false, 'icon': Icons.local_parking_outlined},
    'balcony': {'value': false, 'icon': Icons.balcony_outlined},
    'warehouse': {'value': false, 'icon': Icons.storage_outlined},
    'garden': {'value': false, 'icon': Icons.park_outlined},
    'ac': {'value': false, 'icon': Icons.ac_unit_outlined},
    'furnished': {'value': false, 'icon': Icons.chair_outlined},
    'sewage': {'value': false, 'icon': Icons.plumbing_outlined},
    'natural_gas': {'value': false, 'icon': Icons.gas_meter_outlined},
    'internet': {'value': false, 'icon': Icons.wifi_outlined},
    'landline': {'value': false, 'icon': Icons.phone_android_outlined},
    'solar_power': {'value': false, 'icon': Icons.solar_power_outlined},
  };

  // 🔥 إضافة قائمة العملات لضمان عمل الاختيار
  static const List<String> currencies = ['usd', 'currency_lira', 'try'];

  static const List<String> directions = [
    'southern',
    'northern',
    'eastern',
    'western',
    'multi_direction',
    'sea_front',
    'street_front',
    'mountain_view',
    'pool_view',
    'garden_view',
    'internal_view',
    'city_view',
  ];

  static const Map<String, Map<String, dynamic>> farmFacilities = {
    'water_well': {'value': false, 'icon': Icons.water_drop_outlined},
    'farmhouse': {'value': false, 'icon': Icons.home_outlined},
    'electricity': {'value': false, 'icon': Icons.electric_bolt_outlined},
    'warehouse': {'value': false, 'icon': Icons.warehouse_outlined},
  };

  static const List<String> farmTypes = ['plant', 'animal', 'mixed', 'tourist'];

  static const List<String> finishTypes = [
    'super_deluxe',
    'deluxe',
    'normal',
    'on_skeleton',
    'old',
  ];

  static const Map<String, List<String>> governorateSearchMap = {
    'damascus': ['دمشق', 'الشام', 'شام', 'damascus', 'al-sham', 'sham'],
    'rif_damascus': [
      'ريف دمشق',
      'ريف الشام',
      'ريف',
      'rif damascus',
      'rural damascus',
    ],
    'aleppo': ['حلب', 'aleppo', 'halab'],
    'homs': ['حمص', 'homs', 'hims'],
    'hama': ['حماة', 'حماه', 'hama', 'hamah'],
    'latakia': [
      'اللاذقية',
      'اللاذقيه',
      'لاذقية',
      'لاذقيه',
      'لادقية',
      'لادقيه',
      'latakia',
      'lattakia',
    ],
    'tartus': ['طرطوس', 'tartus', 'tartous'],
    'idlib': ['إدلب', 'ادلب', 'idlib', 'edlib'],
    'raqqa': ['الرقة', 'الرقه', 'رقة', 'رقه', 'raqqa', 'rakka'],
    'deir_ez_zor': [
      'دير الزور',
      'ديرالزور',
      'دير',
      'deir ez-zor',
      'deir ezzor',
    ],
    'hasakah': ['الحسكة', 'الحسكه', 'حسكة', 'حسكه', 'hasakah', 'hassakeh'],
    'daraa': ['درعا', 'daraa', 'dar\'a'],
    'sweida': ['السويداء', 'سويداء', 'sweida', 'suwayda'],
    'quneitra': [
      'القنيطرة',
      'القنيطره',
      'قنيطرة',
      'قنيطره',
      'quneitra',
      'qunaytra',
    ],
    'qamishli': ['القامشلي', 'قامشلي', 'qamishli', 'kamishly'],
  };

  static const List<String> governorates = [
    "damascus",
    "rif_damascus",
    "aleppo",
    "homs",
    "hama",
    "latakia",
    "tartus",
    "idlib",
    "raqqa",
    "deir_ez_zor",
    "hasakah",
    "daraa",
    "sweida",
    "quneitra",
    "qamishli",
  ];

  static List<Color> gridColors = [
    const Color(0xff53B175),
    const Color(0xffF8A44C),
    const Color(0xffF7A593),
    const Color(0xffD3B0E0),
    const Color(0xffFDE598),
    const Color(0xffB7DFF5),
  ];

  static const Map<String, Map<String, dynamic>> hallFacilities = {
    'stage': {'value': false, 'icon': Icons.theater_comedy_outlined},
    'sound_system': {'value': false, 'icon': Icons.volume_up_outlined},
    'projector': {'value': false, 'icon': Icons.videocam_outlined},
    'kitchen': {'value': false, 'icon': Icons.kitchen_outlined},
    'ac': {'value': false, 'icon': Icons.ac_unit_outlined},
    'parking': {'value': false, 'icon': Icons.local_parking_outlined},
  };

  static const List<String> heatingTypes = [
    'central_heating',
    'air_conditioning',
    'central',
    'solar_energy',
    'gas_heater',
    'wood',
    'fuel_heater',
    'not_available',
  ];

  static const List<String> irrigationTypes = [
    'drip',
    'spray',
    'flood',
    'well',
    'river',
    'rainfed',
    'irrigation',
    'mist',
    'not_available',
  ];

  static const kIsOnBoardingViewSeen = 'isOnBoardingViewSeen';
  static const kUserData = 'userData';
  static const Map<String, Map<String, dynamic>> landFacilities = {
    'building_license': {'value': false, 'icon': Icons.assignment_outlined},
    'electricity': {'value': false, 'icon': Icons.electric_bolt_outlined},
    'water': {'value': false, 'icon': Icons.water_drop_outlined},
    'sewage': {'value': false, 'icon': Icons.plumbing_outlined},
  };

  static const List<String> landType = [
    'residential',
    'agricultural',
    'commercial',
    'industrial',
    'tourist',
  ];

  static String lang = "ar";
  static const Map<String, Map<String, dynamic>> officeFacilities = {
    'meeting_room': {'value': false, 'icon': Icons.groups_outlined},
    'kitchen': {'value': false, 'icon': Icons.kitchen_outlined},
    'bathroom': {'value': false, 'icon': Icons.wc_outlined},
    'central_ac': {'value': false, 'icon': Icons.ac_unit_outlined},
    'elevator': {'value': false, 'icon': Icons.elevator_outlined},
    'parking': {'value': false, 'icon': Icons.local_parking_outlined},
  };

  static const List<String> ownershipTypes = [
    'green_taboo',
    'temporary_register',
    'notary_public',
    'court_ruling',
    'shares',
    'agency',
    'housing',
    'housing_association',
    'forough',
    'financial_ownership',
  ];

  static const Map<String, Map<String, dynamic>> poolFacilities = {
    'heating_system': {'value': false, 'icon': Icons.fireplace_outlined},
    'filtration_system': {'value': false, 'icon': Icons.water_outlined},
    'changing_rooms': {'value': false, 'icon': Icons.checkroom_outlined},
    'bathrooms_plural': {'value': false, 'icon': Icons.wc_outlined},
    'parking': {'value': false, 'icon': Icons.local_parking_outlined},
  };

  static const List<String> poolSizes = ['small', 'medium', 'large', 'olympic'];
  static const List<String> poolTypes = [
    'private',
    'public',
    'children',
    'covered',
    'open',
    'half_covered',
  ];

  static const String productImageUrl =
      "https://m.media-amazon.com/images/I/61dV53UuRVS.__AC_SX300_SY300_QL70_FMwebp_.jpg";

  static String selectedCurrency = 'usd';
  static String selectedDirection = 'southern';
  static String selectedFarmType = 'plant';
  static String selectedFinishType = 'super_deluxe';
  static String selectedGovernorate = 'damascus';
  static String selectedHeatingType = 'central_heating';
  static String selectedIrrigationType = 'drip';
  static String selectedLandType = 'residential';
  static String selectedOwnershipType = 'green_taboo';
  static String selectedPoolSize = 'medium';
  static String selectedPoolType = 'private';
  static String selectedShopLocation = 'main_street';
  static String selectedWarehouseFloorType = 'concrete';
  static const Map<String, Map<String, dynamic>> shopFacilities = {
    'store': {'value': false, 'icon': Icons.warehouse_outlined},
    'bathroom': {'value': false, 'icon': Icons.wc_outlined},
    'equipped': {'value': false, 'icon': Icons.build_outlined},
    'ac': {'value': false, 'icon': Icons.ac_unit_outlined},
  };

  static const List<String> shopLocationTypes = [
    'main_street',
    'side_street',
    'inside_market',
    'mall',
    'corner',
  ];

  static String token = "token";
  static const Map<String, Map<String, dynamic>> villaFacilities = {
    'pool': {'value': false, 'icon': Icons.pool_outlined},
    'garden': {'value': false, 'icon': Icons.yard_outlined},
    'garage': {'value': false, 'icon': Icons.garage_outlined},
    'security_system': {'value': false, 'icon': Icons.security_outlined},
    'maid_room': {'value': false, 'icon': Icons.person_outline},
    'driver_room': {'value': false, 'icon': Icons.person_pin_circle_outlined},
    'furnished': {'value': false, 'icon': Icons.chair_outlined},
  };

  static const Map<String, Map<String, dynamic>> warehouseFacilities = {
    'loading_platform': {'value': false, 'icon': Icons.local_shipping_outlined},
    'office': {'value': false, 'icon': Icons.business_center_outlined},
    'crane': {'value': false, 'icon': Icons.precision_manufacturing_outlined},
    'bathroom': {'value': false, 'icon': Icons.wc_outlined},
    'electricity': {'value': false, 'icon': Icons.electric_bolt_outlined},
  };

  static const List<String> warehouseFloorTypes = [
    'concrete',
    'tiles',
    'epoxy',
    'asphalt',
    'soil',
  ];

  static const Map<String, Map<String, dynamic>> workshopFacilities = {
    'industrial_electricity': {
      'value': false,
      'icon': Icons.electric_bolt_outlined,
    },
    'ventilation': {'value': false, 'icon': Icons.air_outlined},
    'equipment': {'value': false, 'icon': Icons.handyman_outlined},
    'office': {'value': false, 'icon': Icons.desk_outlined},
    'bathroom': {'value': false, 'icon': Icons.wc_outlined},
  };

  static String normalizeText(String text) {
    return text
        .toLowerCase()
        .trim()
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ة', 'ه')
        .replaceAll('ى', 'ي')
        .replaceAll('ذ', 'د');
  }

  /// وظيفة مساعدة للتحقق مما إذا كان اسم المحافظة يطابق الكود المعطى
  static bool isMatchingGovernorate(String? dataValue, String? selectedKey) {
    if (dataValue == null || selectedKey == null) return false;
    if (selectedKey == 'الكل') return true;

    final nData = normalizeText(dataValue);
    final nKey = normalizeText(selectedKey);

    if (nData == nKey) return true;

    final searchTerms = governorateSearchMap[selectedKey.toLowerCase()] ?? [];
    return searchTerms.any((term) => normalizeText(term) == nData);
  }
}
