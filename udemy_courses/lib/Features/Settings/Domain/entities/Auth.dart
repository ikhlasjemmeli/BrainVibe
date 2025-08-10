
import 'package:Brainvibe/Features/Settings/Domain/entities/user.dart';

class AuthEntity {
  AuthEntity({
    required this.user,
    required this.token,
    required this.role
  });

  final User user;
  final String token;
  final String role;
}
