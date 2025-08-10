import 'package:Brainvibe/Features/Settings/Domain/entities/Auth.dart';

import '../entities/login.dart';
import '../repositories/user_repository.dart';

class LoginUser {
  final UserRepository repository;
  LoginUser(this.repository);

  Future<AuthEntity> call(Login user) async {
    return await repository.login(user);
  }


}