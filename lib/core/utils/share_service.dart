import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../language/app_localizations.dart';
import '../language/lang_keys.dart';
import '../../features/my_properties/domain/entities/property_entity.dart';
import '../services/dynamic_link.dart';
import 'service_locator.dart';

class ShareService {
  static Future<void> shareProperty(
    BuildContext context,
    PropertyEntity property,
  ) async {
    final loc = AppLocalizations.of(context)!;

    // Generate real deep link using DynamicLinkService
    final String deepLink = await getIt<DynamicLinkService>()
        .generatePropertyLink(
          propertyId: property.id,
          title: property.title,
          imageUrl: property.images.isNotEmpty ? property.images.first : null,
        );

    final String shareText =
        '''
🏠 *${property.title}*
💰 ${loc.translate(LangKeys.sharePropertyPrice)}: ${property.price} ${property.currency}
📍 ${loc.translate(LangKeys.sharePropertyLocation)}: ${property.governorate} - ${property.city}
📐 ${loc.translate(LangKeys.sharePropertyArea)}: ${property.area} ${loc.translate('area_unit')}

${loc.translate(LangKeys.sharePropertyMessage)}
$deepLink
''';

    await Share.share(shareText, subject: property.title);
  }
}
