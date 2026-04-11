// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_state.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AuthState on AuthStateBase, Store {
  late final _$authUserAtom = Atom(
    name: 'AuthStateBase.authUser',
    context: context,
  );

  @override
  AuthUserModel? get authUser {
    _$authUserAtom.reportRead();
    return super.authUser;
  }

  @override
  set authUser(AuthUserModel? value) {
    _$authUserAtom.reportWrite(value, super.authUser, () {
      super.authUser = value;
    });
  }

  late final _$userProfileAtom = Atom(
    name: 'AuthStateBase.userProfile',
    context: context,
  );

  @override
  UserModel? get userProfile {
    _$userProfileAtom.reportRead();
    return super.userProfile;
  }

  @override
  set userProfile(UserModel? value) {
    _$userProfileAtom.reportWrite(value, super.userProfile, () {
      super.userProfile = value;
    });
  }

  late final _$authStatusAtom = Atom(
    name: 'AuthStateBase.authStatus',
    context: context,
  );

  @override
  AuthStatus get authStatus {
    _$authStatusAtom.reportRead();
    return super.authStatus;
  }

  @override
  set authStatus(AuthStatus value) {
    _$authStatusAtom.reportWrite(value, super.authStatus, () {
      super.authStatus = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: 'AuthStateBase.isLoading',
    context: context,
  );

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: 'AuthStateBase.errorMessage',
    context: context,
  );

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$infoMessageAtom = Atom(
    name: 'AuthStateBase.infoMessage',
    context: context,
  );

  @override
  String? get infoMessage {
    _$infoMessageAtom.reportRead();
    return super.infoMessage;
  }

  @override
  set infoMessage(String? value) {
    _$infoMessageAtom.reportWrite(value, super.infoMessage, () {
      super.infoMessage = value;
    });
  }

  @override
  String toString() {
    return '''
authUser: ${authUser},
userProfile: ${userProfile},
authStatus: ${authStatus},
isLoading: ${isLoading},
errorMessage: ${errorMessage},
infoMessage: ${infoMessage}
    ''';
  }
}
