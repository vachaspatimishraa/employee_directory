import '../model/admin_profile_model.dart';

class AdminProfileState {
  final AdminProfileModel? profile;
  final bool isLoading;
  final bool isEditing;
  final String? errorMessage;
  final bool isSuccess;

  AdminProfileState({
    this.profile,
    this.isLoading = false,
    this.isEditing = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  AdminProfileState copyWith({
    AdminProfileModel? profile,
    bool? isLoading,
    bool? isEditing,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return AdminProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      isEditing: isEditing ?? this.isEditing,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
