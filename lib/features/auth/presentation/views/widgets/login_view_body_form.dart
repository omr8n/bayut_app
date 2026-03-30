import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/core/routing/app_routes.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/core/utils/strings_ar.dart';
import 'package:test_graduation/core/widgets/custom_primary_button.dart';
import 'package:test_graduation/core/widgets/custom_text_form_field.dart';
import 'package:test_graduation/features/auth/presentation/cubits/signin_cubit/signin_cubit.dart'; // 🔥
import 'package:test_graduation/features/auth/presentation/views/widgets/forget_password.dart';
import 'package:test_graduation/features/auth/presentation/views/widgets/or_divider.dart';
import 'package:test_graduation/features/auth/presentation/views/widgets/auth_button.dart';
import 'package:test_graduation/core/widgets/custom_login_register.dart';
import 'package:test_graduation/features/auth/presentation/views/register_view.dart';

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
    // 🔥 نستخدم BlocListener لمراقبة النتيجة الحقيقية من السيرفر
    return BlocListener<SigninCubit, SigninState>(
      listener: (context, state) {
        if (state is SigninSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم تسجيل الدخول بنجاح!'),
              backgroundColor: AppColors.success,
            ),
          );
          GoRouter.of(context).pushReplacement(AppRoutes.mainScreen);
        } else if (state is SigninFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextFormField(
              textAlign: TextAlign.right,
              controller: _emailController,
              focusNode: _emailFocusNode,
              keyboardType: TextInputType.emailAddress,
              labelText: AppStrings.email,
              hintText: 'example@email.com',
              prefixIcon: Icons.email_outlined,
              validator: (value) => (value == null || !value.contains('@'))
                  ? 'بريد إلكتروني غير صحيح'
                  : null,
            ),
            const SizedBox(height: 20),
            CustomTextFormField(
              textAlign: TextAlign.right,
              controller: _passwordController,
              focusNode: _passwordFocusNode,
              obscureText: _obscurePassword,
              labelText: AppStrings.password,
              hintText: '••••••••',
              prefixIcon: Icons.lock_outline,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
              validator: (value) => (value == null || value.length < 6)
                  ? 'كلمة المرور ضعيفة'
                  : null,
            ),
            const SizedBox(height: 12),
            const FogetPassword(),
            const SizedBox(height: 24),

            // 🔥 زر تسجيل الدخول مع حالة التحميل
            CustomPriamryButton(title: AppStrings.login, onPressed: _login),
            const SizedBox(height: 24),
            const OrDivider(),
            const SizedBox(height: 24),
            AuthButton(
              onPressed: () {},
              text: 'تسجيل بواسطة Google',
              icon: Icons.g_mobiledata,
            ),
            const SizedBox(height: 32),
            CustomLoginRegister(
              title: AppStrings.dontHaveAccount,
              titleButton: AppStrings.register,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegisterView()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      // 🔥 الآن نرسل البيانات فعلياً للـ Cubit ليفحصها في Firebase
      context.read<SigninCubit>().signin(
        _emailController.text.trim(),
        _passwordController.text,
      );
    }
  }
}
