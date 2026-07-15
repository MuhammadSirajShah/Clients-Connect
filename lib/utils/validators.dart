
class Validators {
  static String? validateName(String value){
    if(value.trim().isEmpty){
      return "Name is required";
    }

    if(value.length < 3){
      return "Minimum 3 characters required";
    }
    return null;
  }

  static String? validateEmail(String value){
    if(value.trim().isEmpty){
      return "Email is required";
    }
    final emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    );
    if(!emailRegex.hasMatch(value)){
      return "Enter valid email";
    }
    return null;
  }

  static String? validatePassword(String value){
    if(value.isEmpty){
      return "Password is required";
    }
    final regex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&]).{8,}$',
    );
    if(!regex.hasMatch(value)){
      return
        "Password must contain:\n"
            "• Uppercase\n"
            "• Lowercase\n"
            "• Number\n"
            "• Special Character\n"
            "• Minimum 8 chars";
    }
    return null;
  }
}