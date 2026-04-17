import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_graduation/core/helper/my_app_method.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/widgets/custom_login_register.dart';
import 'package:test_graduation/core/widgets/custom_primary_button.dart';
import 'package:test_graduation/core/widgets/custom_text_form_field.dart';
import 'package:test_graduation/core/widgets/pick_image_widget.dart';
import 'package:test_graduation/features/auth/presentation/cubits/signup_cubits/signup_cubit.dart';

class RegisterViewBodyForm extends StatefulWidget {
  const RegisterViewBodyForm({super.key});

  @override
  State<RegisterViewBodyForm> createState() => _RegisterViewBodyFormState();
}

class _RegisterViewBodyFormState extends State<RegisterViewBodyForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  XFile? _pickedImage;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final _passFocusNode = FocusNode();
  final _confirmPassFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _passFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    _confirmPassFocusNode.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    await MyAppMethods.imagePickerDialog(
      context: context,
      cameraFCT: () async {
        final XFile? image = await picker.pickImage(
          source: ImageSource.camera,
          preferredCameraDevice: CameraDevice.front,
          imageQuality: 50,
        );
        if (image != null) setState(() => _pickedImage = image);
      },
      galleryFCT: () async {
        final XFile? image = await picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 50,
        );
        if (image != null) setState(() => _pickedImage = image);
      },
      removeFCT: () {
        setState(() => _pickedImage = null);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PickImageWidget(
            pickedImage: _pickedImage,
            function: _pickImage,
          ),
          const SizedBox(height: 24),

          CustomTextFormField(
            controller: _nameController,
            textAlign: TextAlign.start,
            labelText: localizations.translate(LangKeys.fullName),
            textInputAction: TextInputAction.next,
            hintText: localizations.translate(LangKeys.fullNameHint),
            prefixIcon: Icons.person_outline,
            onEditingComplete: () => FocusScope.of(context).requestFocus(_emailFocusNode),
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value == null || value.isEmpty) return localizations.translate(LangKeys.pleaseEnterName);
              return null;
            },
          ),
          const SizedBox(height: 16),

          CustomTextFormField(
            focusNode: _emailFocusNode,
            textAlign: TextAlign.start,
            textInputAction: TextInputAction.next,
            onEditingComplete: () => FocusScope.of(context).requestFocus(_phoneFocusNode),
            keyboardType: TextInputType.emailAddress,
            controller: _emailController,
            labelText: localizations.translate(LangKeys.email),
            hintText: localizations.translate(LangKeys.emailHint),
            prefixIcon: Icons.email_outlined,
            validator: (value) {
              if (value == null || value.isEmpty) return localizations.translate(LangKeys.pleaseEnterEmail);
              if (!value.contains('@')) return localizations.translate(LangKeys.invalidEmail);
              return null;
            },
          ),
          const SizedBox(height: 16),

          CustomTextFormField(
            focusNode: _phoneFocusNode,
            textAlign: TextAlign.start,
            textInputAction: TextInputAction.next,
            onEditingComplete: () => FocusScope.of(context).requestFocus(_passFocusNode),
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            labelText: localizations.translate(LangKeys.phone),
            hintText: localizations.translate(LangKeys.phoneHint),
            prefixIcon: Icons.phone_outlined,
            validator: (value) {
              if (value == null || value.isEmpty) return localizations.translate(LangKeys.pleaseEnterPhone);
              return null;
            },
          ),
          const SizedBox(height: 16),

          CustomTextFormField(
            focusNode: _passFocusNode,
            textAlign: TextAlign.start,
            controller: _passwordController,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.next,
            onEditingComplete: () => FocusScope.of(context).requestFocus(_confirmPassFocusNode),
            labelText: localizations.translate(LangKeys.password),
            hintText: localizations.translate(LangKeys.passwordHint),
            prefixIcon: Icons.lock_outline,
            suffixIcon: IconButton(
              icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return localizations.translate(LangKeys.pleaseEnterPassword);
              if (value.length < 6) return localizations.translate(LangKeys.passwordTooShort);
              return null;
            },
          ),
          const SizedBox(height: 16),

          CustomTextFormField(
            focusNode: _confirmPassFocusNode,
            textAlign: TextAlign.start,
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            labelText: localizations.translate(LangKeys.confirmPassword),
            hintText: localizations.translate(LangKeys.passwordHint),
            prefixIcon: Icons.lock_outline,
            suffixIcon: IconButton(
              icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
              onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return localizations.translate(LangKeys.pleaseConfirmPassword);
              if (value != _passwordController.text) return localizations.translate(LangKeys.passwordsDontMatch);
              return null;
            },
          ),
          const SizedBox(height: 32),

          CustomPriamryButton(
            title: localizations.translate(LangKeys.register),
            onPressed: _register,
          ),
          const SizedBox(height: 24),

          CustomLoginRegister(
            title: localizations.translate(LangKeys.alreadyHaveAccount),
            titleButton: localizations.translate(LangKeys.login),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      context.read<SignupCubit>().createUserWithEmailAndPassword(
            _emailController.text.trim(),
            _passwordController.text.trim(),
            _nameController.text.trim(),
            _phoneController.text.trim(),
            imageFile: _pickedImage,
          );
    }
  }
}
