import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  // This widget is the root of your application.
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
                onPressed: () => context.go('/login'),
                child: const Text("Sign in"),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account yet?"),
                TextButton(
                  onPressed: () => context.go('/login'),
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
