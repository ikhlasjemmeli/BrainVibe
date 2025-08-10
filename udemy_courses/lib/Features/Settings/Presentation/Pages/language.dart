import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../../Core/SharedPreferences/sharedpreferences_controller.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({Key? key}) : super(key: key);

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {

  final SharedPreferencesController _sp = Get.find();
  late String _selectedLanguage;

  final List<LanguageModel> _availableLanguages = [
    LanguageModel(code: 'fr', name: 'Français', flag: '🇫🇷', isAvailable: true),
    LanguageModel(code: 'en', name: 'English', flag: '🇺🇸', isAvailable: true),
    LanguageModel(code: 'ar', name: 'العربية', flag: '🇸🇦', isAvailable: true),
    LanguageModel(code: 'es', name: 'Español', flag: '🇪🇸', isAvailable: false),
    LanguageModel(code: 'de', name: 'Deutsch', flag: '🇩🇪', isAvailable: false),
    LanguageModel(code: 'it', name: 'Italiano', flag: '🇮🇹', isAvailable: false),
  ];

  @override
  void initState() {
    _selectedLanguage = _sp.getLangue() ?? "fr";
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f9fa),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xff6849ef)),
          onPressed: () {
           // _playClickSound();
            Navigator.pop(context);
          },
        ),
        title:  Text(
          'changer_lg'.tr,
          style: TextStyle(
            color: Color(0xff6849ef),
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildLanguageSelection(),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageSelection() {
    return Container(
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
      child: Column(
        children: _availableLanguages.map((language) {
          return _buildLanguageOption(language);
        }).toList(),
      ),
    );
  }

  Widget _buildLanguageOption(LanguageModel language) {
    final isSelected = _selectedLanguage == language.code;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: language.isAvailable
            ? () {
          HapticFeedback.lightImpact();
          setState(() {
            _selectedLanguage = language.code;
          });
          _sp.setLangue(language.code);
          Get.updateLocale( Locale(language.code));
        }
            : () {
          HapticFeedback.lightImpact();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Accessible'.tr),
              backgroundColor: Colors.orange,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: language.isAvailable
                ? (isSelected ? const Color(0xff6849ef).withOpacity(0.1) : Colors.grey[50])
                : Colors.grey[100],
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: language.isAvailable
                  ? (isSelected ? const Color(0xff6849ef) : Colors.grey[300]!)
                  : Colors.grey[400]!,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Text(language.flag, style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      language.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: language.isAvailable
                            ? (isSelected ? const Color(0xff6849ef) : Colors.black87)
                            : Colors.grey[500],
                      ),
                    ),
                    if (!language.isAvailable) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Accessible'.tr,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (language.isAvailable)
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? const Color(0xff6849ef) : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? const Color(0xff6849ef) : Colors.grey[400]!,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                      : null,
                )
              else
                Icon(Icons.lock_outline, color: Colors.grey[400], size: 20),
            ],
          ),
        ),
      ),
    );
  }


}

class LanguageModel {
  final String code;
  final String name;
  final String flag;
  final bool isAvailable;

  LanguageModel({
    required this.code,
    required this.name,
    required this.flag,
    required this.isAvailable,
  });
}
