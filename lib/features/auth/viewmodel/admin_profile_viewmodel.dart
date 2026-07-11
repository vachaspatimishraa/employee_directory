import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/admin_profile_model.dart';
import '../repository/auth_repository.dart';
import '../../../core/services/shared_pref_service.dart';
import 'admin_profile_state.dart';

class AdminProfileViewModel extends StateNotifier<AdminProfileState> {
  final AuthRepository _authRepository;

  AdminProfileViewModel(this._authRepository, SharedPrefService sharedPrefService) 
      : super(AdminProfileState()) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    final email = _authRepository.getEmail();
    if (email == null) {
      state = state.copyWith(errorMessage: 'No active session.');
      return;
    }

    try {
      final user = await _authRepository.getUserByEmail(email);
      if (user != null) {
        final profile = AdminProfileModel(
          email: user.email,
          name: user.name,
          phone: user.phone,
          company: user.company,
          designation: user.designation,
          website: user.website,
          street: user.street,
          suite: user.suite,
          city: user.city,
          zipcode: user.zipcode,
        );
        state = state.copyWith(profile: profile);
      } else {
        // Fallback for case where user exists in session but not in DB (shouldn't happen with new logic)
        state = state.copyWith(profile: AdminProfileModel(email: email));
      }
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to load profile: $e');
    }
  }

  void setEditMode(bool editing) {
    state = state.copyWith(isEditing: editing, isSuccess: false);
  }

  Future<bool> saveProfile(AdminProfileModel updatedProfile) async {
    if (updatedProfile.name == null || updatedProfile.name!.trim().isEmpty) {
      state = state.copyWith(errorMessage: 'Name is required.');
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null, isSuccess: false);
    try {
      final user = await _authRepository.getUserByEmail(updatedProfile.email);
      if (user != null) {
        user.name = updatedProfile.name;
        user.phone = updatedProfile.phone;
        user.company = updatedProfile.company;
        user.designation = updatedProfile.designation;
        user.website = updatedProfile.website;
        user.street = updatedProfile.street;
        user.suite = updatedProfile.suite;
        user.city = updatedProfile.city;
        user.zipcode = updatedProfile.zipcode;
        
        await _authRepository.updateAdminUser(user);
        state = state.copyWith(profile: updatedProfile, isEditing: false, isLoading: false, isSuccess: true);
        return true;
      } else {
        state = state.copyWith(isLoading: false, errorMessage: 'User not found in database.');
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Failed to save profile: $e');
      return false;
    }
  }
}
