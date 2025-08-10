
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import '../controller/category_controller.dart';
import '../widgets/categories_section.dart';
import '../widgets/featured_header.dart';


class FeaturedScreen extends StatefulWidget {
  FeaturedScreen({Key? key}) : super(key: key);

  final CategoryController _categoryController = Get.find();

  @override
  State<FeaturedScreen> createState() => _FeaturedScreenState();
}

class _FeaturedScreenState extends State<FeaturedScreen> with TickerProviderStateMixin {
  late AnimationController _headerAnimationController;
  late AnimationController _categoriesAnimationController;

  late Animation<double> _headerSlideAnimation;
  late Animation<double> _categoriesFadeAnimation;

  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();

    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _categoriesAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _headerSlideAnimation = Tween<double>(begin: -100.0, end: 0.0).animate(
      CurvedAnimation(parent: _headerAnimationController, curve: Curves.elasticOut),
    );

    _categoriesFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _categoriesAnimationController, curve: Curves.easeInOut),
    );

    _startAnimations();
    widget._categoryController.getCategories();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _headerAnimationController.forward();
    await Future.delayed(const Duration(milliseconds: 500));
    _categoriesAnimationController.forward();
  }

  void _playClickSound() async {
    await _audioPlayer.play(AssetSource('sounds/clic.mp3'));
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    _categoriesAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f9fa),
      body: SafeArea(
        child: Column(
          children: [
            AnimatedBuilder(
              animation: _headerSlideAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _headerSlideAnimation.value),
                  child: FeaturedHeader(audioPlayer: _audioPlayer),
                );
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: AnimatedBuilder(
                animation: _categoriesFadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _categoriesFadeAnimation.value,
                    child: Transform.translate(
                      offset: Offset(0, (1 - _categoriesFadeAnimation.value) * 50),
                      child: CategoriesSection(
                        controller: widget._categoryController,
                        playClickSound: _playClickSound,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

