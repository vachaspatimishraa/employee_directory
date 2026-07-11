class LoginState {
  final bool isLoading;
  final bool obscurePassword;
  final String? errorMessage;

  LoginState({
    this.isLoading = false,
    this.obscurePassword = true,
    this.errorMessage,
  });

  LoginState copyWith({
    bool? isLoading,
    bool? obscurePassword,
    String? errorMessage,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      errorMessage: errorMessage,
    );
  }
}
