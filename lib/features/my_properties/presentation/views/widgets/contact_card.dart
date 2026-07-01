import 'package:flutter/material.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/core/widgets/custom_text_form_field.dart';

class ContactCard extends StatelessWidget {
  final TextEditingController phoneController;
  final TextEditingController whatsappController;

  const ContactCard({
    super.key,
    required this.phoneController,
    required this.whatsappController,
  });

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextFormField(
              controller: phoneController,
              textAlign: locale.isEnLocale ? TextAlign.left : TextAlign.right,
              labelText: locale.translate(LangKeys.phoneForCall),
              hintText: locale.translate(LangKeys.phoneHintFormat),
              prefixIcon: Icons.phone_callback_outlined,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return locale.translate(LangKeys.pleaseEnterPhone);
                }
                if (!RegExp(r'^09\d{8}$').hasMatch(value)) {
                  return locale.translate(LangKeys.invalidPhoneFormat);
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 16),
              child: Text(
                locale.translate(LangKeys.countryCodeInstruction),
                style: const TextStyle(color: Colors.grey, fontSize: 11),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.chat_outlined, color: Colors.green),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                locale.translate(LangKeys.whatsappNumber),
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                locale.translate(LangKeys.whatsappDifferent),
                                style: TextStyle(
                                  color:
                                      Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.color
                                          ?.withValues(alpha: 0.6) ??
                                      Colors.grey.shade600,
                                  fontSize: 10,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.copy,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
