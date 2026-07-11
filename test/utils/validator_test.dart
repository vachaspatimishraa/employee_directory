import 'package:flutter_test/flutter_test.dart';
import 'package:employee_directory/core/utils/validators.dart';

void main() {
  group('Validators Test', () {
    test('Email validation - empty email', () {
      final result = Validators.validateEmail('');
      expect(result, 'Email is required');
    });

    test('Email validation - invalid email', () {
      final result = Validators.validateEmail('invalid_email');
      expect(result, 'Please enter a valid email address');
    });

    test('Email validation - valid email', () {
      final result = Validators.validateEmail('test@example.com');
      expect(result, isNull);
    });

    test('Password validation - empty password', () {
      final result = Validators.validatePassword('');
      expect(result, 'Password is required');
    });

    test('Password validation - short password', () {
      final result = Validators.validatePassword('123');
      expect(result, 'Password must be at least 6 characters long');
    });

    test('Password validation - valid password', () {
      final result = Validators.validatePassword('password123');
      expect(result, isNull);
    });
  });
}
