enum PropertyType {
  buildings,
  housesAndApartments,
  underConstruction,
  villas,
  shops,
  mallShops,
  lands,
  farms,
  pools,
  clinics,
  warehouses,
  halls,
  offices,
  workshops,
}

enum Currency { usd, tryCurrency }

enum ListingType { sale, rent }

extension PropertyTypeExtension on PropertyType {
  String get arabicName {
    switch (this) {
      case PropertyType.buildings:
        return 'مباني';
      case PropertyType.housesAndApartments:
        return 'المنازل والشقق';
      case PropertyType.underConstruction:
        return 'منازل وشقق قيد الإنشاء';
      case PropertyType.villas:
        return 'الفيلات';
      case PropertyType.shops:
        return 'محلات';
      case PropertyType.mallShops:
        return 'محلات في مراكز تجارية';
      case PropertyType.lands:
        return 'أراضي';
      case PropertyType.farms:
        return 'مزارع';
      case PropertyType.pools:
        return 'مسابح';
      case PropertyType.clinics:
        return 'عيادات';
      case PropertyType.warehouses:
        return 'مستودعات';
      case PropertyType.halls:
        return 'صالات';
      case PropertyType.offices:
        return 'مكاتب';
      case PropertyType.workshops:
        return 'ورش';
    }
  }
}

extension ListingTypeExtension on ListingType {
  String get arabicName {
    switch (this) {
      case ListingType.sale:
        return 'للبيع';
      case ListingType.rent:
        return 'للإيجار';
    }
  }
}
