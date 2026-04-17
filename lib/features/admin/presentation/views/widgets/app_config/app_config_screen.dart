import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/models/app_config_model.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/core/utils/styles.dart';
import 'package:test_graduation/features/admin/presentation/manager/app_config_cubit/app_config_cubit.dart';
import 'package:test_graduation/features/admin/presentation/manager/app_config_cubit/app_config_state.dart';

class AppConfigScreen extends StatefulWidget {
  const AppConfigScreen({super.key});

  @override
  State<AppConfigScreen> createState() => _AppConfigScreenState();
}

class _AppConfigScreenState extends State<AppConfigScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController priceController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController termsController;
  bool maintenanceMode = false;

  @override
  void initState() {
    super.initState();
    context.read<AppConfigCubit>().fetchConfig();
    priceController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    termsController = TextEditingController();
  }

  void _updateControllers(AppConfigModel config) {
    priceController.text = config.featuredPropertyPrice.toString();
    emailController.text = config.contactEmail;
    phoneController.text = config.contactPhone;
    termsController.text = config.termsOfService;
    maintenanceMode = config.maintenanceMode;
  }

  @override
  void dispose() {
    priceController.dispose();
    emailController.dispose();
    phoneController.dispose();
    termsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("إعدادات المنصة", style: Styles.textStyle18),
        centerTitle: true,
      ),
      body: BlocConsumer<AppConfigCubit, AppConfigState>(
        listener: (context, state) {
          if (state is AppConfigSuccess) {
            _updateControllers(state.config);
          } else if (state is AppConfigUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("تم حفظ الإعدادات بنجاح"), backgroundColor: AppColors.success),
            );
          } else if (state is AppConfigFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errMessage), backgroundColor: AppColors.error),
            );
          }
        },
        builder: (context, state) {
          if (state is AppConfigLoading && state is! AppConfigSuccess) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("الأسعار والخدمات"),
                  _buildTextField(
                    label: "سعر تمييز العقار (Featured)",
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    icon: Icons.monetization_on,
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle("معلومات التواصل"),
                  _buildTextField(
                    label: "بريد الدعم الفني",
                    controller: emailController,
                    icon: Icons.email,
                  ),
                  _buildTextField(
                    label: "رقم هاتف التواصل",
                    controller: phoneController,
                    icon: Icons.phone,
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle("الحالة العامة"),
                  SwitchListTile(
                    title: const Text("وضع الصيانة (Maintenance Mode)", style: Styles.textStyle16),
                    subtitle: const Text("سيمنع المستخدمين من دخول التطبيق مؤقتاً"),
                    value: maintenanceMode,
                    activeColor: AppColors.primary,
                    onChanged: (val) => setState(() => maintenanceMode = val),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _saveConfig,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("حفظ التغييرات", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(title, style: Styles.textStyle18.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    IconData? icon,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon != null ? Icon(icon) : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) => value!.isEmpty ? "هذا الحقل مطلوب" : null,
      ),
    );
  }

  void _saveConfig() {
    if (_formKey.currentState!.validate()) {
      final config = AppConfigModel(
        featuredPropertyPrice: double.parse(priceController.text),
        contactEmail: emailController.text,
        contactPhone: phoneController.text,
        termsOfService: termsController.text,
        privacyPolicy: '',
        maintenanceMode: maintenanceMode,
      );
      context.read<AppConfigCubit>().updateConfig(config);
    }
  }
}
