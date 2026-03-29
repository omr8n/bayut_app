import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_graduation/core/helper/my_app_method.dart';
import 'package:test_graduation/core/utils/strings_ar.dart';
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
          preferredCameraDevice: CameraDevice.front, // تفعيل الكاميرا الأمامية للسيلفي
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
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // اختيار الصورة الشخصية (سيلفي أو معرض)
          PickImageWidget(
            pickedImage: _pickedImage,
            function: _pickImage,
          ),
          const SizedBox(height: 24),

          CustomTextFormField(
            controller: _nameController,
            textAlign: TextAlign.right,
            labelText: AppStrings.fullName,
            textInputAction: TextInputAction.next,
            hintText: 'الاسم الكامل',
            prefixIcon: Icons.person_outline,
            onEditingComplete: () => FocusScope.of(context).requestFocus(_emailFocusNode),
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value == null || value.isEmpty) return 'يرجى إدخال الاسم';
              return null;
            },
          ),
          const SizedBox(height: 16),

          CustomTextFormField(
            focusNode: _emailFocusNode,
            textInputAction: TextInputAction.next,
            onEditingComplete: () => FocusScope.of(context).requestFocus(_phoneFocusNode),
            keyboardType: TextInputType.emailAddress,
            controller: _emailController,
            textAlign: TextAlign.right,
            labelText: AppStrings.email,
            hintText: 'example@email.com',
            prefixIcon: Icons.email_outlined,
            validator: (value) {
              if (value == null || value.isEmpty) return 'يرجى إدخال البريد';
              if (!value.contains('@')) return 'بريد غير صحيح';
              return null;
            },
          ),
          const SizedBox(height: 16),

          CustomTextFormField(
            focusNode: _phoneFocusNode,
            textInputAction: TextInputAction.next,
            onEditingComplete: () => FocusScope.of(context).requestFocus(_passFocusNode),
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            textAlign: TextAlign.right,
            labelText: AppStrings.phone,
            hintText: '+963...',
            prefixIcon: Icons.phone_outlined,
            validator: (value) {
              if (value == null || value.isEmpty) return 'يرجى إدخال رقم الهاتف';
              return null;
            },
          ),
          const SizedBox(height: 16),

          CustomTextFormField(
            focusNode: _passFocusNode,
            controller: _passwordController,
            obscureText: _obscurePassword,
            textAlign: TextAlign.right,
            textInputAction: TextInputAction.next,
            onEditingComplete: () => FocusScope.of(context).requestFocus(_confirmPassFocusNode),
            labelText: AppStrings.password,
            hintText: '••••••••',
            prefixIcon: Icons.lock_outline,
            suffixIcon: IconButton(
              icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'يرجى إدخال كلمة المرور';
              if (value.length < 6) return 'يجب أن تكون 6 أحرف على الأقل';
              return null;
            },
          ),
          const SizedBox(height: 16),

          CustomTextFormField(
            focusNode: _confirmPassFocusNode,
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            textAlign: TextAlign.right,
            labelText: AppStrings.confirmPassword,
            hintText: '••••••••',
            prefixIcon: Icons.lock_outline,
            suffixIcon: IconButton(
              icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
              onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'يرجى تأكيد كلمة المرور';
              if (value != _passwordController.text) return 'كلمة المرور غير متطابقة';
              return null;
            },
          ),
          const SizedBox(height: 32),

          CustomPriamryButton(
            title: AppStrings.register,
            onPressed: _register,
          ),
          const SizedBox(height: 24),

          CustomLoginRegister(
            title: AppStrings.alreadyHaveAccount,
            titleButton: AppStrings.login,
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
