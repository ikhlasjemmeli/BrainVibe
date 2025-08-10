
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class RegisterLinkWidget extends StatelessWidget {
  final VoidCallback onRegisterTap;

  const RegisterLinkWidget({
    Key? key,
    required this.onRegisterTap,
  }) : super(key: key);

  void _playClickSound() {
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 1400),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: GestureDetector(
            onTap: () {
              _playClickSound();
              onRegisterTap();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  children: [
                    TextSpan(text: 'pas_de_compte'.tr),
                    TextSpan(
                      text: 'sinscrire'.tr,
                      style: const TextStyle(
                        color: Color(0xff6849ef),
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}