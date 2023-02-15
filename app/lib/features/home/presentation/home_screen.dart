import 'package:app/features/authenticate/presentation/auth_screen.dart';
import 'package:app/features/authenticate/presentation/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

import 'package:app/features/authenticate/domain/user.dart';
import 'package:app/features/authenticate/data/auth_repository.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncAuth = ref.watch(authRepositoryProvider);

    return asyncAuth.when(data: (User? user) {
      if (user == null) {
        return const AuthScreen();
      } else {
        return Scaffold(
          body: Center(
            child: Text('Hello ${user.email}'),
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
