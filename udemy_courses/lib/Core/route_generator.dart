import 'package:Brainvibe/Features/Settings/Presentation/Pages/language.dart';
import 'package:flutter/material.dart';
import '../Features/Settings/Presentation/Pages/Settings.dart';
import '../Features/Settings/Presentation/Pages/change_password.dart';
import '../Features/Settings/Presentation/Pages/login.dart';
import '../Features/Settings/Presentation/Pages/register.dart';
import 'constants.dart';


class RouteGenerator {
  static Route<dynamic>? generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case ROUTE_LOGIN_PAGE:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case ROUTE_REGISTER_PAGE:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case ROUTE_SETTINGS_PAGE:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case ROUTE_LANGUAGE_PAGE:
        return MaterialPageRoute(builder: (_) => const LanguageSelectionScreen());
      case ROUTE_CHANGE_PASSWORD_PAGE:
        return MaterialPageRoute(builder: (_) => const ChangePasswordScreen());
      default:
      // TODO WEB NOT FOUND
    }
    return null;
  }
}
