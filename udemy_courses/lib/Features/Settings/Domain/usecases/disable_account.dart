
import '../repositories/user_repository.dart';

class DisableAccount {
  final UserRepository repository;
  DisableAccount(this.repository);

  Future<String> call() async {
    return await repository.disableAccount();
  }


}
