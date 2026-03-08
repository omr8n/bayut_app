import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingManager extends StatelessWidget {
  const LoadingManager({
    super.key,
    required this.isLoading,
    required this.child,
    this.message, // حقل جديد للرسالة
  });

  final bool isLoading;
  final Widget child;
  final String? message; // نص الرسالة اختياري

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading) ...[
          // خلفية معتمة
          Container(color: Colors.black.withValues(alpha: 0.7)),
          // أيقونة التحميل مع النص
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SpinKitFadingFour(color: Colors.white, size: 50),
                if (message != null) ...[
                  const SizedBox(height: 20),
                  Text(
                    message!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}
