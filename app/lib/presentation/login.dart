import 'package:app/logic/login/form_validators.dart';
import 'package:app/logic/login/login.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
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

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _pwdController = TextEditingController();
  final _login = LoginFactory.create();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.33,
          child: Column(
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

                    var fut = _login.signIn(LoginRequest(
                        _emailController.text, _pwdController.text));

                    context.go('/home', extra: fut);
                  }
                },
                child: const Text('Sign-in'),
              ),
              TextButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    logger.i('Sending create account request');
                    var fut = _login.signIn(LoginRequest(
                        _emailController.text, _pwdController.text));

                    context.go('/home', extra: fut);
                  }
                },
                child: const Text('Create account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LoginForm(),
    );
  }
}
