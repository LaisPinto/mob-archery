import 'package:mobx/mobx.dart';
import 'package:mob_archery/auth/enums/auth_status.dart';
import 'package:mob_archery/auth/models/auth_user_model.dart';
import 'package:mob_archery/auth/models/user_model.dart';

class AuthState {
  final Observable<AuthUserModel?> authUser = Observable<AuthUserModel?>(null);
  final Observable<UserModel?> userProfile = Observable<UserModel?>(null);
  final Observable<AuthStatus> authStatus =
      Observable<AuthStatus>(AuthStatus.unauthenticated);
  final Observable<bool> isLoading = Observable<bool>(false);
  final Observable<String?> errorMessage = Observable<String?>(null);
  final Observable<String?> infoMessage = Observable<String?>(null);
}
