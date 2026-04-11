// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_action.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AuthAction on AuthActionBase, Store {
  late final _$_onAuthChangedAsyncAction = AsyncAction(
    'AuthActionBase._onAuthChanged',
    context: context,
  );

  @override
  Future<void> _onAuthChanged(AuthUserModel? authUser) {
    return _$_onAuthChangedAsyncAction.run(
      () => super._onAuthChanged(authUser),
    );
  }

  late final _$signInAsyncAction = AsyncAction(
    'AuthActionBase.signIn',
    context: context,
  );

  @override
  Future<void> signIn({required String email, required String password}) {
    return _$signInAsyncAction.run(
      () => super.signIn(email: email, password: password),
    );
  }

  late final _$registerAsyncAction = AsyncAction(
    'AuthActionBase.register',
    context: context,
  );

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String preferredLanguage,
  }) {
    return _$registerAsyncAction.run(
      () => super.register(
        name: name,
        email: email,
        password: password,
        preferredLanguage: preferredLanguage,
      ),
    );
  }

  late final _$sendPasswordResetAsyncAction = AsyncAction(
    'AuthActionBase.sendPasswordReset',
    context: context,
  );

  @override
  Future<void> sendPasswordReset(String email) {
    return _$sendPasswordResetAsyncAction.run(
      () => super.sendPasswordReset(email),
    );
  }

  late final _$resendEmailVerificationAsyncAction = AsyncAction(
    'AuthActionBase.resendEmailVerification',
    context: context,
  );

  @override
  Future<void> resendEmailVerification() {
    return _$resendEmailVerificationAsyncAction.run(
      () => super.resendEmailVerification(),
    );
  }

  late final _$reloadCurrentUserAsyncAction = AsyncAction(
    'AuthActionBase.reloadCurrentUser',
    context: context,
  );

  @override
  Future<void> reloadCurrentUser() {
    return _$reloadCurrentUserAsyncAction.run(() => super.reloadCurrentUser());
  }

  late final _$confirmPasswordResetAsyncAction = AsyncAction(
    'AuthActionBase.confirmPasswordReset',
    context: context,
  );

  @override
  Future<void> confirmPasswordReset({
    required String actionCode,
    required String newPassword,
  }) {
    return _$confirmPasswordResetAsyncAction.run(
      () => super.confirmPasswordReset(
        actionCode: actionCode,
        newPassword: newPassword,
      ),
    );
  }

  late final _$signOutAsyncAction = AsyncAction(
    'AuthActionBase.signOut',
    context: context,
  );

  @override
  Future<void> signOut() {
    return _$signOutAsyncAction.run(() => super.signOut());
  }

  late final _$AuthActionBaseActionController = ActionController(
    name: 'AuthActionBase',
    context: context,
  );

  @override
  void _startAuthListener() {
    final _$actionInfo = _$AuthActionBaseActionController.startAction(
      name: 'AuthActionBase._startAuthListener',
    );
    try {
      return super._startAuthListener();
    } finally {
      _$AuthActionBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearMessages() {
    final _$actionInfo = _$AuthActionBaseActionController.startAction(
      name: 'AuthActionBase.clearMessages',
    );
    try {
      return super.clearMessages();
    } finally {
      _$AuthActionBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
