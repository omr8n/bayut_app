import 'package:flutter/material.dart';

class SellerEmptyState extends StatelessWidget {
  const SellerEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.rate_review_outlined,
          size: 80,
          color: Colors.grey.shade300,
        ),
        const SizedBox(height: 16),
        const Text(
          'لا توجد تقييمات بعد',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          'كن أول من يقيم هذا المستخدم',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }
}
