import 'package:flutter/material.dart';

void showError(BuildContext context) {
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(const SnackBar(content: Text('Please select an image')));
}
