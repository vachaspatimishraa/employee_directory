import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:employee_directory/features/auth/viewmodel/login_viewmodel.dart';
import 'package:employee_directory/features/auth/repository/auth_repository.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late LoginViewModel loginViewModel;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    loginViewModel = LoginViewModel(mockAuthRepository);
  });

  group('LoginViewModel Tests', () {
    test('Initial state is correct', () {
      final state = loginViewModel.state;
      expect(state.isLoading, false);
      expect(state.obscurePassword, true);
      expect(state.errorMessage, isNull);
    });

    test('togglePasswordVisibility updates obscurePassword state', () {
      loginViewModel.togglePasswordVisibility();
      expect(loginViewModel.state.obscurePassword, false);
      
      loginViewModel.togglePasswordVisibility();
      expect(loginViewModel.state.obscurePassword, true);
    });

    test('login fails with invalid email validation', () async {
      final result = await loginViewModel.login('invalid_email', '123456');
      expect(result, false);
      expect(loginViewModel.state.errorMessage, 'Please enter a valid email address');
    });

    test('login fails with short password validation', () async {
      final result = await loginViewModel.login('test@example.com', '123');
      expect(result, false);
      expect(loginViewModel.state.errorMessage, 'Password must be at least 6 characters long');
    });

    test('login succeeds with correct credentials', () async {
      when(() => mockAuthRepository.saveEmail(any())).thenAnswer((_) async => {});

      final result = await loginViewModel.login('test@example.com', '123456');
      expect(result, true);
      expect(loginViewModel.state.isLoading, false);
      expect(loginViewModel.state.errorMessage, isNull);
      verify(() => mockAuthRepository.saveEmail('test@example.com')).called(1);
    });
  });
}
