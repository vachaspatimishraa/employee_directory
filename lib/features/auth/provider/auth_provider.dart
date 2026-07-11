import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../settings/provider/theme_provider.dart';
import '../repository/auth_repository.dart';
import '../viewmodel/login_state.dart';
import '../viewmodel/login_viewmodel.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(sharedPrefServiceProvider));
});

final loginViewModelProvider = StateNotifierProvider<LoginViewModel, LoginState>((ref) {
  return LoginViewModel(ref.watch(authRepositoryProvider));
});
