import 'package:flutter/material.dart';

import 'package:test_graduation/core/widgets/action_button.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import '../utils/colors.dart';
import '../language/app_localizations.dart';
import '../language/lang_keys.dart';
import '../services/communication_service.dart';
import '../services/dynamic_link.dart';
import '../utils/service_locator.dart';
import 'communication_dialogs.dart';

class CommunicationButtons extends StatelessWidget {
  final PropertyEntity property;
  const CommunicationButtons({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final communicationService = getIt<CommunicationService>();

    Future<void> makeCall() async {
      await communicationService.makeCall(property.phone);
    }

    Future<void> sendWhatsApp() async {
      // Check if whatsapp number is provided
      if (property.whatsapp.isEmpty || property.whatsapp == "0") {
        CommunicationDialogs.showWhatsAppFallback(
          context,
          onCallPressed: makeCall,
        );
        return;
      }

      final String deepLink = await getIt<DynamicLinkService>().generatePropertyLink(
        propertyId: property.id,
        title: property.title,
        imageUrl: property.images.isNotEmpty ? property.images.first : null,
      );

      final String message = localizations.translate(LangKeys.emailBody)
          .replaceAll('{title}', property.title)
          .replaceAll('{link}', deepLink);

      final bool success = await communicationService.sendWhatsApp(
        property.whatsapp,
        message: message,
      );

      if (!success && context.mounted) {
        CommunicationDialogs.showWhatsAppFallback(
          context,
          onCallPressed: makeCall,
        );
      }
    }

    Future<void> _sendEmail() async {
      String? email = property.email;
      if (email == null || email.isEmpty) {
        // Fallback to seller email if property email is missing,
        // but for now we use a default support email if nothing found
        email = "support@syria-realestate.com";
      }

      final String deepLink = await getIt<DynamicLinkService>().generatePropertyLink(
        propertyId: property.id,
        title: property.title,
        imageUrl: property.images.isNotEmpty ? property.images.first : null,
      );

      final String subject = localizations.translate(LangKeys.emailSubject)
          .replaceAll('{title}', property.title);

      final String body = localizations.translate(LangKeys.emailBody)
          .replaceAll('{title}', property.title)
          .replaceAll('{link}', deepLink);

      await communicationService.sendEmail(
        email,
        subject: subject,
        body: body,
      );
    }

    return Row(
      children: [
        ActionButton(
          label: localizations.translate(LangKeys.contactWhatsapp),
          icon: Icons.chat_bubble_outline,
          color: const Color(0xFF25D366),
          onTap: sendWhatsApp,
        ),
        ActionButton(
          label: localizations.translate(LangKeys.contactCall),
          icon: Icons.phone_outlined,
          color: const Color(0xFF455A64), // Dark blue-grey for call
          onTap: makeCall,
        ),
        ActionButton(
          label: localizations.translate(LangKeys.contactEmail),
          icon: Icons.email_outlined,
          color: AppColors.info, // Sky blue for email
          onTap: _sendEmail,
        ),
      ],
    );
  }
}
