import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class LoginFormWidget extends StatelessWidget {
  final Animation<double> formSlideAnimation;
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isPasswordVisible;
  final VoidCallback onTogglePassword;
  final bool rememberMe;
  final VoidCallback onRememberMeChanged;
  final VoidCallback onForgotPasswordTap;
  final Animation<double> buttonScaleAnimation;
  final AnimationController buttonAnimationController;
  final bool isLoading;
  final VoidCallback? onLogin;

  const LoginFormWidget({
    Key? key,
    required this.formSlideAnimation,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.isPasswordVisible,
    required this.onTogglePassword,
    required this.rememberMe,
    required this.onRememberMeChanged,
    required this.onForgotPasswordTap,
    required this.buttonScaleAnimation,
    required this.buttonAnimationController,
    required this.isLoading,
    this.onLogin,
  }) : super(key: key);

  void _playClickSound() {
    HapticFeedback.lightImpact();
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onTogglePassword,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword && !isPasswordVisible,
      validator: validator,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xff6849ef)),
        suffixIcon: isPassword
            ? GestureDetector(
          onTap: () {
            _playClickSound();
            onTogglePassword?.call();
          },
          child: Icon(
            isPasswordVisible ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey[600],
          ),
        )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xff6849ef), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildRememberMeAndForgotPassword() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                _playClickSound();
                onRememberMeChanged();
              },
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: rememberMe ? const Color(0xff6849ef) : Colors.grey[400]!,
                    width: 2,
                  ),
                  color: rememberMe ? const Color(0xff6849ef) : Colors.transparent,
                ),
                child: rememberMe
                    ? const Icon(Icons.check, color: Colors.white, size: 14)
                    : null,
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                _playClickSound();
                onRememberMeChanged();
              },
              child: Text(
                'se_souvenir'.tr,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            _playClickSound();
            onForgotPasswordTap();
          },
          child: Text(
            'mot_de_passe_oublie'.tr,
            style: const TextStyle(
              color: Color(0xff6849ef),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return AnimatedBuilder(
      animation: buttonScaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: buttonScaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) => buttonAnimationController.forward(),
            onTapUp: (_) => buttonAnimationController.reverse(),
            onTapCancel: () => buttonAnimationController.reverse(),
            onTap: isLoading ? null : onLogin,
            child: Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xff667eea),
                    Color(0xff764ba2),
                    Color(0xff6849ef),
                  ],
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff6849ef).withOpacity(0.4),
                    blurRadius: 15,
                    spreadRadius: 1,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: isLoading
                    ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 2,
                  ),
                )
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.login_rounded, color: Colors.white, size: 24),
                    const SizedBox(width: 12),
                    Text(
                      'se_connecter'.tr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
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

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: formSlideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, formSlideAnimation.value),
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  spreadRadius: 1,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  _buildTextField(
                    controller: emailController,
                    label: 'email'.tr,
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'email_requis'.tr;
                      if (!GetUtils.isEmail(value!)) return 'email_invalide'.tr;
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  _buildTextField(
                    controller: passwordController,
                    label: 'mot_de_passe'.tr,
                    icon: Icons.lock_outline,
                    isPassword: true,
                    isPasswordVisible: isPasswordVisible,
                    onTogglePassword: onTogglePassword,
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'mot_de_passe_requis'.tr;
                      if (value!.length < 6) return 'mdp_min_6_caracteres'.tr;
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildRememberMeAndForgotPassword(),
                  const SizedBox(height: 30),
                  _buildLoginButton(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
