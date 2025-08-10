import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class PasswordFormWidget extends StatelessWidget {
  final Animation<double> formSlideAnimation;
  final GlobalKey<FormState> formKey;
  final TextEditingController oldPasswordController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final bool isOldPasswordVisible;
  final bool isNewPasswordVisible;
  final bool isConfirmPasswordVisible;
  final VoidCallback onToggleOldPassword;
  final VoidCallback onToggleNewPassword;
  final VoidCallback onToggleConfirmPassword;
  final Function(String) onPasswordChanged;
  final double passwordStrength;
  final String strengthText;
  final Color strengthColor;
  final Animation<double> buttonScaleAnimation;
  final AnimationController buttonAnimationController;
  final bool isLoading;
  final VoidCallback? onChangePassword;

  const PasswordFormWidget({
    Key? key,
    required this.formSlideAnimation,
    required this.formKey,
    required this.oldPasswordController,
    required this.newPasswordController,
    required this.confirmPasswordController,
    required this.isOldPasswordVisible,
    required this.isNewPasswordVisible,
    required this.isConfirmPasswordVisible,
    required this.onToggleOldPassword,
    required this.onToggleNewPassword,
    required this.onToggleConfirmPassword,
    required this.onPasswordChanged,
    required this.passwordStrength,
    required this.strengthText,
    required this.strengthColor,
    required this.buttonScaleAnimation,
    required this.buttonAnimationController,
    required this.isLoading,
    this.onChangePassword,
  }) : super(key: key);

  void _playClickSound() {
    HapticFeedback.lightImpact();
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isPasswordVisible,
    required VoidCallback onTogglePassword,
    String? Function(String?)? validator,
    Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !isPasswordVisible,
      validator: validator,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xff6849ef)),
        suffixIcon: GestureDetector(
          onTap: () {
            _playClickSound();
            onTogglePassword();
          },
          child: Icon(
            isPasswordVisible ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey[600],
          ),
        ),
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

  Widget _buildPasswordStrengthIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'force_mdp'.tr,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              strengthText,
              style: TextStyle(
                color: strengthColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 6,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(3),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: passwordStrength,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: strengthColor,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChangePasswordButton() {
    return AnimatedBuilder(
      animation: buttonScaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: buttonScaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) => buttonAnimationController.forward(),
            onTapUp: (_) => buttonAnimationController.reverse(),
            onTapCancel: () => buttonAnimationController.reverse(),
            onTap: isLoading ? null : onChangePassword,
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
                    const Icon(Icons.security_update_good, color: Colors.white, size: 24),
                    const SizedBox(width: 12),
                    Text(
                      'changer_mdp_btn'.tr,
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
                  _buildPasswordField(
                    controller: oldPasswordController,
                    label: 'ancien_mdp'.tr,
                    icon: Icons.lock_outline,
                    isPasswordVisible: isOldPasswordVisible,
                    onTogglePassword: onToggleOldPassword,
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'ancien_mdp_requis'.tr;
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  _buildPasswordField(
                    controller: newPasswordController,
                    label: 'nouveau_mdp'.tr,
                    icon: Icons.lock_reset,
                    isPasswordVisible: isNewPasswordVisible,
                    onTogglePassword: onToggleNewPassword,
                    onChanged: onPasswordChanged,
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'nouveau_mdp_requis'.tr;
                      if (value!.length < 6) return 'mdp_min_6_caracteres'.tr;
                      if (value == oldPasswordController.text) return 'mdp_différent_ancien'.tr;
                      return null;
                    },
                  ),
                  if (passwordStrength > 0) ...[
                    const SizedBox(height: 16),
                    _buildPasswordStrengthIndicator(),
                  ],
                  const SizedBox(height: 24),
                  _buildPasswordField(
                    controller: confirmPasswordController,
                    label: 'confirmer_nouveau_mdp'.tr,
                    icon: Icons.check_circle_outline,
                    isPasswordVisible: isConfirmPasswordVisible,
                    onTogglePassword: onToggleConfirmPassword,
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'confirmation_requise'.tr;
                      if (value != newPasswordController.text) return 'mdp_non_correspondant'.tr;
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  _buildChangePasswordButton(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}