import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

class SettingsProfileSection extends StatelessWidget {
  final Animation<double> animation;
  final Animation<double> profileScaleAnimation;
  final bool isEditingProfile;
  final bool isLoading;
  final File? selectedImage;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final VoidCallback onToggleEdit;
  final VoidCallback onPickImage;
  final VoidCallback onUpdateProfile;

  const SettingsProfileSection({
    Key? key,
    required this.animation,
    required this.profileScaleAnimation,
    required this.isEditingProfile,
    required this.isLoading,
    required this.selectedImage,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.onToggleEdit,
    required this.onPickImage,
    required this.onUpdateProfile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 15,
                    spreadRadius: 1,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'profil_utilisateur'.tr,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff2d3436),
                        ),
                      ),
                      GestureDetector(
                        onTap: onToggleEdit,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xff6849ef).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            isEditingProfile ? Icons.save : Icons.edit,
                            color: const Color(0xff6849ef),
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildProfilePicture(),
                  const SizedBox(height: 20),
                  if (isEditingProfile) ...[
                    _buildEditableProfileFields(),
                  ] else ...[
                    _buildProfileInfo(),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfilePicture() {
    return Center(
      child: GestureDetector(
        onTap: isEditingProfile ? onPickImage : null,
        child: AnimatedBuilder(
          animation: profileScaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: isEditingProfile ? profileScaleAnimation.value : 1.0,
              child: Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xff6849ef), Color(0xff764ba2)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xff6849ef).withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: selectedImage != null
                        ? ClipOval(
                      child: Image.file(
                        selectedImage!,
                        fit: BoxFit.cover,
                      ),
                    )
                        : const Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  if (isEditingProfile)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 16,
                          color: Color(0xff6849ef),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildNameRow(),
        _buildInfoTile(emailController.text, Icons.email),
      ],
    );
  }

  Widget _buildNameRow() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            firstNameController.text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xff2d3436),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            lastNameController.text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xff2d3436),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xff6849ef), size: 20),
          const SizedBox(width: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xff2d3436),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableProfileFields() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildEditTextField(firstNameController, 'profil_prenom'.tr, Icons.person),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildEditTextField(lastNameController, 'profil_nom'.tr, Icons.person_outline),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildEditTextField(emailController, 'email'.tr, Icons.email, enabled: false),
        const SizedBox(height: 20),
        _buildSaveButton(),
      ],
    );
  }

  Widget _buildEditTextField(TextEditingController controller, String label, IconData icon, {bool enabled = true}) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xff6849ef)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xff6849ef), width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildSaveButton() {
    return GestureDetector(
      onTap: onUpdateProfile,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xff667eea), Color(0xff764ba2)],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.save, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              'sauvegarder'.tr,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}