class AuthUserModel {
  const AuthUserModel({
    required this.userId,
    required this.email,
    required this.isEmailVerified,
  });

  final String userId;
  final String email;
  final bool isEmailVerified;
}
