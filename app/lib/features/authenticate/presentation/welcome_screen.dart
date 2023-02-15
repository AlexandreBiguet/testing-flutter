import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  final VoidCallback onSignIn;
  final VoidCallback onSignUp;

  const WelcomeScreen(
      {required this.onSignIn, required this.onSignUp, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to Testing Flutter',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            SizedBox(
              width: 280,
              child: ElevatedButton(
                onPressed: onSignIn,
                child: const Text("Sign in"),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account yet?"),
                TextButton(
                  onPressed: onSignUp,
                  child: const Text('Create an account'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
