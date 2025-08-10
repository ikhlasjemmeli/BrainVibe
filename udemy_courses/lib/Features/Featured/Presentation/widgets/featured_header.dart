import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class FeaturedHeader extends StatefulWidget {
  final AudioPlayer audioPlayer;

  const FeaturedHeader({Key? key, required this.audioPlayer}) : super(key: key);

  @override
  State<FeaturedHeader> createState() => _FeaturedHeaderState();
}

class _FeaturedHeaderState extends State<FeaturedHeader> with SingleTickerProviderStateMixin {
  late AnimationController _searchAnimationController;
  late Animation<double> _searchScaleAnimation;

  bool _isNotificationActive = false;

  @override
  void initState() {
    super.initState();
    _searchAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _searchScaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _searchAnimationController, curve: Curves.easeInOut),
    );
  }

  void _playNotificationSound() async {
    await widget.audioPlayer.play(AssetSource('sounds/notification.mp3'));
  }

  void _playClickSound() async {
    await widget.audioPlayer.play(AssetSource('sounds/clic.mp3'));
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
    _searchAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff667eea), Color(0xff764ba2), Color(0xff6849ef)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
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
                children: [
                  Text('hello'.tr, style: TextStyle(fontSize: 24, color: Colors.white70)),
                  Text('good_morning'.tr, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
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
                        const Positioned(
                          top: 12,
                          right: 12,
                          child: CircleAvatar(backgroundColor: Color(0xffff6b6b), radius: 4),
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
                      hintText: 'search_your_topic'.tr,
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
}
