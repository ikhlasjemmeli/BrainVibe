import 'package:Brainvibe/Features/Settings/Domain/entities/Auth.dart';
import 'package:get/get.dart';
import '../../Data/models/Update_profile.dart';
import '../../Data/models/change_password_model.dart';
import '../../Domain/entities/login.dart';
import '../../Domain/entities/user.dart';
import '../../Domain/usecases/ChangePassword.dart';
import '../../Domain/usecases/disable_account.dart';
import '../../Domain/usecases/login_user.dart';
import '../../Domain/usecases/register_user.dart';
import '../../Domain/usecases/update_profile.dart';


class SettingsController extends GetxController {
  final RegisterUser registerUser;
  final LoginUser loginUser;
  final DisableAccount disableAccount;
  final UpdateProfile _updateProfile;
  final ChangePassword changePasswordUsecase;
  SettingsController(this.registerUser, this.loginUser, this.disableAccount, this._updateProfile,this.changePasswordUsecase);

  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    final user = User(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
    );
    await registerUser(user);
  }




  Future<AuthEntity> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    final user = Login(
      email: email,
      password: password,
      rememberMe: rememberMe,
    );
    return await loginUser(user);
  }



  Future<String> deactivateAccount() async {
    return await disableAccount();
  }

  Future<String> updateProfile({

    required String firstName,
    required String lastName,
    String? profilePicture,
  }) async {
    final profile = UpdateProfileModel(
      firstName: firstName,
      lastName: lastName,
      profilePicture: profilePicture,
    );
    return await _updateProfile(profile);
  }

  Future<String> changePassword({

    required String oldPassword,
    required String newPassword,
  }) async {
    final model = ChangePasswordModel(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
    return await changePasswordUsecase(model);
  }
}