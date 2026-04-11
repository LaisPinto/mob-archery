import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import '../enums/auth_status.dart';
import '../models/auth_user_model.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart' show AuthService;
import 'auth_state.dart';
import 'package:mob_archery/app/modules/services/auth_service.dart'
    hide AuthService;
import 'package:mob_archery/app/modules/services/firestore_service.dart';

part 'auth_action.g.dart';

class AuthAction = AuthActionBase with _$AuthAction;

abstract class AuthActionBase with Store {
  final AuthServiceInterface authService;
  final FirestoreServiceInterface firestoreService;
  final AuthService authFormService;

  AuthActionBase(
    this.authService,
    this.firestoreService,
    this.authFormService,
  ) {
    _startAuthListener();
  }

  final _state = Modular.get<AuthState>();

  StreamSubscription<AuthUserModel?>? authSubscription;

  @action
  void _startAuthListener() {
    final current = authService.currentUser;
    if (current != null) {
      _state.authUser = current;
    }

    try {
      authSubscription = authService.authStateChanges().listen(_onAuthChanged);
    } on FirebaseException catch (exception) {
      _state.errorMessage = exception.message ?? 'Firebase is not configured.';
    } catch (exception) {
      _state.errorMessage = exception.toString();
    }
  }

  @action
  Future<void> _onAuthChanged(AuthUserModel? authUser) async {
    _state.authUser = authUser;

    if (authUser == null) {
      _state.userProfile = null;
      _state.authStatus = AuthStatus.unauthenticated;
      return;
    }

    final existingProfile = await firestoreService.getUserProfile(
      authUser.userId,
    );
    final userProfile =
        existingProfile ??
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

    _state.userProfile = userProfile;
    _state.authStatus = authUser.isEmailVerified
        ? AuthStatus.authenticated
        : AuthStatus.emailVerificationPending;
  }

  @action
  void clearMessages() {
    _state.errorMessage = null;
    _state.infoMessage = null;
  }

  @action
  Future<void> signIn({required String email, required String password}) async {
    clearMessages();

    final emailValidationMessage = authFormService.validateEmail(email);
    final passwordValidationMessage = authFormService.validateLoginPassword(
      password,
    );
    if (emailValidationMessage != null || passwordValidationMessage != null) {
      _state.errorMessage = emailValidationMessage ?? passwordValidationMessage;
      return;
    }

    _state.isLoading = true;
    try {
      await authService.signInWithEmail(
        email: email.trim(),
        password: password,
      );
      _state.infoMessage = 'Login successful.';
    } on FirebaseAuthException catch (exception) {
      _state.errorMessage = exception.message ?? 'Login failed.';
    } on FirebaseException catch (exception) {
      _state.errorMessage = exception.message ?? 'Firebase is not configured.';
    } catch (exception) {
      _state.errorMessage = exception.toString();
    } finally {
      _state.isLoading = false;
    }
  }

  @action
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String preferredLanguage,
  }) async {
    clearMessages();

    final nameValidationMessage = authFormService.validateName(name);
    final emailValidationMessage = authFormService.validateEmail(email);
    final passwordValidationMessage = authFormService.validatePassword(
      password,
    );
    if (nameValidationMessage != null ||
        emailValidationMessage != null ||
        passwordValidationMessage != null) {
      _state.errorMessage =
          nameValidationMessage ??
          emailValidationMessage ??
          passwordValidationMessage;
      return;
    }

    _state.isLoading = true;
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
      _state.infoMessage = 'Account created. Verify your email to continue.';
    } on FirebaseAuthException catch (exception) {
      _state.errorMessage =
          exception.message ?? 'Unable to create the account.';
    } on FirebaseException catch (exception) {
      _state.errorMessage = exception.message ?? 'Firebase is not configured.';
    } catch (exception) {
      _state.errorMessage = exception.toString();
    } finally {
      _state.isLoading = false;
    }
  }

  @action
  Future<void> sendPasswordReset(String email) async {
    clearMessages();

    final emailValidationMessage = authFormService.validateEmail(email);
    if (emailValidationMessage != null) {
      _state.errorMessage = emailValidationMessage;
      return;
    }

    _state.isLoading = true;
    try {
      await authService.sendPasswordResetEmail(email.trim());
      _state.infoMessage = 'Password reset email sent.';
    } on FirebaseAuthException catch (exception) {
      _state.errorMessage =
          exception.message ?? 'Unable to send the reset email.';
    } on FirebaseException catch (exception) {
      _state.errorMessage = exception.message ?? 'Firebase is not configured.';
    } catch (exception) {
      _state.errorMessage = exception.toString();
    } finally {
      _state.isLoading = false;
    }
  }

  @action
  Future<void> resendEmailVerification() async {
    clearMessages();
    _state.isLoading = true;
    try {
      await authService.sendEmailVerification();
      _state.infoMessage = 'Verification email sent again.';
    } on FirebaseAuthException catch (exception) {
      _state.errorMessage =
          exception.message ?? 'Unable to send the verification email.';
    } on FirebaseException catch (exception) {
      _state.errorMessage = exception.message ?? 'Firebase is not configured.';
    } catch (exception) {
      _state.errorMessage = exception.toString();
    } finally {
      _state.isLoading = false;
    }
  }

  @action
  Future<void> reloadCurrentUser() async {
    clearMessages();
    _state.isLoading = true;
    try {
      final authUser = await authService.reloadCurrentUser();
      await _onAuthChanged(authUser);
    } on FirebaseAuthException catch (exception) {
      _state.errorMessage =
          exception.message ?? 'Unable to refresh the current user.';
    } on FirebaseException catch (exception) {
      _state.errorMessage = exception.message ?? 'Firebase is not configured.';
    } catch (exception) {
      _state.errorMessage = exception.toString();
    } finally {
      _state.isLoading = false;
    }
  }

  @action
  Future<void> confirmPasswordReset({
    required String actionCode,
    required String newPassword,
  }) async {
    clearMessages();

    final passwordValidationMessage = authFormService.validatePassword(
      newPassword,
    );
    if (passwordValidationMessage != null) {
      _state.errorMessage = passwordValidationMessage;
      return;
    }

    _state.isLoading = true;
    try {
      await authService.confirmPasswordReset(
        actionCode: actionCode,
        newPassword: newPassword,
      );
      _state.infoMessage = 'Password updated successfully.';
    } on FirebaseAuthException catch (exception) {
      _state.errorMessage =
          exception.message ?? 'Unable to update the password.';
    } on FirebaseException catch (exception) {
      _state.errorMessage = exception.message ?? 'Firebase is not configured.';
    } catch (exception) {
      _state.errorMessage = exception.toString();
    } finally {
      _state.isLoading = false;
    }
  }

  @action
  Future<void> signOut() async {
    clearMessages();
    await authService.signOut();
  }

  void dispose() {
    authSubscription?.cancel();
  }
}
