import 'dart:convert';

import 'package:logger/logger.dart';

import 'package:app/features/authenticate/domain/user.dart';
import 'package:app/features/authenticate/repository/auth_repository.dart';
import 'package:http/http.dart' as http;

var logger = Logger();

class Auth implements AuthRepository {
  User? _user;

  @override
  Future<User?> getUser() {
    return Future.value(_user);
  }

  @override
  Future<User> signIn(String email, String password) {
    // TODO: implement signIn
    throw UnimplementedError();
  }

  @override
  Future<User?> signOut() {
    _user = null;
    return getUser();
  }

  @override
  Future<User> signUp(String email, String password) async {
    var url = Uri.http("127.0.0.1:1234", "/auth/signup");

    Map payload = {
      "email": email,
      "password": password,
    };

    var encodedPayload = json.encode(payload);

    logger.i("sending request to $url with body: $encodedPayload");

    var response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          'Accept': 'application/json',
        },
        body: encodedPayload);

    logger.i(
        'received: ${json.decode(response.body)}, statusCode: ${response.statusCode}');

    if (200 == response.statusCode) {
      _user = User(email: email);
    } else {
      _user = null;
      throw "Couldn't signup";
    }

    return Future.value(_user);
  }
}
