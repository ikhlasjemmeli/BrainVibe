
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnimatedLogoHeader extends StatelessWidget {
  final Animation<double> logoRotationAnimation;

  const AnimatedLogoHeader({
    Key? key,
    required this.logoRotationAnimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: logoRotationAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: logoRotationAnimation.value * 0.1,
          child: Transform.scale(
            scale: 0.8 + (logoRotationAnimation.value * 0.2),
            child: Column(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xff667eea),
                        Color(0xff764ba2),
                        Color(0xff6849ef),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff6849ef).withOpacity(0.4),
                        blurRadius: 25,
                        spreadRadius: 2,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.school_rounded,
                    size: 70,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xff6849ef), Color(0xff764ba2)],
                  ).createShader(bounds),
                  child: Text(
                    'bon_retour'.tr,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'connectez_vous_txt'.tr,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}