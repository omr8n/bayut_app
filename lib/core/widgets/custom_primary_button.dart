import 'package:flutter/material.dart';

class CustomPriamryButton extends StatelessWidget {
  const CustomPriamryButton({super.key, required this.title, this.onPressed});
  final String title;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
      ),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
