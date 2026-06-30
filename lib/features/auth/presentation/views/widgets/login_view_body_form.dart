import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/routing/app_routes.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/core/widgets/custom_primary_button.dart';
import 'package:test_graduation/core/widgets/custom_text_form_field.dart';
import 'package:test_graduation/features/auth/presentation/cubits/signin_cubit/signin_cubit.dart';
import 'package:test_graduation/features/auth/presentation/views/widgets/or_divider.dart';
import 'package:test_graduation/features/auth/presentation/views/widgets/auth_button.dart';
import 'package:test_graduation/core/widgets/custom_login_register.dart';

class LoginViewBodyForm extends StatefulWidget {
  const LoginViewBodyForm({super.key});

  @override
  State<LoginViewBodyForm> createState() => _LoginViewBodyFormState();
}

class _LoginViewBodyFormState extends State<LoginViewBodyForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextFormField(
            controller: _emailController,
            textAlign: TextAlign.start,
            keyboardType: TextInputType.emailAddress,
            labelText: localizations.translate(LangKeys.email),
            hintText: localizations.translate(LangKeys.emailHint),
            prefixIcon: Icons.email_outlined,
            validator: (value) => (value == null || !value.contains('@'))
                ? localizations.translate(LangKeys.invalidEmail)
                : null,
          ),
          const SizedBox(height: 20),
          CustomTextFormField(
            controller: _passwordController,
            textAlign: TextAlign.start,
            obscureText: _obscurePassword,
            labelText: localizations.translate(LangKeys.password),
            hintText: localizations.translate(LangKeys.passwordHint),
            prefixIcon: Icons.lock_outline,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
            validator: (value) => (value == null || value.length < 6)
                ? localizations.translate(LangKeys.weakPassword)
                : null,
          ),
          const SizedBox(height: 12),
          Align(
            alignment: localizations.isEnLocale
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: TextButton(
              onPressed: () =>
                  GoRouter.of(context).pushNamed(AppRoutes.forgetPassword),
              child: Text(
                localizations.translate(LangKeys.forgotPassword),
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.primary
                      : Colors.blue,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          CustomPriamryButton(
            title: localizations.translate(LangKeys.loginButton),
            onPressed: _login,
          ),
          const SizedBox(height: 24),
          const OrDivider(),
          const SizedBox(height: 24),
          AuthButton(
            onPressed: () {},
            text: localizations.translate(LangKeys.googleLogin),
            icon: Icons.g_mobiledata,
          ),
          const SizedBox(height: 32),
          CustomLoginRegister(
            title: localizations.translate(LangKeys.dontHaveAccount),
            titleButton: localizations.translate(LangKeys.register),
            onPressed: () =>
                GoRouter.of(context).pushNamed(AppRoutes.registerScreen),
          ),
        ],
      ),
    );
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      context.read<SigninCubit>().signin(
        _emailController.text.trim(),
        _passwordController.text,
      );
    }
  }
}
