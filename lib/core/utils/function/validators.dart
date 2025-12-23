class Validators {


  static String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final emailRegex =
        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }


  // static String? passwordValidator(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'Password is required';
  //   }

  //   if (value.length < 8) {
  //     return 'Password must be at least 8 characters';
  //   }

  //   if (!RegExp(r'[A-Z]').hasMatch(value)) {
  //     return 'Password must contain at least one uppercase letter';
  //   }

  //   if (!RegExp(r'[a-z]').hasMatch(value)) {
  //     return 'Password must contain at least one lowercase letter';
  //   }

  //   if (!RegExp(r'[0-9]').hasMatch(value)) {
  //     return 'Password must contain at least one number';
  //   }

  //   if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) {
  //     return 'Password must contain at least one special character';
  //   }

  //   return null;
  // }
    static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null; 
  }

}




