
import 'package:get/get.dart';
import '../../../../Core/SharedPreferences/sharedpreferences_controller.dart';
import '../../Data/datasources/user_remote_datasource.dart';
import '../../Data/repositories/user_repository_impl.dart';
import '../../Domain/repositories/user_repository.dart';
import '../../Domain/usecases/ChangePassword.dart';
import '../../Domain/usecases/disable_account.dart';
import '../../Domain/usecases/login_user.dart';
import '../../Domain/usecases/register_user.dart';

import '../../Domain/usecases/update_profile.dart';
import 'settings_controller.dart';


class SettingsBindings extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut<UserRemoteDatasource>(() => UserRemoteDatasourceImpl(Get.find()));
    Get.lazyPut<UserRepository>(() => UserRepositoryImpl(Get.find()));
    Get.lazyPut(() => RegisterUser(Get.find()));
    Get.lazyPut(() => LoginUser(Get.find()));
    Get.lazyPut(() => DisableAccount(Get.find()));
    Get.lazyPut(() => UpdateProfile(Get.find()));
    Get.lazyPut(() => ChangePassword(Get.find()));
    Get.lazyPut(() => SharedPreferencesController(Get.find()));
    Get.lazyPut(() => SettingsController(Get.find(),Get.find(),Get.find(),Get.find(),Get.find()));
  }
}