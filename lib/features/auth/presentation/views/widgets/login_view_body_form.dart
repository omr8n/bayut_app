import 'package:flutter/material.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/core/utils/strings_ar.dart';
import 'package:test_graduation/core/widgets/custom_login_register.dart';
import 'package:test_graduation/core/widgets/custom_text_form_field.dart';
import 'package:test_graduation/features/auth/presentation/views/register_view.dart';
import 'package:test_graduation/features/auth/presentation/views/widgets/auth_button.dart';
import 'package:test_graduation/features/auth/presentation/views/widgets/forget_password.dart';
import 'package:test_graduation/features/auth/presentation/views/widgets/or_divider.dart';

class LoginViewBodyForm extends StatefulWidget {
  const LoginViewBodyForm({super.key});

  @override
  State<LoginViewBodyForm> createState() => _LoginViewBodyFormState();
}

class _LoginViewBodyFormState extends State<LoginViewBodyForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // البريد الإلكتروني
          CustomTextFormField(
            controller: _emailController,
            focusNode: _emailFocusNode,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onEditingComplete: () =>
                FocusScope.of(context).requestFocus(_passwordFocusNode),
            textAlign: TextAlign.right,
            labelText: AppStrings.email,
            hintText: 'example@email.com',
            prefixIcon: Icons.email_outlined,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'يرجى إدخال البريد الإلكتروني';
              }
              if (!value.contains('@')) {
                return 'بريد إلكتروني غير صحيح';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // كلمة المرور
          CustomTextFormField(
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            obscureText: _obscurePassword,
            textAlign: TextAlign.right,
            textInputAction: TextInputAction.done,
            onEditingComplete: _login,
            labelText: AppStrings.password,
            hintText: '••••••••',
            prefixIcon: Icons.lock_outline,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
                setState(() => _obscurePassword = !_obscurePassword);
              },
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'يرجى إدخال كلمة المرور';
              }
              if (value.length < 6) {
                return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),

          FogetPassword(),
          const SizedBox(height: 24),

          // زر تسجيل الدخول
          ElevatedButton(
            onPressed: _login,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              AppStrings.login,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 24),

          OrDivider(),
          const SizedBox(height: 24),

          AuthButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('سيتم إضافة Firebase Auth لاحقاً'),
                ),
              );
            },
            text: 'تسجيل بواسطة Google',
            icon: Icons.g_mobiledata,
          ),
          const SizedBox(height: 32),

          CustomLoginRegister(
            title: AppStrings.dontHaveAccount,
            titleButton: AppStrings.register,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegisterView()),
              );
            },
          ),
        ],
      ),
    );
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم تسجيل الدخول بنجاح!'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    }
  }
}
