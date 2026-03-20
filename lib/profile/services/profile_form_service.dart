class ProfileFormService {
  String? validateName(String value) {
    if (value.trim().isEmpty) {
      return 'Name is required.';
    }
    if (value.trim().length < 2) {
      return 'Name must contain at least 2 characters.';
    }
    return null;
  }
}
