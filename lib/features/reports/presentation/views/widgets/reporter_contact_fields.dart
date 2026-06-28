import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:test_graduation/core/utils/colors.dart';

class ReporterContactFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;

  const ReporterContactFields({
    super.key,
    required this.nameController,
    required this.emailController,
  });

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                locale.translate(LangKeys.fullNameLabel),
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: nameController,
                decoration: _inputDecoration(hint: locale.translate(LangKeys.yourNameHint)),
                validator: (val) => val!.isEmpty ? locale.translate(LangKeys.requiredField) : null,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                locale.translate(LangKeys.emailLabel),
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: emailController,
                decoration: _inputDecoration(hint: locale.translate(LangKeys.yourEmailHint)),
                validator: (val) =>
                    (val!.isEmpty || !val.contains('@')) ? locale.translate(LangKeys.invalidEmailField) : null,
              ),
            ],
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({required String hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(fontSize: 13, color: Colors.grey[400]),
      filled: true,
      fillColor: Colors.grey[50],
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[200]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[200]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }
}
