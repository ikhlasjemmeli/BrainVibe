import '../../Data/models/change_password_model.dart';
import '../repositories/user_repository.dart';

class ChangePassword {
  final UserRepository repository;
  ChangePassword(this.repository);

  Future<String> call(ChangePasswordModel model) async {
    return await repository.changePassword(model);
  }
}