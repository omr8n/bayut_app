import '../models/property_model.dart';

// بيانات تجريبية للعقارات متوافقة مع المودل الجديد
class MockData {
  static final List<Property> properties = [
    Property(
      id: '1',
      title: 'شقة فاخرة في دمشق',
      description: 'شقة رائعة مع إطلالة مميزة وتشطيبات عالية الجودة.',
      type: PropertyType.housesAndApartments,
      listingType: ListingType.sale,
      price: 500000000,
      currency: 'ل.س',
      area: 150,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      views: 245,
      isFeatured: true,
      images: [
        'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=800',
      ],
      facilities: ['مصعد', 'موقف سيارة', 'تكييف'],
      governorate: 'دمشق',
      city: 'المزة',
      location: 'دمشق، المزة، أوتوستراد',
      phone: '0935922621',
      whatsapp: '0935922621',
      sellerName: 'Mohammad',
      buildingAge: 5,
      finishType: 'سوبر ديلوكس',
      ownershipType: 'طابو أخضر',
      direction: 'قبلي',
      isLicensed: true,
      totalRooms: 4,
      bedrooms: 3,
      bathrooms: 2,
      floorNumber: 3,
      totalFloors: 5,
      heatingType: 'شوفاج',
    ),
    Property(
      id: '2',
      title: 'مزرعة واسعة في ريف دمشق',
      description: 'مزرعة هادئة مع أشجار مثمرة وبئر ماء.',
      type: PropertyType.farms,
      listingType: ListingType.sale,
      price: 1200000000,
      currency: 'ل.س',
      area: 2500,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      views: 189,
      isFeatured: true,
      images: [
        'https://images.unsplash.com/photo-1580587771525-78b9dba3b914?w=800',
      ],
      facilities: ['بئر ماء', 'كهرباء', 'منزل في المزرعة'],
      governorate: 'ريف دمشق',
      city: 'الغوطة',
      location: 'طريق المطار، الغوطة الشرقية',
      phone: '0935922621',
      whatsapp: '0935922621',
      sellerName: 'Ahmad',
      isLicensed: true,
      farmType: 'نباتية',
      irrigationType: 'تنقيط',
      crops: 'زيتون، مشمش',
    ),
    Property(
      id: '3',
      title: 'محل تجاري في قلب السوق',
      description: 'محل مجهز بالكامل بموقع استراتيجي.',
      type: PropertyType.shops,
      listingType: ListingType.rent,
      price: 2500000,
      currency: 'ل.س',
      area: 45,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      views: 78,
      isFeatured: false,
      images: [
        'https://images.unsplash.com/photo-1497366216548-37526070297c?w=800',
      ],
      facilities: ['مخزن', 'حمام', 'تكييف'],
      governorate: 'حلب',
      city: 'الجميلية',
      location: 'حلب، الجميلية، الشارع الرئيسي',
      phone: '0935922621',
      whatsapp: '0935922621',
      sellerName: 'Omar',
      isLicensed: true,
      frontageWidth: 4.5,
      shopLocation: 'شارع رئيسي',
      commercialActivity: 'تجاري عام',
    ),
  ];

  static List<Property> get featuredProperties =>
      properties.where((p) => p.isFeatured).toList();

  static List<Property> get propertiesForSale =>
      properties.where((p) => p.listingType == ListingType.sale).toList();

  static List<Property> get propertiesForRent =>
      properties.where((p) => p.listingType == ListingType.rent).toList();

  static final List<String> popularCities = [
    'دمشق',
    'حلب',
    'حمص',
    'اللاذقية',
    'طرطوس',
    'حماة',
  ];
}
