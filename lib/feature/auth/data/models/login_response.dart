class LoginResponse {
  final bool status;
  final String message;
  final String token;
  final int id;
  final LoginUser data;

  LoginResponse({
    required this.status,
    required this.message,
    required this.token,
    required this.id,
    required this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'],
      message: json['message'],
      token: json['token'],
      id: json['id'],
      data: LoginUser.fromJson(json['data']),
    );
  }
}

class LoginUser {
  final int id;
  final String name;
  final String email;
  final String mobile;

  LoginUser({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
  });

  factory LoginUser.fromJson(Map<String, dynamic> json) {
    return LoginUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      mobile: json['mobile'],
    );
  }
}

