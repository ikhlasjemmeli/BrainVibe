

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controller/category_controller.dart';

class FeaturedScreen extends StatefulWidget {
  FeaturedScreen({Key? key}) : super(key: key);

  final CategoryController _categoryController = Get.find();

  @override
  State<FeaturedScreen> createState() => _FeaturedScreenState();
}

class _FeaturedScreenState extends State<FeaturedScreen> with TickerProviderStateMixin {
  late AnimationController _headerAnimationController;
  late AnimationController _categoriesAnimationController;
  late AnimationController _searchAnimationController;

  late Animation<double> _headerSlideAnimation;
  late Animation<double> _searchScaleAnimation;
  late Animation<double> _categoriesFadeAnimation;

  bool _isNotificationActive = false;

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

    _searchAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _headerSlideAnimation = Tween<double>(begin: -100.0, end: 0.0).animate(
      CurvedAnimation(parent: _headerAnimationController, curve: Curves.elasticOut),
    );

    _searchScaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _searchAnimationController, curve: Curves.easeInOut),
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


  final AudioPlayer _audioPlayer = AudioPlayer();

  void _playNotificationSound() async {
    await _audioPlayer.play(AssetSource('sounds/notification.mp3'));
  }

  void _playClickSound() async {
    await _audioPlayer.play(AssetSource('sounds/clic.mp3'));
  }

  void _onNotificationTap() {
    _playNotificationSound();
    setState(() => _isNotificationActive = true);
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() => _isNotificationActive = false);
    });
  }

  void _onSearchFocus() {
    _searchAnimationController.forward();
    HapticFeedback.selectionClick();
  }

  void _onSearchUnfocus() {
    _searchAnimationController.reverse();
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    _categoriesAnimationController.dispose();
    _searchAnimationController.dispose();
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
                  child: _buildHeader(),
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
                      child: _buildCategoriesSection(),
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

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xff667eea), Color(0xff764ba2), Color(0xff6849ef)],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Hello,",
                    style: TextStyle(fontSize: 24, color: Colors.white70),
                  ),
                  Text(
                    "Good Morning",
                    style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              GestureDetector(
                onTap: _onNotificationTap,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isNotificationActive ? Colors.white24 : Colors.white30,
                    border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(Icons.notifications_outlined, color: Colors.white, size: _isNotificationActive ? 26 : 24),
                      if (_isNotificationActive)
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xffff6b6b),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          AnimatedBuilder(
            animation: _searchScaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _searchScaleAnimation.value,
                child: Focus(
                  onFocusChange: (hasFocus) {
                    hasFocus ? _onSearchFocus() : _onSearchUnfocus();
                  },
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search, color: Colors.black45),
                      suffixIcon: GestureDetector(
                        onTap: _playClickSound,
                        child: const Icon(Icons.mic, color: Color(0xff6849ef)),
                      ),
                      hintText: "Search your topic",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Explore Categories",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff2d3436)),
              ),
              GestureDetector(
                onTap: _playClickSound,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xff6849ef), Color(0xff764ba2)]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "See All",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Expanded(
          child: Obx(() {
            final categories = widget._categoryController.listcategories;
            if (categories.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xff6849ef))),
              );
            }
            return GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) => _buildCategoryCard(categories[index], index),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(category, int index) {
    return GestureDetector(
      onTap: _playClickSound,
      child: TweenAnimationBuilder(
        duration: Duration(milliseconds: 600 + index * 100),
        tween: Tween<double>(begin: 0, end: 1),
        builder: (context, double value, child) {
          return Transform.scale(
            scale: value,
            child: Opacity(
              opacity: value,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 15,
                      spreadRadius: 1,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 3,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
                            'assets/${category.coverImage}',
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 60),
                          ),
                        ),
                      ),
                      //const SizedBox(height: 2),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Text(
                              category.name ?? "No name",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Color(0xff2d3436),
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            //const SizedBox(height: 2),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.play_circle_outline, size: 14, color: Colors.grey[600]),
                               // const SizedBox(width: 4),
                                Text(
                                  "${category.noOfCourse ?? 0} Courses",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
