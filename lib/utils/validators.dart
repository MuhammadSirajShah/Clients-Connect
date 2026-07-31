class Validators {

  static String? name(String? value) {
    if (value == null ||
        value.trim().isEmpty) {
      return "Please enter your name";
    }

    if (value.trim().length < 3) {
      return "Name must be at least 3 characters";
    }

    return null;
  }

  static String? email(String? value) {
    if (value == null ||
        value.trim().isEmpty) {
      return "Please enter your email";
    }

    final emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    );

    if (!emailRegex.hasMatch(
        value.trim())) {
      return "Please enter a valid email";
    }

    return null;
  }

  static String? password(String? value) {
    if (value == null ||
        value.isEmpty) {
      return "Please enter your password";
    }

    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }

    return null;
  }
}