class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email required';
    if (!value.contains('@')) return 'Enter a valid email';
    return null;
  }

  static String? validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.isEmpty) return '$fieldName required';
    return null;
  }

  static String? validateNumber(String? value, String fieldName) {
    if (value == null || value.isEmpty) return '$fieldName required';
    if (double.tryParse(value) == null) return 'Enter a valid number';
    return null;
  }
}