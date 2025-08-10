import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsDangerZone extends StatelessWidget {
  final Animation<double> animation;
  final VoidCallback onLogout;
  final VoidCallback onDeactivateAccount;

  const SettingsDangerZone({
    Key? key,
    required this.animation,
    required this.onLogout,
    required this.onDeactivateAccount,
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
                border: Border.all(color: Colors.red.withOpacity(0.2)),
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
                    children: [
                      Icon(Icons.warning, color: Colors.red[400], size: 24),
                      const SizedBox(width: 8),
                      Text(
                        'zone_dangereuse'.tr,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff2d3436),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  _buildDangerButton(
                    title: 'se_deconnecter'.tr,
                    subtitle: 'fermer_session'.tr,
                    icon: Icons.logout,
                    color: Colors.orange,
                    onTap: onLogout,
                  ),
                  const SizedBox(height: 12),
                  _buildDangerButton(
                    title: 'desactiver_compte'.tr,
                    subtitle: 'desactiver_temporairement'.tr,
                    icon: Icons.pause_circle,
                    color: Colors.red,
                    onTap: onDeactivateAccount,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDangerButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: color.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: color.withOpacity(0.7),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}