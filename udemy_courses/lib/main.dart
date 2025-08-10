import 'dart:ui';
import 'package:Brainvibe/Core/constants.dart';
import 'package:Brainvibe/Core/core_binding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:Brainvibe/Features/Featured/Presentation/pages/featured_screen.dart';
import 'package:Brainvibe/Features/Featured/Presentation/controller/category_bindings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Core/app_translations.dart';
import 'Features/Settings/Presentation/Pages/Settings.dart';
import 'Features/Settings/Presentation/Pages/change_password.dart';
import 'Features/Settings/Presentation/Pages/language.dart';
import 'Features/Settings/Presentation/Pages/login.dart';
import 'Features/Settings/Presentation/Pages/register.dart';
import 'Features/Settings/Presentation/controller/settings_bindings.dart';
import 'package:devicelocale/devicelocale.dart';
void main() async{
  await dotenv.load(fileName: ".env.development");
  Locale? l = await Devicelocale.currentAsLocale;
   locale = l?.languageCode;
  SharedPreferences _sp = await SharedPreferences.getInstance();


  Get.put<Dio>(Dio(), permanent: true);
  runApp(MyApp(_sp));
}
String? locale;
class MyApp extends StatelessWidget {
  final SharedPreferences _sp;
  const MyApp(this._sp,{super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Education App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      initialBinding: BindingsBuilder(() {
        CoreBinding().dependencies();
        CategoryBindings().dependencies();

        SettingsBindings().dependencies();



      }),
      home: const EducationAppMainScreen(),
      translations: AppTranslation(),

      locale: Locale(_sp.getString(SP_PREFS_LANGUAGE) ?? 'fr'),
      fallbackLocale: const Locale("fr"),
      getPages: [
        GetPage(
          name: ROUTE_LOGIN_PAGE,
          page: () => LoginScreen(),
          bindings: [CoreBinding(),SettingsBindings()],
        ),
        GetPage(
          name: ROUTE_REGISTER_PAGE,
          page: () =>  RegisterScreen(),
          bindings: [CoreBinding(),SettingsBindings(),],
        ),
        GetPage(
          name: ROUTE_SETTINGS_PAGE,
          page: () =>  SettingsScreen(),
          bindings: [CoreBinding(),SettingsBindings()],
        ),
        GetPage(
          name: ROUTE_LANGUAGE_PAGE,
          page: () =>  LanguageSelectionScreen(),
          bindings: [],
        ),
        GetPage(
          name: ROUTE_CHANGE_PASSWORD_PAGE,
          page: () =>  ChangePasswordScreen(),
          bindings: [],
        ),



      ],
    );
  }
}


class EducationAppMainScreen extends StatefulWidget {
  const EducationAppMainScreen({super.key});

  @override
  State<EducationAppMainScreen> createState() => _EducationAppScreenState();
}


class _EducationAppScreenState extends State<EducationAppMainScreen> {
  int selectedIndex = 0;

  static  List<Widget> _pages = <Widget>[
    FeaturedScreen(),
    Scaffold(body: Center(child: Text("Learning"))),
    Scaffold(body: Center(child: Text("Wishlist"))),
    SettingsScreen()

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[selectedIndex],

      bottomNavigationBar: BottomNavigationBar(

        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xff6849ef),
        iconSize: 26,
        backgroundColor: Colors.white,
        elevation: 0,
        currentIndex: selectedIndex,
        onTap: (int index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.star),
            icon: Icon(Icons.star_border),
            label: "Featured",
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.play_circle),
            icon: Icon(Icons.play_circle_outline),
            label: "Learning",
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.favorite),
            icon: Icon(Icons.favorite_border),
            label: "Wishlist",
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.settings),
            icon: Icon(Icons.settings_outlined),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
