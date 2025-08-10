
import 'package:Brainvibe/Core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../Core/SharedPreferences/sharedpreferences_controller.dart';
import '../controller/settings_controller.dart';
import '../widgets/animated_logo_header.dart';
import '../widgets/login_form_widget.dart';
import '../widgets/register_link_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final SharedPreferencesController _sp = Get.find();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late AnimationController _formAnimationController;
  late AnimationController _buttonAnimationController;
  late AnimationController _logoAnimationController;

  late Animation<double> _formSlideAnimation;
  late Animation<double> _buttonScaleAnimation;
  late Animation<double> _logoRotationAnimation;

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
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

    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
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

    _logoRotationAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 300), () {
      _formAnimationController.forward();
      _logoAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _formAnimationController.dispose();
    _buttonAnimationController.dispose();
    _logoAnimationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _playSuccessSound() {
    HapticFeedback.mediumImpact();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final controller = Get.find<SettingsController>();
      final user = await controller.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        rememberMe: _rememberMe,
      );
      _sp.setUser(user);
      final user2 = _sp.getUser();

      _playSuccessSound();
      _showSnackBar('${'connexion_reussie'.tr} ${user2?.user.firstName} !', Colors.green);

      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacementNamed(context, '/settings');
      });
    } catch (e) {
      _showSnackBar('${'erreur_connexion'.tr} : $e', Colors.red);
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

  void _onForgotPasswordTap() {
    _showSnackBar('Fonctionnalité bientôt disponible', Colors.orange);
  }

  void _onRegisterTap() {
    Navigator.pushNamed(context, ROUTE_REGISTER_PAGE);
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
                AnimatedLogoHeader(logoRotationAnimation: _logoRotationAnimation),
                const SizedBox(height: 20),
                LoginFormWidget(
                  formSlideAnimation: _formSlideAnimation,
                  formKey: _formKey,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  isPasswordVisible: _isPasswordVisible,
                  onTogglePassword: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                  rememberMe: _rememberMe,
                  onRememberMeChanged: () => setState(() => _rememberMe = !_rememberMe),
                  onForgotPasswordTap: _onForgotPasswordTap,
                  buttonScaleAnimation: _buttonScaleAnimation,
                  buttonAnimationController: _buttonAnimationController,
                  isLoading: _isLoading,
                  onLogin: _login,
                ),
                const SizedBox(height: 10),
                RegisterLinkWidget(onRegisterTap: _onRegisterTap),
              ],
            ),
          ),
        ),
      ),
    );
  }
}