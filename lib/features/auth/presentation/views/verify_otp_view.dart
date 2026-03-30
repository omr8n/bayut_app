// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';
// import 'package:test_graduation/core/routing/app_routes.dart';
// import 'package:test_graduation/core/utils/colors.dart';
// import 'package:test_graduation/core/widgets/custom_primary_button.dart';

// class VerifyOtpScreen extends StatefulWidget {
//   const VerifyOtpScreen({super.key});

//   @override
//   State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
// }

// class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
//   final formKey = GlobalKey<FormState>();
//   late TextEditingController pinCodeController;

//   @override
//   void initState() {
//     super.initState();
//     pinCodeController = TextEditingController();
//   }

//   @override
//   void dispose() {
//     pinCodeController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 22.w),
//           child: Form(
//             key: formKey,
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: 20.h),
//                   // 🔥 زر الرجوع الأنيق
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: IconButton(
//                       onPressed: () => GoRouter.of(context).pop(),
//                       icon: const Icon(Icons.arrow_back_ios_new_rounded),
//                       padding: EdgeInsets.zero,
//                     ),
//                   ),
//                   SizedBox(height: 30.h),
//                   Text(
//                     "تأكيد الرمز (OTP)",
//                     style: TextStyle(
//                       fontSize: 24.sp,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.primary,
//                     ),
//                   ),
//                   SizedBox(height: 10.h),
//                   Text(
//                     "يرجى إدخال رمز التحقق الذي أرسلناه للتو إلى بريدك الإلكتروني.",
//                     style: TextStyle(
//                       fontSize: 14.sp,
//                       color: AppColors.textSecondary,
//                     ),
//                   ),
//                   SizedBox(height: 40.h),
//                   // 🔥 حقل إدخال الرمز المنسق
//                   PinCodeTextField(
//                     appContext: context,
//                     length: 4,
//                     controller: pinCodeController,
//                     obscureText: false,
//                     animationType: AnimationType.scale,
//                     keyboardType: TextInputType.number,
//                     textStyle: TextStyle(
//                       fontSize: 22.sp,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.primary,
//                     ),
//                     pinTheme: PinTheme(
//                       shape: PinCodeFieldShape.box,
//                       borderRadius: BorderRadius.circular(12.r),
//                       fieldHeight: 60.h,
//                       fieldWidth: 70.w,
//                       activeFillColor: Colors.white,
//                       inactiveFillColor: Colors.white,
//                       selectedFillColor: Colors.white,
//                       activeColor: AppColors.primary,
//                       inactiveColor: Colors.grey.shade300,
//                       selectedColor: AppColors.secondary,
//                       borderWidth: 1.5,
//                     ),
//                     enableActiveFill: true,
//                     onChanged: (value) {},
//                     onCompleted: (value) {
//                       GoRouter.of(
//                         context,
//                       ).pushReplacement(AppRoutes.mainScreen);
//                     },
//                   ),
//                   SizedBox(height: 40.h),
//                   // 🔥 زر التأكيد الموحد
//                   CustomPriamryButton(
//                     title: "تأكيد",
//                     onPressed: () {
//                       if (pinCodeController.text.length == 4) {
//                         GoRouter.of(
//                           context,
//                         ).pushReplacement(AppRoutes.mainScreen);
//                       }
//                     },
//                   ),
//                   SizedBox(height: 30.h),
//                   // 🔥 رابط إعادة الإرسال
//                   Center(
//                     child: GestureDetector(
//                       onTap: () {
//                         // منطق إعادة الإرسال يوضع هنا
//                       },
//                       child: RichText(
//                         text: TextSpan(
//                           text: "لم يصلك الرمز؟ ",
//                           style: TextStyle(
//                             fontSize: 14.sp,
//                             color: AppColors.textSecondary,
//                             fontFamily: 'Dubai',
//                           ),
//                           children: [
//                             TextSpan(
//                               text: "إعادة الإرسال",
//                               style: TextStyle(
//                                 color: AppColors.secondary,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
