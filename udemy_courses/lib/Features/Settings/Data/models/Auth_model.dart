import 'dart:convert';

import '../../Domain/entities/Auth.dart';
import '../../Domain/entities/user.dart';

class AuthModel extends AuthEntity {
  AuthModel({
    user,
    token,
    role
  }) : super(user: user, token: token, role:role);

  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
    user: User.fromJson(json["user"]),
    token: json["token"],
    role: json["role"],
  );

  static String ModelToJson(AuthEntity ue) => json.encode(toJson(ue));

  static Map<String, dynamic> toJson(AuthEntity e) => {
    "user": e.user.toJson(),
    "token": e.token,
    "role": e.role,
  };

  AuthModel copyWith({String? firstName, String? lastName, String? profilePicture}) {
    return AuthModel(
      user: user.copyWith(
        firstName: firstName ?? user.firstName,
        lastName: lastName ?? user.lastName,

      ),
      token: token,
      role: role,
    );
  }
}