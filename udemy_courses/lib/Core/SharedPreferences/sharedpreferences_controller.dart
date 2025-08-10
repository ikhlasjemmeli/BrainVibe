import 'dart:convert';
import 'package:get/get.dart';
import '../../Features/Settings/Data/models/Auth_model.dart';
import '../../Features/Settings/Domain/entities/Auth.dart';
import '../constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesController extends GetxController {
  final SharedPreferences _preferences;

  SharedPreferencesController(this._preferences);


  void setUser(AuthEntity ue) {
    _preferences.setString(SP_USER, AuthModel.ModelToJson(ue));
  }

  void removeUser() {
    _preferences.remove(SP_USER);

  }

  AuthEntity? getUser() {
    if (_preferences.getString(SP_USER) != null) {
      return AuthModel.fromJson(jsonDecode(_preferences.getString(SP_USER)!));
    } else {
      return null;
    }
  }



  void setLangue(String langue) {
    _preferences.setString(SP_PREFS_LANGUAGE, langue);
  }

  String? getLangue() {
    if (_preferences.getString(SP_PREFS_LANGUAGE) != null) {
      return _preferences.getString(SP_PREFS_LANGUAGE);
    } else {
      return 'fr';
    }
  }




  void setIntroductionRead() {
    _preferences.setBool(SP_INTRO_SLIDER, true);
  }

  bool? getIntroductionRead() {
    if (_preferences.getBool(SP_INTRO_SLIDER) != null) {
      return _preferences.getBool(SP_INTRO_SLIDER);
    } else {
      return false;
    }
  }


}
