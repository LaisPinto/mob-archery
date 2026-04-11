import 'package:mobx/mobx.dart';
import 'package:mob_archery/app/modules/profile/models/profile_model.dart';

class ProfileState {
  final Observable<ProfileModel?> profile = Observable<ProfileModel?>(null);
  final Observable<bool> isLoading = Observable<bool>(false);
  final Observable<String?> errorMessage = Observable<String?>(null);
  final Observable<String?> successMessage = Observable<String?>(null);
  final Observable<String?> localProfileImagePath = Observable<String?>(null);
}
