import 'package:share_plus/share_plus.dart';
import '../../features/my_properties/domain/entities/property_entity.dart';

class ShareService {
  static Future<void> shareProperty(PropertyEntity property) async {
    // الرابط الذي سيفتح التطبيق (يمكنك تغيير الدومين لاحقاً لدومين حقيقي)
    final String deepLink = 'https://beaut-app.com/property/${property.id}';

    final String shareText = '''
🏠 *${property.title}*
💰 السعر: ${property.price} ${property.currency}
📍 الموقع: ${property.governorate} - ${property.city}
📐 المساحة: ${property.area} م²

تفقد هذا العقار الرائع على تطبيق بيوت من هنا:
$deepLink
''';

    await Share.share(shareText, subject: property.title);
  }
}
