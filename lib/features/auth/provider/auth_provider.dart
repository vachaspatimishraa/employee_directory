import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/isar_provider.dart';
import '../../settings/provider/theme_provider.dart';
import '../repository/auth_repository.dart';
import '../viewmodel/login_state.dart';
import '../viewmodel/login_viewmodel.dart';
import '../viewmodel/admin_profile_state.dart';
import '../viewmodel/admin_profile_viewmodel.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    ref.read(sharedPrefServiceProvider),
    ref.read(isarProvider),
  );
});

final loginViewModelProvider = StateNotifierProvider<LoginViewModel, LoginState>((ref) {
  return LoginViewModel(ref.watch(authRepositoryProvider));
});

final adminProfileViewModelProvider = StateNotifierProvider<AdminProfileViewModel, AdminProfileState>((ref) {
  return AdminProfileViewModel(
    ref.watch(authRepositoryProvider),
    ref.read(sharedPrefServiceProvider),
  );
});
