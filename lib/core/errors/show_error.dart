import 'package:flutter/material.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';

void showError(BuildContext context) {
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(
      content: Text(
          AppLocalizations.of(context)!.translate(LangKeys.pleaseSelectImage))));
}
