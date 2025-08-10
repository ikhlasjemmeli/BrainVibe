import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Brainvibe/Core/constants.dart';

class SettingsAccountSection extends StatelessWidget {
  final Animation<double> animation;
  final VoidCallback onPlayClickSound;

  const SettingsAccountSection({
    Key? key,
    required this.animation,
    required this.onPlayClickSound,
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
              padding: const EdgeInsets.all(20),
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
                  Text(
                    'parametres_compte'.tr,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff2d3436),
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildSettingTile(
                    context: context,
                    title: 'notifications'.tr,
                    subtitle: 'gerer_notifications'.tr,
                    icon: Icons.notifications,
                    onTap: () {
                      onPlayClickSound();
                    },
                  ),
                  _buildSettingTile(
                    context: context,
                    title: 'confidentialite'.tr,
                    subtitle: 'controler_donnees'.tr,
                    icon: Icons.privacy_tip,
                    onTap: () {
                      onPlayClickSound();
                    },
                  ),
                  _buildSettingTile(
                    context: context,
                    title: 'Securite'.tr,
                    subtitle: 'mdp_et_authentification'.tr,
                    icon: Icons.security,
                    onTap: () {
                      onPlayClickSound();
                      Navigator.pushNamed(context, ROUTE_CHANGE_PASSWORD_PAGE);
                    },
                  ),
                  _buildSettingTile(
                    context: context,
                    title: 'langue'.tr,
                    subtitle: 'Français (France)',
                    icon: Icons.language,
                    onTap: () {
                      onPlayClickSound();
                      Navigator.pushNamed(context, ROUTE_LANGUAGE_PAGE);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xff6849ef).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: const Color(0xff6849ef), size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff2d3436),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[400],
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}