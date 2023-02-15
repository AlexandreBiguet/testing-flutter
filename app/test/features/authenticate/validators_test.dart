import 'package:app/features/authenticate/domain/validators.dart';
import 'package:test/test.dart';

void main() {
  group('login form', () {
    group('validator', () {
      group('email', () {
        test('returns false when input is null', () {
          expect(validateEmail(null), false);
        });

        test('returns false when input string is not an email address', () {
          expect(validateEmail('foo'), false);
        });

        test('returns true when input string is an email address', () {
          expect(validateEmail('foo@example.com'), true);
        });
      });

      group('password', () {
        test('returns false when input password is null', () {
          expect(validatePassword(null), false);
        });
        test('password must be at least 8 char long', () {
          expect(validatePassword('foo'), false);
        });
      });
    });
  });
}
