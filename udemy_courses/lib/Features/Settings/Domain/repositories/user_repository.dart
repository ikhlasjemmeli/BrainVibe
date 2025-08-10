import 'package:Brainvibe/Features/Settings/Domain/entities/Auth.dart';

import '../../Data/models/Update_profile.dart';
import '../../Data/models/change_password_model.dart';
import '../entities/login.dart';
import '../entities/user.dart';

abstract class UserRepository {
  Future<void> register(User user);
  Future<AuthEntity> login(Login user);
  Future<String> disableAccount();
  Future<String> updateProfile(UpdateProfileModel profile);
  Future<String> changePassword(ChangePasswordModel model);
}