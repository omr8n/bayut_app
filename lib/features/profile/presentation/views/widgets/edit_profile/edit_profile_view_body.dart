import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_graduation/core/helper/my_app_method.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/core/widgets/custom_primary_button.dart';
import 'package:test_graduation/core/widgets/custom_text_form_field.dart';
import 'package:test_graduation/core/widgets/pick_image_widget.dart';
import 'package:test_graduation/features/auth/domain/entites/user_entity.dart';
import 'package:test_graduation/features/profile/presentation/manager/edit_profile_cubit/edit_profile_cubit.dart';

class EditProfileViewBody extends StatefulWidget {
  final UserEntity user;
  final bool isPasswordChange;
  const EditProfileViewBody({
    super.key,
    required this.user,
    this.isPasswordChange = false,
  });

  @override
  State<EditProfileViewBody> createState() => _EditProfileViewBodyState();
}

class _EditProfileViewBodyState extends State<EditProfileViewBody> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  final _oldPasswordFocusNode = FocusNode();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  XFile? _pickedImage;
  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _phoneController = TextEditingController(text: widget.user.phoneNumber);
    _emailController = TextEditingController(text: widget.user.email);

    if (widget.isPasswordChange) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
        FocusScope.of(context).requestFocus(_oldPasswordFocusNode);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _scrollController.dispose();
    _oldPasswordFocusNode.dispose();
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
    final locale = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Picker - Custom design
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: _pickedImage != null
                          ? Image.file(
                              File(_pickedImage!.path),
                              fit: BoxFit.cover,
                            )
                          : widget.user.profilePic != null
                          ? Image.network(
                              widget.user.profilePic!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.person, size: 80),
                            )
                          : const Icon(Icons.person, size: 80),
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            _buildSectionTitle(locale.translate(LangKeys.personalInfo)),
            const SizedBox(height: 16),
            CustomTextFormField(
              controller: _nameController,
              textAlign: locale.isEnLocale ? TextAlign.left : TextAlign.right,
              labelText: locale.translate(LangKeys.fullName),
              prefixIcon: Icons.person_outline,
              validator: (value) => value!.isEmpty
                  ? locale.translate(LangKeys.pleaseEnterName)
                  : null,
            ),
            const SizedBox(height: 16),
            CustomTextFormField(
              controller: _phoneController,
              textAlign: locale.isEnLocale ? TextAlign.left : TextAlign.right,
              labelText: locale.translate(LangKeys.phone),
              prefixIcon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: (value) => value!.isEmpty
                  ? locale.translate(LangKeys.pleaseEnterPhone)
                  : null,
            ),
            const SizedBox(height: 16),
            CustomTextFormField(
              controller: _emailController,
              textAlign: locale.isEnLocale ? TextAlign.left : TextAlign.right,
              labelText: locale.translate(LangKeys.email),
              prefixIcon: Icons.email_outlined,
              readOnly: true, // Email change usually needs more auth steps
              hintText: locale.translate(LangKeys.cannotChangeEmail),
            ),

            const SizedBox(height: 32),
            _buildSectionTitle(
              locale.translate(LangKeys.changePasswordOptional),
            ),
            const SizedBox(height: 16),
            CustomTextFormField(
              focusNode: _oldPasswordFocusNode,
              controller: _oldPasswordController,
              textAlign: locale.isEnLocale ? TextAlign.left : TextAlign.right,
              labelText: locale.translate(LangKeys.currentPassword),
              prefixIcon: Icons.lock_outline,
              obscureText: _obscureOldPassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureOldPassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () =>
                    setState(() => _obscureOldPassword = !_obscureOldPassword),
              ),
              validator: (value) {
                if (_newPasswordController.text.isNotEmpty &&
                    (value == null || value.isEmpty)) {
                  return locale.translate(
                    LangKeys.pleaseEnterPassword,
                  ); // Or a more specific one
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomTextFormField(
              controller: _newPasswordController,
              textAlign: locale.isEnLocale ? TextAlign.left : TextAlign.right,
              labelText: locale.translate(LangKeys.newPassword),
              prefixIcon: Icons.lock_reset_outlined,
              obscureText: _obscureNewPassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureNewPassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () =>
                    setState(() => _obscureNewPassword = !_obscureNewPassword),
              ),
              validator: (value) {
                if (value != null && value.isNotEmpty && value.length < 6) {
                  return locale.translate(LangKeys.at_least_6_characters);
                }
                return null;
              },
            ),
            const SizedBox(height: 40),

            CustomPriamryButton(
              title: locale.translate(LangKeys.save),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<EditProfileCubit>().updateProfile(
                    currentUser: widget.user,
                    name: _nameController.text.trim(),
                    phone: _phoneController.text.trim(),
                    email: _emailController.text.trim(),
                    oldPassword: _oldPasswordController.text.isNotEmpty
                        ? _oldPasswordController.text
                        : null,
                    newPassword: _newPasswordController.text.isNotEmpty
                        ? _newPasswordController.text
                        : null,
                    imageFile: _pickedImage,
                  );
                }
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
    );
  }
}
