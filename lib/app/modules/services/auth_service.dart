import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mob_archery/app/modules/auth/models/auth_user_model.dart';

abstract interface class AuthServiceInterface {
  Stream<AuthUserModel?> authStateChanges();

  AuthUserModel? get currentUser;

  Future<AuthUserModel> signInWithEmail({
    required String email,
    required String password,
  });

  Future<AuthUserModel> registerWithEmail({
    required String email,
    required String password,
  });

  Future<void> sendPasswordResetEmail(String email);

  Future<void> sendEmailVerification();

  Future<void> confirmPasswordReset({
    required String actionCode,
    required String newPassword,
  });

  Future<AuthUserModel?> reloadCurrentUser();

  Future<void> signOut();

  Future<void> updateEmail(String newEmail);

  Future<void> updatePassword(String newPassword);
}

class AuthService implements AuthServiceInterface {
  bool get isFirebaseConfigured => Firebase.apps.isNotEmpty;

  FirebaseAuth get firebaseAuth {
    if (!isFirebaseConfigured) {
      throw FirebaseException(
        plugin: 'firebase_core',
        code: 'no-app',
        message:
            'Firebase is not configured. Add the platform Firebase files and initialize the default app.',
      );
    }
    return FirebaseAuth.instance;
  }

  AuthUserModel? _mapUser(User? user) {
    if (user == null) {
      return null;
    }

    return AuthUserModel(
      userId: user.uid,
      email: user.email ?? '',
      isEmailVerified: user.emailVerified,
    );
  }

  @override
  Stream<AuthUserModel?> authStateChanges() {
    if (!isFirebaseConfigured) {
      return Stream<AuthUserModel?>.value(null);
    }
    return firebaseAuth.authStateChanges().map(_mapUser);
  }

  @override
  AuthUserModel? get currentUser =>
      isFirebaseConfigured ? _mapUser(firebaseAuth.currentUser) : null;

  @override
  Future<AuthUserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final userCredential = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final authUser = _mapUser(userCredential.user);
    if (authUser == null) {
      throw FirebaseAuthException(
        code: 'sign-in-failed',
        message: 'Unable to read the authenticated user.',
      );
    }
    return authUser;
  }

  @override
  Future<AuthUserModel> registerWithEmail({
    required String email,
    required String password,
  }) async {
    final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final authUser = _mapUser(userCredential.user);
    if (authUser == null) {
      throw FirebaseAuthException(
        code: 'registration-failed',
        message: 'Unable to create the authenticated user.',
      );
    }
    return authUser;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) {
    return firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  @override
  Future<void> confirmPasswordReset({
    required String actionCode,
    required String newPassword,
  }) {
    return firebaseAuth.confirmPasswordReset(
      code: actionCode,
      newPassword: newPassword,
    );
  }

  @override
  Future<AuthUserModel?> reloadCurrentUser() async {
    await firebaseAuth.currentUser?.reload();
    return _mapUser(firebaseAuth.currentUser);
  }

  @override
  Future<void> signOut() => firebaseAuth.signOut();

  @override
  Future<void> updateEmail(String newEmail) async {
    final user = firebaseAuth.currentUser;
    if (user == null) throw FirebaseAuthException(code: 'no-current-user');
    await user.verifyBeforeUpdateEmail(newEmail);
  }

  @override
  Future<void> updatePassword(String newPassword) async {
    final user = firebaseAuth.currentUser;
    if (user == null) throw FirebaseAuthException(code: 'no-current-user');
    await user.updatePassword(newPassword);
  }
}
