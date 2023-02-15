import 'package:freezed_annotation/freezed_annotation.dart';
part 'user.freezed.dart';

@freezed
class User with _$User {
  const factory User({
    required String email,
    String? username,
  }) = _User;

  // factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);
}
