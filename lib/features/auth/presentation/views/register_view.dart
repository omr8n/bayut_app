import 'package:flutter/material.dart';

import 'package:test_graduation/features/auth/presentation/views/widgets/register_view_body.dart';

// شاشة إنشاء حساب
class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  @override
  Widget build(BuildContext context) {
    return RegisterViewBody();
  }
}
