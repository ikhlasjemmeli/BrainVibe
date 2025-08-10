import '../entities/user.dart';
import '../repositories/user_repository.dart';

class RegisterUser {
  final UserRepository repository;
  RegisterUser(this.repository);

  Future<void> call(User user) async {
    await repository.register(user);
  }
}