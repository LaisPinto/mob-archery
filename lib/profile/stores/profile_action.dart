import 'package:mobx/mobx.dart';
import 'package:mob_archery/auth/models/user_model.dart';
import 'package:mob_archery/auth/stores/auth_state.dart';
import 'package:mob_archery/profile/enums/measurement_unit.dart';
import 'package:mob_archery/profile/enums/supported_language.dart';
import 'package:mob_archery/profile/models/profile_model.dart';
import 'package:mob_archery/profile/services/profile_form_service.dart';
import 'package:mob_archery/profile/stores/profile_state.dart';
import 'package:mob_archery/services/auth_service.dart';
import 'package:mob_archery/services/firestore_service.dart';

class ProfileAction {
  ProfileAction(
    this.state,
    this.authState,
    this.authService,
    this.firestoreService,
    this.profileFormService,
  );

  final ProfileState state;
  final AuthState authState;
  final AuthServiceInterface authService;
  final FirestoreServiceInterface firestoreService;
  final ProfileFormService profileFormService;

  void clearMessages() {
    runInAction(() {
      state.errorMessage.value = null;
      state.successMessage.value = null;
    });
  }

  Future<void> loadProfile() async {
    clearMessages();
    final userProfile = authState.userProfile.value;
    if (userProfile == null) {
      runInAction(() => state.profile.value = null);
      return;
    }

    runInAction(() {
      state.profile.value = ProfileModel.fromUserModel(userProfile);
    });
  }

  Future<void> saveProfile({
    required String name,
    required SupportedLanguage supportedLanguage,
    required MeasurementUnit measurementUnit,
  }) async {
    clearMessages();
    final validationMessage = profileFormService.validateName(name);
    if (validationMessage != null) {
      runInAction(() => state.errorMessage.value = validationMessage);
      return;
    }

    final authUser = authService.currentUser;
    final currentProfile = authState.userProfile.value;
    if (authUser == null || currentProfile == null) {
      runInAction(() {
        state.errorMessage.value = 'No authenticated user found.';
      });
      return;
    }

    runInAction(() => state.isLoading.value = true);
    try {
      final updatedUser = UserModel(
        userId: authUser.userId,
        name: name.trim(),
        email: currentProfile.email,
        createdAt: currentProfile.createdAt,
        preferredLanguage: supportedLanguage.localeCode,
        unit: measurementUnit.firestoreValue,
      );

      await firestoreService.upsertUserProfile(updatedUser);
      runInAction(() {
        authState.userProfile.value = updatedUser;
        state.profile.value = ProfileModel.fromUserModel(updatedUser);
        state.successMessage.value = 'Profile updated successfully.';
      });
    } catch (exception) {
      runInAction(() {
        state.errorMessage.value = exception.toString();
      });
    } finally {
      runInAction(() => state.isLoading.value = false);
    }
  }
}
