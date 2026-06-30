import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/utils/colors.dart';
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
    final localizations = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                localizations.translate(LangKeys.resetPassword),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.primary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                localizations.translate(LangKeys.resetPasswordInstructions),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
              ),
              const SizedBox(height: 40),
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
              const SizedBox(height: 40),

              CustomPriamryButton(
                title: localizations.translate(LangKeys.sendResetLink),
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
