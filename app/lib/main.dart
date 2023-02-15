import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/app.dart';

// https://dev.to/carminezacc/user-authentication-jwt-authorization-with-flutter-and-node-176l
// https://dev.to/kcdchennai/how-jwt-json-web-token-authentication-works-21e7

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
