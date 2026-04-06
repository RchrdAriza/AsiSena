class LoginRequest {
  final String login;
  final String password;

  const LoginRequest({required this.login, required this.password});

  Map<String, dynamic> toJson() => {'login': login, 'password': password};
}
