import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';

class PremiumCountdownTimer extends StatefulWidget {
  final PropertyEntity property;

  const PremiumCountdownTimer({super.key, required this.property});

  @override
  State<PremiumCountdownTimer> createState() => _PremiumCountdownTimerState();
}

class _PremiumCountdownTimerState extends State<PremiumCountdownTimer> {
  late Timer _timer;
  Duration _remainingTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    _calculateRemainingTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _calculateRemainingTime();
    });
  }

  void _calculateRemainingTime() {
    if (widget.property.premiumExpiryDate == null) return;

    final now = DateTime.now();
    final expiry = widget.property.premiumExpiryDate!;

    if (expiry.isAfter(now)) {
      setState(() {
        _remainingTime = expiry.difference(now);
      });
    } else {
      setState(() {
        _remainingTime = Duration.zero;
      });
      _timer.cancel();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.property.premiumExpiryDate == null ||
        _remainingTime.isNegative ||
        _remainingTime == Duration.zero) {
      return const SizedBox.shrink();
    }

    final days = _remainingTime.inDays;
    final hours = _remainingTime.inHours % 24;

    // حساب النسبة المئوية لشريط التقدم (بفرض البداية 30 يوم أو 7 أيام)
    // حالياً سنفترض الحد الأقصى 30 يوم للجمالية
    double progress = _remainingTime.inSeconds / (30 * 24 * 60 * 60);
    progress = progress.clamp(0.0, 1.0);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.stars_rounded,
                    color: Colors.amber.shade700,
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'تميز عقارك نشط حالياً 🏆',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                      color: Colors.blue.shade900,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  'باقي $days يوم و $hours ساعة',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8.h,
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'تاريخ الانتهاء:',
                style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade600),
              ),
              Text(
                '${widget.property.premiumExpiryDate!.year}/${widget.property.premiumExpiryDate!.month}/${widget.property.premiumExpiryDate!.day}',
                style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
