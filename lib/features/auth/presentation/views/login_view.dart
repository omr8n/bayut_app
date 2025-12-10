import 'package:flutter/material.dart';

import 'package:test_graduation/features/auth/presentation/views/widgets/login_view_body.dart';

// شاشة تسجيل الدخول
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return LoginViewBody();
  }
}
