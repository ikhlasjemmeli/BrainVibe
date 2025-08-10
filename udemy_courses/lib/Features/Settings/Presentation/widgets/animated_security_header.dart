import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnimatedSecurityHeader extends StatelessWidget {
  final Animation<double> headerFadeAnimation;

  const AnimatedSecurityHeader({
    Key? key,
    required this.headerFadeAnimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: headerFadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: headerFadeAnimation.value,
          child: Column(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xff764ba2),
                      Color(0xff667eea),
                      Color(0xff6849ef),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff6849ef).withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 1,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.security_rounded,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xff6849ef), Color(0xff764ba2)],
                ).createShader(bounds),
                child: Text(
                  'Securite'.tr,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'changer_mdp_txt'.tr,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}