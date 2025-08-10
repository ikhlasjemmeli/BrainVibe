

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../Core/SharedPreferences/sharedpreferences_controller.dart';
import '../../Domain/entities/Auth.dart';
import '../controller/settings_controller.dart';
import '../widgets/settings_account_section.dart';
import '../widgets/settings_danger_zone.dart';
import '../widgets/settings_header.dart';
import '../widgets/settings_profile_section.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with TickerProviderStateMixin {
  final SharedPreferencesController _sp = Get.find();
  late final AuthEntity? ue;

  late AnimationController _headerAnimationController;
  late AnimationController _cardAnimationController;
  late AnimationController _profileAnimationController;

  late Animation<double> _headerSlideAnimation;
  late Animation<double> _cardFadeAnimation;
  late Animation<double> _profileScaleAnimation;

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isEditingProfile = false;
  bool _isLoading = false;
  File? _selectedImage;
  final ImagePicker _imagePicker = ImagePicker();

  bool get isAdmin => true;
  String get currentUserRole => isAdmin ? 'admin' : 'user';

  @override
  void initState() {
    super.initState();
    _headerAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    ue = _sp.getUser();

    if (ue == null) {
      _headerAnimationController.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            Get.toNamed('/login');
          });
        }
      });
    } else {
      _initializeAnimations();
      _startAnimations();
      _loadUserData();
    }
  }

  void _initializeAnimations() {
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _profileAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _headerSlideAnimation = Tween<double>(
      begin: -100.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _headerAnimationController,
      curve: Curves.easeOutCubic,
    ));

    _cardFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cardAnimationController,
      curve: Curves.easeInOut,
    ));

    _profileScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _profileAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _headerAnimationController.forward();

    await Future.delayed(const Duration(milliseconds: 200));
    _cardAnimationController.forward();
  }

  void _loadUserData() {
    if (ue == null) return;

    _firstNameController.text = ue!.user.firstName;
    _lastNameController.text = ue!.user.lastName;
    _emailController.text = ue!.user.email;
  }

  void _playClickSound() {
    HapticFeedback.lightImpact();
  }

  void _playSuccessSound() {
    HapticFeedback.mediumImpact();
  }

  void _toggleEditProfile() {
    _playClickSound();
    setState(() {
      _isEditingProfile = !_isEditingProfile;
    });
    if (_isEditingProfile) {
      _profileAnimationController.forward();
    } else {
      _profileAnimationController.reverse();
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
        _playSuccessSound();
      }
    } catch (e) {
      _showSnackBar('Erreur lors de la sélection de l\'image', Colors.red);
    }
  }

  Future<void> _updateProfile() async {
    setState(() => _isLoading = true);
    final controller = Get.find<SettingsController>();
    try {
      final message = await controller.updateProfile(

        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        profilePicture: '',
      );
      late final AuthEntity? updated_user = ue!;
      if (updated_user != null) {
        final newUser = updated_user.user.copyWith(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
        );
        final newAuth = AuthEntity(
            token: ue!.token,
            user: newUser,
            role: ue!.role
        );
        _sp.removeUser();
        _sp.setUser(newAuth);
      }
      _showSnackBar(message, Colors.green);
      setState(() {
        _isEditingProfile = false;
      });
      _profileAnimationController.reverse();
    } catch (e) {
      _showSnackBar(e.toString(), Colors.red);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _logout() {
    _playClickSound();
    _showConfirmDialog(
      title: 'se_deconnecter'.tr,
      content: 'etes_vous_sur_deconnexion'.tr,
      confirmText: 'deconnexion'.tr,
      onConfirm: () {
        _playSuccessSound();
        _sp.removeUser();
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      },
    );
  }

  void _deactivateAccount() {
    _playClickSound();
    _showConfirmDialog(
        title: 'desactiver_compte'.tr,
        content: 'attention_desactivation'.tr,
        confirmText: 'desactiver'.tr,
        isDestructive: true,
        onConfirm: () async {
          try {
            final controller = Get.find<SettingsController>();
            final message = await controller.deactivateAccount();

            _playSuccessSound();
            _showSnackBar(message, Colors.green);

            Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
          } catch (e) {
            _showSnackBar(e.toString(), Colors.red);
            print('Erreur lors de la désactivation: $e');
          }
        }
    );
  }

  void _showConfirmDialog({
    required String title,
    required String content,
    required String confirmText,
    required VoidCallback onConfirm,
    bool isDestructive = false,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xff2d3436),
            ),
          ),
          content: Text(
            content,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _playClickSound();
                Navigator.of(context).pop();
              },
              child: Text(
                'annuler'.tr,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isDestructive ? Colors.red : const Color(0xff6849ef),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                confirmText,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(20),
      ),
    );
  }

  @override
  void dispose() {
    _headerAnimationController?.dispose();
    _cardAnimationController?.dispose();
    _profileAnimationController?.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (ue == null) {
      Future.microtask(() {
        Navigator.pushReplacementNamed(context, '/login');
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xfff8f9fa),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SettingsHeader(
                animation: _headerSlideAnimation,
                isAdmin: isAdmin,
              ),
              const SizedBox(height: 20),

              SettingsProfileSection(
                animation: _cardFadeAnimation,
                profileScaleAnimation: _profileScaleAnimation,
                isEditingProfile: _isEditingProfile,
                isLoading: _isLoading,
                selectedImage: _selectedImage,
                firstNameController: _firstNameController,
                lastNameController: _lastNameController,
                emailController: _emailController,
                onToggleEdit: _toggleEditProfile,
                onPickImage: _pickImage,
                onUpdateProfile: _updateProfile,
              ),
              const SizedBox(height: 20),

              SettingsAccountSection(
                animation: _cardFadeAnimation,
                onPlayClickSound: _playClickSound,
              ),
              const SizedBox(height: 20),

              SettingsDangerZone(
                animation: _cardFadeAnimation,
                onLogout: _logout,
                onDeactivateAccount: _deactivateAccount,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}