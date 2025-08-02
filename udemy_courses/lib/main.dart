import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:Brainvibe/Features/Featured/Presentation/pages/featured_screen.dart';
import 'package:Brainvibe/Features/Featured/Presentation/controller/category_bindings.dart';

void main() async{
  await dotenv.load(fileName: ".env.development");
  Get.put(Dio());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Education App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialBinding: CategoryBindings(),
      home: const EducationAppMainScreen(),
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
    Scaffold(body: Center(child: Text("Settings"))),
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
