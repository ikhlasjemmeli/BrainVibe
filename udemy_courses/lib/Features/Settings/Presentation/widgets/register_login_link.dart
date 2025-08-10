import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterLoginLink extends StatelessWidget {
  final VoidCallback onNavigateToLogin;

  const RegisterLoginLink({
    Key? key,
    required this.onNavigateToLogin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 1000),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: GestureDetector(
            onTap: onNavigateToLogin,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  children: [
                    TextSpan(text: 'deja_compte'.tr),
                    TextSpan(
                      text: 'se_connecter'.tr,
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