import 'package:mobx/mobx.dart';

import '../enums/auth_status.dart';
import '../models/auth_user_model.dart';
import '../models/user_model.dart';

part 'auth_state.g.dart';

class AuthState = AuthStateBase with _$AuthState;

abstract class AuthStateBase with Store {
  @observable
  AuthUserModel? authUser;

  @observable
  UserModel? userProfile;

  @observable
  AuthStatus authStatus = AuthStatus.unauthenticated;

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @observable
  String? infoMessage;
}
