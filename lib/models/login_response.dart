
class LoginResponse {

  String? token;
  String? message; 
  int statusCode;

  LoginResponse({
    this.token,
    this.message,
    this.statusCode = 0
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] as String?,
      message: json['message'] as String?,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'message': message,
    };
  }

}