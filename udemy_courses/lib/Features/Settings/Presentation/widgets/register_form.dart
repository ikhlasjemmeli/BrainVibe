import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final Animation<double> formSlideAnimation;
  final Animation<double> buttonScaleAnimation;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final bool isLoading;
  final VoidCallback onTogglePasswordVisibility;
  final VoidCallback onToggleConfirmPasswordVisibility;
  final VoidCallback onPlayClickSound;
  final VoidCallback onButtonPressed;
  final VoidCallback onButtonReleased;
  final VoidCallback onRegister;

  const RegisterForm({
    Key? key,
    required this.formKey,
    required this.formSlideAnimation,
    required this.buttonScaleAnimation,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.isPasswordVisible,
    required this.isConfirmPasswordVisible,
    required this.isLoading,
    required this.onTogglePasswordVisibility,
    required this.onToggleConfirmPasswordVisibility,
    required this.onPlayClickSound,
    required this.onButtonPressed,
    required this.onButtonReleased,
    required this.onRegister,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: formSlideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, formSlideAnimation.value),
          child: Container(
            padding: const EdgeInsets.all(24),
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
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: firstNameController,
                          label: 'profil_prenom'.tr,
                          icon: Icons.person_outline,
                          validator: (value) => value?.isEmpty ?? true ? 'prenom_requis'.tr : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                          controller: lastNameController,
                          label: 'profil_nom'.tr,
                          icon: Icons.person_outline,
                          validator: (value) => value?.isEmpty ?? true ? 'nom_requis'.tr : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: passwordController,
                    label: 'mot_de_passe'.tr,
                    icon: Icons.lock_outline,
                    isPassword: true,
                    isPasswordVisible: isPasswordVisible,
                    onTogglePassword: () {
                      onPlayClickSound();
                      onTogglePasswordVisibility();
                    },
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'mot_de_passe'.tr;
                      if (value!.length < 6) return 'mdp_min_6_caracteres'.tr;
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: confirmPasswordController,
                    label: 'confirmer_mot_de_passe'.tr,
                    icon: Icons.lock_outline,
                    isPassword: true,
                    isPasswordVisible: isConfirmPasswordVisible,
                    onTogglePassword: () {
                      onPlayClickSound();
                      onToggleConfirmPasswordVisibility();
                    },
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'confirmation_requise'.tr;
                      if (value != passwordController.text) return 'mots_de_passe_differents'.tr;
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildRegisterButton(),
                ],
              ),
            ),
          ),
        );
      },
    );
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
          onTap: onTogglePassword,
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

  Widget _buildRegisterButton() {
    return AnimatedBuilder(
      animation: buttonScaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: buttonScaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) => onButtonPressed(),
            onTapUp: (_) => onButtonReleased(),
            onTapCancel: () => onButtonReleased(),
            onTap: isLoading ? null : onRegister,
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
                    const Icon(Icons.person_add, color: Colors.white, size: 24),
                    const SizedBox(width: 12),
                    Text(
                      'creer_mon_compte'.tr,
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
}