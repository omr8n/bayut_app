import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';

class TrendingStatusCard extends StatelessWidget {
  final PropertyEntity property;
  final int rank; // 🔥 الترتيب الحالي (مثلاً #2)

  const TrendingStatusCard({super.key, required this.property, required this.rank});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7F2), // برتقالي باهت جداً
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFFFFE0B2), width: 1.5),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFE0B2),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.trending_up_rounded, color: Colors.orange.shade800, size: 20.sp),
              ),
              Row(
                children: [
                  Text(
                    'تهانينا! عقارك ضمن التريند 🔥',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                      color: Colors.orange.shade900,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('الأكثر مشاهدة', style: TextStyle(color: Colors.grey.shade400, fontSize: 11.sp)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'ترتيبك الحالي: #$rank',
                      style: TextStyle(
                        color: Colors.orange.shade800,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.sp,
                      ),
                    ),
                    Text(
                      'مؤهل للتريند حتى: 2026/07/28',
                      style: TextStyle(color: Colors.orange.shade200, fontSize: 10.sp),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
