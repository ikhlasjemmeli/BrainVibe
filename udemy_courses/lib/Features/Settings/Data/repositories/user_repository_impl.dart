import '../../Domain/entities/Auth.dart';
import '../../Domain/entities/login.dart';
import '../../Domain/entities/user.dart';
import '../../Domain/repositories/user_repository.dart';
import '../datasources/user_remote_datasource.dart';
import '../models/Update_profile.dart';
import '../models/change_password_model.dart';
import '../models/login_model.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDatasource remoteDatasource;
  UserRepositoryImpl(this.remoteDatasource);

  @override
  Future<void> register(User user) async {
    final userModel = UserModel.fromEntity(user);
    await remoteDatasource.register(userModel);
  }
  @override
  Future<AuthEntity> login(Login user) async {
    final loginModel = LoginModel.fromEntity(user);

    return await remoteDatasource.login(loginModel);


  }

  @override
  Future<String> disableAccount() async {
    return await remoteDatasource.disableAccount();
  }
  @override
  Future<String> updateProfile(UpdateProfileModel profile) async {
    return await remoteDatasource.updateProfile(profile);
  }

  @override
  Future<String> changePassword(ChangePasswordModel model) async {
    return await remoteDatasource.changePassword(model);
  }
}