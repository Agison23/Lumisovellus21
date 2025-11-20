import 'package:flutter/material.dart';
import 'register_form.dart';
import 'login_form.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  bool _isRegister = true;

  void _showLogin() {
    setState(() {
      _isRegister = false;
    });
  }

  void _showRegister() {
    setState(() {
      _isRegister = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: _isRegister
          ? RegisterForm(
              key: const ValueKey('registerForm'),
              onSwitchToLogin: _showLogin,
            )
          : LoginForm(
              key: const ValueKey('loginForm'),
              onSwitchToRegister: _showRegister,
            ),
    );
  }
}
