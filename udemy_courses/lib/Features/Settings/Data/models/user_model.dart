import '../../Domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.email,
    required super.password,
    required super.firstName,
    required super.lastName,
  });

  Map<String, dynamic> toRegisterDto() => {
    'email': email,
    'password': password,
    'firstName': firstName,
    'lastName': lastName,
  };

  factory UserModel.fromEntity(User user) => UserModel(
    email: user.email,
    password: user.password,
    firstName: user.firstName,
    lastName: user.lastName,
  );
}