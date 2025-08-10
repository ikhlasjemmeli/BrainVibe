
import 'package:Brainvibe/Core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controller/settings_controller.dart';
import '../widgets/register_form.dart';
import '../widgets/register_header.dart';
import '../widgets/register_login_link.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  late AnimationController _formAnimationController;
  late AnimationController _buttonAnimationController;

  late Animation<double> _formSlideAnimation;
  late Animation<double> _buttonScaleAnimation;

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _initializeAnimations();
    Future.delayed(const Duration(milliseconds: 300), () {
      _formAnimationController.forward();
    });
  }

  void _initializeAnimations() {
    _formAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _buttonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _formSlideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _formAnimationController,
      curve: Curves.easeOutCubic,
    ));

    _buttonScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _buttonAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _formAnimationController.dispose();
    _buttonAnimationController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _playClickSound() {
    HapticFeedback.lightImpact();
  }

  void _playSuccessSound() {
    HapticFeedback.mediumImpact();
  }

  void _togglePasswordVisibility() {
    setState(() => _isPasswordVisible = !_isPasswordVisible);
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible);
  }

  void _onButtonPressed() {
    _buttonAnimationController.forward();
  }

  void _onButtonReleased() {
    _buttonAnimationController.reverse();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    _playClickSound();
    setState(() => _isLoading = true);

    try {
      final controller = Get.find<SettingsController>();
      await controller.register(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
      );

      _playSuccessSound();
      _showSnackBar('inscription_reussie'.tr, Colors.green);

      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacementNamed(context, '/login');
      });

    } catch (e) {
      _showSnackBar('${'erreur_inscription'.tr} $e', Colors.red);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _navigateToLogin() {
    _playClickSound();
    Navigator.pushNamed(context, ROUTE_LOGIN_PAGE);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f9fa),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                const RegisterHeader(),
                const SizedBox(height: 10),
                RegisterForm(
                  formKey: _formKey,
                  formSlideAnimation: _formSlideAnimation,
                  buttonScaleAnimation: _buttonScaleAnimation,
                  firstNameController: _firstNameController,
                  lastNameController: _lastNameController,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  confirmPasswordController: _confirmPasswordController,
                  isPasswordVisible: _isPasswordVisible,
                  isConfirmPasswordVisible: _isConfirmPasswordVisible,
                  isLoading: _isLoading,
                  onTogglePasswordVisibility: _togglePasswordVisibility,
                  onToggleConfirmPasswordVisibility: _toggleConfirmPasswordVisibility,
                  onPlayClickSound: _playClickSound,
                  onButtonPressed: _onButtonPressed,
                  onButtonReleased: _onButtonReleased,
                  onRegister: _register,
                ),
                const SizedBox(height: 5),
                RegisterLoginLink(
                  onNavigateToLogin: _navigateToLogin,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}