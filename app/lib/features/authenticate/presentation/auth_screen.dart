import 'package:app/features/authenticate/presentation/auth_form_screen.dart';
import 'package:app/features/authenticate/presentation/welcome_screen.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool welcomed = false;

  @override
  Widget build(BuildContext context) {
    if (welcomed) {
      return const AuthFormScreen();
    } else {
      return WelcomeScreen(onSignIn: _welcomed, onSignUp: _welcomed);
    }
  }

  void _welcomed() {
    setState(() {
      welcomed = true;
    });
  }
}
