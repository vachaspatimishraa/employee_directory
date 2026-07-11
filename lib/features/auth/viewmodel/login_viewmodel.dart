import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/auth_repository.dart';
import '../../../core/utils/validators.dart';
import 'login_state.dart';

class LoginViewModel extends StateNotifier<LoginState> {
  final AuthRepository _authRepository;

  LoginViewModel(this._authRepository) : super(LoginState());

  void togglePasswordVisibility() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  String? validateEmail(String? email) {
    return Validators.validateEmail(email);
  }

  String? validatePassword(String? password) {
    return Validators.validatePassword(password);
  }

  Future<bool> login(String email, String password) async {
    final emailError = validateEmail(email);
    final passwordError = validatePassword(password);

    if (emailError != null || passwordError != null) {
      state = state.copyWith(errorMessage: emailError ?? passwordError);
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // Small delay for better UX
      await Future.delayed(const Duration(milliseconds: 500));
      
      final existingUser = await _authRepository.getUserByEmail(email);
      
      if (existingUser == null) {
        // Case: New User - Automatically register and login
        await _authRepository.createUser(email, password);
        await _authRepository.saveEmail(email);
        state = state.copyWith(isLoading: false);
        return true;
      } else {
        // Case: Existing User - Verify password
        if (existingUser.password == password) {
          await _authRepository.saveEmail(email);
          state = state.copyWith(isLoading: false);
          return true;
        } else {
          state = state.copyWith(
            isLoading: false, 
            errorMessage: 'Incorrect password. Please try again.'
          );
          return false;
        }
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Authentication error: $e');
      return false;
    }
  }
}
