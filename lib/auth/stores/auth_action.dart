import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';
import 'package:mob_archery/auth/enums/auth_status.dart';
import 'package:mob_archery/auth/models/auth_user_model.dart';
import 'package:mob_archery/auth/models/user_model.dart';
import 'package:mob_archery/auth/services/auth_form_service.dart';
import 'package:mob_archery/auth/stores/auth_state.dart';
import 'package:mob_archery/services/auth_service.dart';
import 'package:mob_archery/services/firestore_service.dart';

class AuthAction {
  AuthAction(
    this.state,
    this.authService,
    this.firestoreService,
    this.authFormService,
  ) {
    _startAuthListener();
  }

  final AuthState state;
  final AuthServiceInterface authService;
  final FirestoreServiceInterface firestoreService;
  final AuthFormService authFormService;

  StreamSubscription<AuthUserModel?>? authSubscription;

  void _startAuthListener() {
    try {
      authSubscription = authService.authStateChanges().listen(_onAuthChanged);
    } on FirebaseException catch (exception) {
      runInAction(() {
        state.errorMessage.value =
            exception.message ?? 'Firebase is not configured.';
      });
    } catch (exception) {
      runInAction(() {
        state.errorMessage.value = exception.toString();
      });
    }
  }

  Future<void> _onAuthChanged(AuthUserModel? authUser) async {
    runInAction(() {
      state.authUser.value = authUser;
    });

    if (authUser == null) {
      runInAction(() {
        state.userProfile.value = null;
        state.authStatus.value = AuthStatus.unauthenticated;
      });
      return;
    }

    final existingProfile = await firestoreService.getUserProfile(authUser.userId);
    final userProfile = existingProfile ??
        UserModel(
          userId: authUser.userId,
          name: authUser.email.split('@').first,
          email: authUser.email,
          createdAt: DateTime.now(),
          preferredLanguage: 'en_US',
          unit: 'meters',
        );

    if (existingProfile == null) {
      await firestoreService.upsertUserProfile(userProfile);
    }

    runInAction(() {
      state.userProfile.value = userProfile;
      state.authStatus.value = authUser.isEmailVerified
          ? AuthStatus.authenticated
          : AuthStatus.emailVerificationPending;
    });
  }

  void clearMessages() {
    runInAction(() {
      state.errorMessage.value = null;
      state.infoMessage.value = null;
    });
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    clearMessages();

    final emailValidationMessage = authFormService.validateEmail(email);
    final passwordValidationMessage =
        authFormService.validateLoginPassword(password);
    if (emailValidationMessage != null || passwordValidationMessage != null) {
      runInAction(() {
        state.errorMessage.value =
            emailValidationMessage ?? passwordValidationMessage;
      });
      return;
    }

    runInAction(() => state.isLoading.value = true);
    try {
      await authService.signInWithEmail(
        email: email.trim(),
        password: password,
      );
      runInAction(() => state.infoMessage.value = 'Login successful.');
    } on FirebaseAuthException catch (exception) {
      runInAction(() {
        state.errorMessage.value = exception.message ?? 'Login failed.';
      });
    } on FirebaseException catch (exception) {
      runInAction(() {
        state.errorMessage.value =
            exception.message ?? 'Firebase is not configured.';
      });
    } catch (exception) {
      runInAction(() {
        state.errorMessage.value = exception.toString();
      });
    } finally {
      runInAction(() => state.isLoading.value = false);
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String preferredLanguage,
  }) async {
    clearMessages();

    final nameValidationMessage = authFormService.validateName(name);
    final emailValidationMessage = authFormService.validateEmail(email);
    final passwordValidationMessage = authFormService.validatePassword(password);
    if (nameValidationMessage != null ||
        emailValidationMessage != null ||
        passwordValidationMessage != null) {
      runInAction(() {
        state.errorMessage.value = nameValidationMessage ??
            emailValidationMessage ??
            passwordValidationMessage;
      });
      return;
    }

    runInAction(() => state.isLoading.value = true);
    try {
      final authUser = await authService.registerWithEmail(
        email: email.trim(),
        password: password,
      );

      await firestoreService.upsertUserProfile(
        UserModel(
          userId: authUser.userId,
          name: name.trim(),
          email: authUser.email,
          createdAt: DateTime.now(),
          preferredLanguage: preferredLanguage,
          unit: 'meters',
        ),
      );

      await authService.sendEmailVerification();
      runInAction(() {
        state.infoMessage.value = 'Account created. Verify your email to continue.';
      });
    } on FirebaseAuthException catch (exception) {
      runInAction(() {
        state.errorMessage.value =
            exception.message ?? 'Unable to create the account.';
      });
    } on FirebaseException catch (exception) {
      runInAction(() {
        state.errorMessage.value =
            exception.message ?? 'Firebase is not configured.';
      });
    } catch (exception) {
      runInAction(() {
        state.errorMessage.value = exception.toString();
      });
    } finally {
      runInAction(() => state.isLoading.value = false);
    }
  }

