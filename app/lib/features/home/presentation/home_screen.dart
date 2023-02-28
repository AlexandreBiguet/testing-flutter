import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/features/authenticate/presentation/auth_screen.dart';
import 'package:app/features/authenticate/domain/user.dart';
import 'package:app/features/authenticate/controller/auth_controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncAuth = ref.watch(authControllerProvider);

    return asyncAuth.when(data: (User? user) {
      if (user == null) {
        return const AuthScreen();
      } else {
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text('Hello ${user.email}'),
              ),
              Consumer(builder: (context, ref, _) {
                return ElevatedButton(
                    onPressed: () {
                      var auth = ref.read(authControllerProvider.notifier);
                      auth.signOut();
                    },
                    child: const Text('Log out'));
              })
            ],
          ),
        );
      }
    }, error: (err, stack) {
      return Scaffold(
        body: Center(
          child: Text('could not authenticate: $err'),
        ),
      );
    }, loading: () {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    });
  }
}
