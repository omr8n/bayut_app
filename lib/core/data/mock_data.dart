import 'package:test_graduation/core/enums/property_enums.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';

class MockData {
  static final List<PropertyEntity> properties = [
    // --- عقارات مميزة (Featured) وغنية بالبيانات ---
    PropertyEntity(
      id: '1', title: 'شقة ديلوكس في مشروع دمر', description: 'شقة رائعة مع إطلالة بانورامية وتشطيبات عالية الجودة، تصلح للسكن الفوري.',
      type: PropertyType.housesAndApartments, listingType: ListingType.sale, price: 550000000,
      currency: 'ل.س', area: 180, createdAt: DateTime.now().subtract(const Duration(days: 5)),
      views: 312, isFeatured: true,
      images: ['https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=800'],
      media: ['https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=800', 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'],
      facilities: ['مصعد', 'موقف سيارة', 'تكييف', 'بلكون/شرفة', 'غاز طبيعي'],
      governorate: 'دمشق', city: 'مشروع دمر', location: 'مشروع دمر، الجزيرة 16',
      phone: '0935922621', whatsapp: '0935922621', sellerName: 'شركة التطوير العقاري',
      sellerJoinDate: "عضو منذ سنتين", sellerRating: 4.8, 
      buildingAge: 3, finishType: 'ديلوكس', ownershipType: 'طابو أخضر', direction: 'شمالي شرقي', 
      isLicensed: true, hasInstallment: true, downPayment: 150000000, monthlyInstallment: 5000000, installmentDuration: 84,
      installmentNotes: 'الدفعة الأولى عند توقيع العقد، والباقي أقساط شهرية لمدة 7 سنوات.',
      totalRooms: 5, bedrooms: 3, bathrooms: 3, floorNumber: 7, totalFloors: 8, heatingType: 'شوفاج مركزي',
    ),
    PropertyEntity(
      id: '2', title: 'فيلا مع مسبح وإطلالة بحرية', description: 'فيلا مستقلة في منطقة هادئة باللاذقية مع مسبح خاص وحديقة واسعة.',
      type: PropertyType.villas, listingType: ListingType.sale, price: 3200000000, 
      currency: 'ل.س', area: 550, createdAt: DateTime.now().subtract(const Duration(days: 2)),
      views: 630, isFeatured: true, 
      images: ['https://images.unsplash.com/photo-1613490493576-f200968a6e72?w=800'], 
      media: ['https://images.unsplash.com/photo-1613490493576-f200968a6e72?w=800', 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4'], 
      facilities: ['مسبح', 'حديقة', 'كراج', 'نظام أمني', 'غرفة خادمة'],
      governorate: 'اللاذقية', city: 'الشاطئ الأزرق', location: 'الشاطئ الأزرق، إطلالة مباشرة على البحر',
      phone: '0935922621', whatsapp: '0935922621', sellerName: 'مكتب الساحل العقاري', 
      sellerJoinDate: "عضو منذ 3 سنوات", sellerRating: 4.9,
      buildingAge: 10, finishType: 'سوبر ديلوكس', ownershipType: 'طابو أخضر', direction: 'غربي', 
      isLicensed: true, hasInstallment: false, totalRooms: 8, bedrooms: 5, bathrooms: 6, totalFloors: 3,
      heatingType: 'تدفئة مركزية وتكييف', poolType: 'خاص', poolSize: 'كبير',
    ),

    // --- عقارات حديثة (Recent) وغنية بالبيانات ---
    PropertyEntity(
      id: '3', title: 'مكتب تجاري على شارع رئيسي', description: 'مكتب للإيجار في بناء تجاري حديث بحمص، يصلح لجميع الفعاليات.',
      type: PropertyType.offices, listingType: ListingType.rent, price: 1800000, 
      currency: 'ل.س', area: 110, createdAt: DateTime.now().subtract(const Duration(hours: 10)),
      views: 95, isFeatured: false, 
      images: ['https://images.unsplash.com/photo-1497366754035-f200968a6e72?w=800'],
      media: ['https://images.unsplash.com/photo-1497366754035-f200968a6e72?w=800'],
      facilities: ['قاعة اجتماعات', 'مطبخ', 'حمام', 'مصعد', 'موقف سيارة'],
      governorate: 'حمص', city: 'شارع الحضارة', location: 'شارع الحضارة، بناء ABC',
      phone: '0935922621', whatsapp: '0935922621', sellerName: 'الوسيط العقاري', 
      sellerJoinDate: "عضو منذ 6 أشهر", sellerRating: 4.2,
      buildingAge: 1, finishType: 'ديلوكس', ownershipType: 'سجل مؤقت', direction: 'قبلي', isLicensed: true, 
      totalRooms: 4, bathrooms: 2, floorNumber: 3, totalFloors: 6, heatingType: 'تكييف مركزي',
    ),
    PropertyEntity(
      id: '4', title: 'أرض للبناء في ريف دمشق', description: 'أرض منظمة وجاهزة للبناء في منطقة صحنايا، إطلالة جبلية.',
      type: PropertyType.lands, listingType: ListingType.sale, price: 950000000,
      currency: 'ل.س', area: 800, createdAt: DateTime.now().subtract(const Duration(days: 3)),
      views: 120, isFeatured: false, 
      images: ['https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=800'],
      media: ['https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=800'],
      facilities: ['رخصة بناء', 'كهرباء', 'ماء', 'صرف صحي'],
      governorate: 'ريف دمشق', city: 'صحنايا', location: 'صحنايا، المنطقة الغربية', 
      phone: '0935922621', whatsapp: '0935922621', sellerName: 'مالك مباشر', 
      sellerJoinDate: "عضو جديد", sellerRating: 4.0,
      landType: 'سكنية', frontagesCount: 2, streetWidth: 10, isLicensed: true, 
    ),
  ];

  static List<PropertyEntity> get featuredProperties => properties.where((p) => p.isFeatured).toList();
  static List<PropertyEntity> get propertiesForSale => properties.where((p) => p.listingType == ListingType.sale).toList();
  static List<PropertyEntity> get propertiesForRent => properties.where((p) => p.listingType == ListingType.rent).toList();
}
