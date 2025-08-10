import '../../Domain/entities/login.dart';

class LoginModel extends Login {
  LoginModel({
    required super.email,
    required super.password,
    required super.rememberMe

  });

  Map<String, dynamic> toRegisterDto() => {
    'email': email,
    'password': password,
    'rememberMe' :rememberMe

  };

  factory LoginModel.fromEntity(Login user) => LoginModel(
    email: user.email,
    password: user.password,
      rememberMe :user.rememberMe

  );
}