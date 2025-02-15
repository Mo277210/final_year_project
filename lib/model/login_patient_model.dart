class LoginResponseModel {
  final String token;
  final String error;

  LoginResponseModel({
    required this.token,
    required this.error,
  });

  // Factory constructor to create an instance from JSON
  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      token: json["token"] ?? "", // Default empty string if null
      error: json["error"] ?? "", // Default empty string if null
    );
  }

  // Convert the object to a JSON format
  Map<String, dynamic> toJson() {
    return {
      "token": token,
      "error": error,
    };
  }
}


class LoginRequestModel {
  final String email;
  final String password;

  LoginRequestModel({
    required this.email,
    required this.password,
  });

  // Convert the object to a JSON format
  Map<String, dynamic> toJson() {
    return {
      'email': email.trim(), // Trim to remove unnecessary spaces
      'password': password.trim(),
    };
  }
}
