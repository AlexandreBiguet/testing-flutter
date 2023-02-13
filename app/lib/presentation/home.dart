import 'package:app/logic/login/login.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final Future<LoginResponse>? isLoggedIn;

  const HomeScreen({this.isLoggedIn, super.key});

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn == null) {
      return Scaffold(
        body: Center(child: Text('mmmm')),
      );
    }
    return Scaffold(
      body: FutureBuilder(
        future: isLoggedIn,
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return const Center(
              child: Text('Hello, World'),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Hello errors'),
            );
          } else {
            return Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('Logging in...'),
                ),
              ],
            );
          }
        }),
      ),
    );
  }
}
