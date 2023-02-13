import 'package:app/logic/login/login.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:app/presentation/welcome.dart';
import 'package:app/presentation/login.dart';
import 'package:app/presentation/home.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main.g.dart';

// We create a "provider", which will store a value (here "Hello world").
// By using a provider, this allows us to mock/override the value exposed.
@riverpod
String helloWorld(HelloWorldRef ref) {
  return 'Hello world';
}

// https://dev.to/carminezacc/user-authentication-jwt-authorization-with-flutter-and-node-176l
// https://dev.to/kcdchennai/how-jwt-json-web-token-authentication-works-21e7

void main() {
  runApp(
    const ProviderScope(
      child: MyOtherApp(),
    ),
  );
}

class MyOtherApp extends ConsumerWidget {
  const MyOtherApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String value = ref.watch(helloWorldProvider);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Example')),
        body: Center(
          child: Text(value),
        ),
      ),
    );
  }
}

final _router = GoRouter(
  initialLocation: '/welcome',
  routes: [
    GoRoute(
      path: '/welcome',
      name: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) {
        if (state.extra != null) {
          // https://stackoverflow.com/questions/72976031/flutter-go-router-how-to-pass-multiple-parameters-to-other-screen
          var loginFuture = state.extra as Future<LoginResponse>;
          return HomeScreen(isLoggedIn: loginFuture);
        } else {
          return const Scaffold(
            body: Center(
                child: Center(
              child: Text('coucou'),
            )),
          );
        }
      },
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}
