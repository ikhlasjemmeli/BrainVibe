import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SecurityTipsWidget extends StatelessWidget {
  const SecurityTipsWidget({Key? key}) : super(key: key);

  Widget _buildSecurityTip(String tip) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: const Color(0xff6849ef).withOpacity(0.7),
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              tip,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 2000),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xff6849ef).withOpacity(0.05),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: const Color(0xff6849ef).withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.tips_and_updates,
                      color: Color(0xff6849ef),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'conseils_securite'.tr,
                      style: const TextStyle(
                        color: Color(0xff6849ef),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildSecurityTip('conseil_1'.tr),
                _buildSecurityTip('conseil_2'.tr),
                _buildSecurityTip('conseil_3'.tr),
                _buildSecurityTip('conseil_4'.tr),
              ],
            ),
          ),
        );
      },
    );
  }
}