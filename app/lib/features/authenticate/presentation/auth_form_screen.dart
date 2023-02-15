import 'package:app/features/authenticate/data/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:app/features/authenticate/domain/validators.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthFormScreen extends StatefulWidget {
  const AuthFormScreen({super.key});

  @override
  State<AuthFormScreen> createState() => _AuthFormScreenState();
}

String? _validateEmail(String? email) {
  if (!validateEmail(email)) {
    return "Not a valid email address";
  }
  return null;
}

String? _validatePwd(String? pwd) {
  if (!validatePassword(pwd)) {
    return "Password must be 8 characters long at least";
  }
  return null;
}

var logger = Logger();

class _AuthFormScreenState extends State<AuthFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _pwdController = TextEditingController();
  final _login = AuthRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.33,
            child: Consumer(
              builder: (context, ref, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      validator: (value) => _validateEmail(value),
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'email'),
                    ),
                    TextFormField(
                      controller: _pwdController,
                      validator: (value) => _validatePwd(value),
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'password'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          logger.i('Sending sign in request');
                          ref.read(authRepositoryProvider.notifier).signIn(
                              _emailController.text, _pwdController.text);
                        }
                      },
                      child: const Text('Sign-in'),
                    ),
                    TextButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          logger.i('Sending create account request');
                          ref.read(authRepositoryProvider.notifier).signUp(
                              _emailController.text, _pwdController.text);
                        }
                      },
                      child: const Text('Create account'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
