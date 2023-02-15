import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:app/features/home/presentation/home_screen.dart';
// import 'package:app/features/authenticate/presentation/auth_form_screen.dart';
// import 'package:app/features/authenticate/presentation/welcome_screen.dart';

final _router = GoRouter(
  initialLocation: '/home',
  routes: [
    // GoRoute(
    //   path: '/welcome',
    //   name: 'welcome',
    //   builder: (context, state) => const WelcomeScreen(),
    // ),
    // GoRoute(
    //   path: '/login',
    //   name: "login",
    //   builder: (context, state) => const AuthFormScreen(),
    // ),
    GoRoute(
      path: '/home',
      name: "home",
      builder: (context, state) => const HomeScreen(),
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