  Future<void> sendPasswordReset(String email) async {
    clearMessages();

    final emailValidationMessage = authFormService.validateEmail(email);
    if (emailValidationMessage != null) {
      runInAction(() => state.errorMessage.value = emailValidationMessage);
      return;
    }

    runInAction(() => state.isLoading.value = true);
    try {
      await authService.sendPasswordResetEmail(email.trim());
      runInAction(() => state.infoMessage.value = 'Password reset email sent.');
    } on FirebaseAuthException catch (exception) {
      runInAction(() {
        state.errorMessage.value =
            exception.message ?? 'Unable to send the reset email.';
      });
    } on FirebaseException catch (exception) {
      runInAction(() {
        state.errorMessage.value =
            exception.message ?? 'Firebase is not configured.';
      });
    } catch (exception) {
      runInAction(() {
        state.errorMessage.value = exception.toString();
      });
    } finally {
      runInAction(() => state.isLoading.value = false);
    }
  }

  Future<void> resendEmailVerification() async {
    clearMessages();
    runInAction(() => state.isLoading.value = true);
    try {
      await authService.sendEmailVerification();
      runInAction(() {
        state.infoMessage.value = 'Verification email sent again.';
      });
    } on FirebaseAuthException catch (exception) {
      runInAction(() {
        state.errorMessage.value =
            exception.message ?? 'Unable to send the verification email.';
      });
    } on FirebaseException catch (exception) {
      runInAction(() {
        state.errorMessage.value =
            exception.message ?? 'Firebase is not configured.';
      });
    } catch (exception) {
      runInAction(() {
        state.errorMessage.value = exception.toString();
      });
    } finally {
      runInAction(() => state.isLoading.value = false);
    }
  }

  Future<void> reloadCurrentUser() async {
    clearMessages();
    runInAction(() => state.isLoading.value = true);
    try {
      final authUser = await authService.reloadCurrentUser();
      await _onAuthChanged(authUser);
    } on FirebaseAuthException catch (exception) {
      runInAction(() {
        state.errorMessage.value =
            exception.message ?? 'Unable to refresh the current user.';
      });
    } on FirebaseException catch (exception) {
      runInAction(() {
        state.errorMessage.value =
            exception.message ?? 'Firebase is not configured.';
      });
    } catch (exception) {
      runInAction(() {
        state.errorMessage.value = exception.toString();
      });
    } finally {
      runInAction(() => state.isLoading.value = false);
    }
  }

  Future<void> confirmPasswordReset({
    required String actionCode,
    required String newPassword,
  }) async {
    clearMessages();

    final passwordValidationMessage =
        authFormService.validatePassword(newPassword);
    if (passwordValidationMessage != null) {
      runInAction(() => state.errorMessage.value = passwordValidationMessage);
      return;
    }

    runInAction(() => state.isLoading.value = true);
    try {
      await authService.confirmPasswordReset(
        actionCode: actionCode,
        newPassword: newPassword,
      );
      runInAction(() {
        state.infoMessage.value = 'Password updated successfully.';
      });
    } on FirebaseAuthException catch (exception) {
      runInAction(() {
        state.errorMessage.value =
            exception.message ?? 'Unable to update the password.';
      });
    } on FirebaseException catch (exception) {
      runInAction(() {
        state.errorMessage.value =
            exception.message ?? 'Firebase is not configured.';
      });
    } catch (exception) {
      runInAction(() {
        state.errorMessage.value = exception.toString();
      });
    } finally {
      runInAction(() => state.isLoading.value = false);
    }
  }

  Future<void> signOut() async {
    clearMessages();
    await authService.signOut();
  }

  void dispose() {
    authSubscription?.cancel();
  }
}
