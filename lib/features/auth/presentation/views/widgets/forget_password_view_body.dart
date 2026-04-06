import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/core/utils/strings_ar.dart';
import 'package:test_graduation/core/widgets/custom_primary_button.dart';
import 'package:test_graduation/core/widgets/custom_text_form_field.dart';
import 'package:test_graduation/features/auth/presentation/manager/forget_password_cubit/forget_password_cubit.dart';

class ForgetPasswordViewBody extends StatefulWidget {
  const ForgetPasswordViewBody({super.key});

  @override
  State<ForgetPasswordViewBody> createState() => _ForgetPasswordViewBodyState();
}

class _ForgetPasswordViewBodyState extends State<ForgetPasswordViewBody> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'إعادة تعيين كلمة المرور',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'أدخل بريدك الإلكتروني لإستلام رابط تغيير كلمة المرور',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 40),
              CustomTextFormField(
                textAlign: TextAlign.right,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                labelText: AppStrings.email,
                hintText: 'example@email.com',
                prefixIcon: Icons.email_outlined,
                validator: (value) => (value == null || !value.contains('@'))
                    ? 'بريد إلكتروني غير صحيح'
                    : null,
              ),
              const SizedBox(height: 40),

              CustomPriamryButton(
                title: 'إرسال الرابط',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<ForgetPasswordCubit>().resetPassword(
                      _emailController.text.trim(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
