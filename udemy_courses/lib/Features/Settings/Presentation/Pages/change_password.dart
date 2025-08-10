
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../Core/SharedPreferences/sharedpreferences_controller.dart';
import '../../Domain/entities/Auth.dart';
import '../controller/settings_controller.dart';
import '../widgets/animated_security_header.dart';
import '../widgets/password_form_widget.dart';
import '../widgets/security_tips_widget.dart';


class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> with TickerProviderStateMixin {
  final SharedPreferencesController _sp = Get.find();
  late final AuthEntity? ue = _sp.getUser();
  final _formKey = GlobalKey<FormState>();

  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late AnimationController _formAnimationController;
  late AnimationController _buttonAnimationController;
  late AnimationController _headerAnimationController;
  late AnimationController _strengthAnimationController;

  late Animation<double> _formSlideAnimation;
  late Animation<double> _headerFadeAnimation;
  late Animation<double> _buttonScaleAnimation;
  late Animation<Color?> _strengthColorAnimation;

  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  double _passwordStrength = 0.0;
  String _strengthText = '';
  Color _strengthColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _formAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _buttonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _strengthAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _formSlideAnimation = Tween<double>(
      begin: 80.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _formAnimationController,
      curve: Curves.easeOutBack,
    ));

    _headerFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _headerAnimationController,
      curve: Curves.easeInOut,
    ));

    _buttonScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _buttonAnimationController,
      curve: Curves.easeInOut,
    ));

    _strengthColorAnimation = ColorTween(
      begin: Colors.grey,
      end: Colors.green,
    ).animate(_strengthAnimationController);
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 200), () {
      _headerAnimationController.forward();
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      _formAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _formAnimationController.dispose();
    _buttonAnimationController.dispose();
    _headerAnimationController.dispose();
    _strengthAnimationController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _playSuccessSound() {
    HapticFeedback.mediumImpact();
  }

  void _checkPasswordStrength(String password) {
    double strength = 0;
    String strengthText = '';
    Color strengthColor = Colors.grey;

    if (password.isEmpty) {
      strength = 0;
      strengthText = '';
    } else if (password.length < 6) {
      strength = 0.2;
      strengthText = 'password_very_weak'.tr;
      strengthColor = Colors.red;
    } else if (password.length < 8) {
      strength = 0.4;
      strengthText = 'password_weak'.tr;
      strengthColor = Colors.orange;
    } else {
      bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
      bool hasLowercase = password.contains(RegExp(r'[a-z]'));
      bool hasNumbers = password.contains(RegExp(r'[0-9]'));
      bool hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

      int criteriaCount = 0;
      if (hasUppercase) criteriaCount++;
      if (hasLowercase) criteriaCount++;
      if (hasNumbers) criteriaCount++;
      if (hasSpecialChar) criteriaCount++;

      switch (criteriaCount) {
        case 1:
        case 2:
          strength = 0.6;
          strengthText = 'password_medium';
          strengthColor = Colors.yellow;
          break;
        case 3:
          strength = 0.8;
          strengthText = 'password_strong';
          strengthColor = Colors.lightGreen;
          break;
        case 4:
          strength = 1.0;
          strengthText = 'password_very_strong';
          strengthColor = Colors.green;
          break;
        default:
          strength = 0.4;
          strengthText = 'password_very_weak';
          strengthColor = Colors.orange;
      }
    }

    setState(() {
      _passwordStrength = strength;
      _strengthText = strengthText;
      _strengthColor = strengthColor;
    });

    if (strength > 0) {
      _strengthAnimationController.forward();
    } else {
      _strengthAnimationController.reverse();
    }
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final controller = Get.find<SettingsController>();
      final message = await controller.changePassword(

        oldPassword: _oldPasswordController.text,
        newPassword: _newPasswordController.text,
      );
      _showSnackBar(message, Colors.green);

      _oldPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
      setState(() {
        _passwordStrength = 0;
        _strengthText = '';
      });

      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context);
      });
    } catch (e) {
      _showSnackBar(e.toString(), Colors.red);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _playClickSound() {
    HapticFeedback.lightImpact();
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
            _playClickSound();
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Changer_mdp'.tr,
          style: const TextStyle(
            color: Color(0xff6849ef),
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                AnimatedSecurityHeader(headerFadeAnimation: _headerFadeAnimation),
                const SizedBox(height: 40),
                PasswordFormWidget(
                  formSlideAnimation: _formSlideAnimation,
                  formKey: _formKey,
                  oldPasswordController: _oldPasswordController,
                  newPasswordController: _newPasswordController,
                  confirmPasswordController: _confirmPasswordController,
                  isOldPasswordVisible: _isOldPasswordVisible,
                  isNewPasswordVisible: _isNewPasswordVisible,
                  isConfirmPasswordVisible: _isConfirmPasswordVisible,
                  onToggleOldPassword: () => setState(() => _isOldPasswordVisible = !_isOldPasswordVisible),
                  onToggleNewPassword: () => setState(() => _isNewPasswordVisible = !_isNewPasswordVisible),
                  onToggleConfirmPassword: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                  onPasswordChanged: _checkPasswordStrength,
                  passwordStrength: _passwordStrength,
                  strengthText: _strengthText,
                  strengthColor: _strengthColor,
                  buttonScaleAnimation: _buttonScaleAnimation,
                  buttonAnimationController: _buttonAnimationController,
                  isLoading: _isLoading,
                  onChangePassword: _changePassword,
                ),
                const SizedBox(height: 30),
                const SecurityTipsWidget(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}