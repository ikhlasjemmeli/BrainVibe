import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({Key? key}) : super(key: key);

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen>
    with TickerProviderStateMixin {

  // Animation controllers
  late AnimationController _headerAnimationController;
  late AnimationController _cardAnimationController;
  late AnimationController _profileAnimationController;

  late Animation<double> _headerSlideAnimation;
  late Animation<double> _cardFadeAnimation;
  late Animation<double> _profileScaleAnimation;

  // Controllers pour les champs de profil
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();

  // États
  bool _isEditingProfile = false;
  bool _isLoading = false;
  File? _selectedImage;
  final ImagePicker _imagePicker = ImagePicker();

  // Données mockées - À remplacer par vos vrais données
  bool get isAdmin => true; // TODO: Récupérer depuis AuthController
  String get currentUserRole => isAdmin ? 'admin' : 'user';

  // Statistiques mockées pour admin
  final Map<String, dynamic> adminStats = {
    'activeAccounts': 1250,
    'inactiveAccounts': 89,
    'totalCourses': 245,
    'totalCategories': 12,
    'coursesConsumed': 15420,
    'categoriesWithCourses': [
      {'name': 'Programmation', 'courses': 45},
      {'name': 'Design', 'courses': 32},
      {'name': 'Marketing', 'courses': 28},
      {'name': 'Business', 'courses': 41},
      {'name': 'Langues', 'courses': 23},
    ],
  };

  @override
  void initState() {
    super.initState();

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

    _startAnimations();
    _loadUserData();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _headerAnimationController.forward();

    await Future.delayed(const Duration(milliseconds: 200));
    _cardAnimationController.forward();
  }

  void _loadUserData() {
    // TODO: Charger les données utilisateur depuis l'API
    _firstNameController.text = 'John';
    _lastNameController.text = 'Doe';
    _emailController.text = 'john.doe@example.com';
    _usernameController.text = 'johndoe';
    _phoneController.text = '+33 6 12 34 56 78';
  }

  void _playClickSound() {
    // SystemSound.play(SystemSound.selection);
    HapticFeedback.lightImpact();
  }

  void _playSuccessSound() {
    // SystemSound.play(SystemSound.alert);
    HapticFeedback.mediumImpact();
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    _cardAnimationController.dispose();
    _profileAnimationController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f9fa),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              if (isAdmin) ...[
                _buildAdminDashboard(),
                const SizedBox(height: 20),
              ],
             /* _buildProfileSection(),
              const SizedBox(height: 20),
              _buildAccountSettings(),
              const SizedBox(height: 20),*/
              _buildDangerZone(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return AnimatedBuilder(
      animation: _headerSlideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _headerSlideAnimation.value),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xff667eea),
                  Color(0xff764ba2),
                  Color(0xff6849ef),
                ],
              ),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xff6849ef).withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _playClickSound();
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Colors.white, Color(0xfff0f0f0)],
                      ).createShader(bounds),
                      child: Text(
                        isAdmin ? 'Administration' : 'Paramètres',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isAdmin
                            ? Colors.amber.withOpacity(0.3)
                            : Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isAdmin ? Icons.admin_panel_settings : Icons.person,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAdminDashboard() {
    return AnimatedBuilder(
      animation: _cardFadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _cardFadeAnimation.value,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tableau de Bord',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff2d3436),
                  ),
                ),
                const SizedBox(height: 15),
                _buildStatsGrid(),
              /*  const SizedBox(height: 20),
                _buildCategoriesStats(),
                const SizedBox(height: 20),
                _buildAddCategoryButton(),*/
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.3,
      children: [
        _buildStatCard(
          title: 'Comptes Actifs',
          value: adminStats['activeAccounts'].toString(),
          icon: Icons.people,
          color: Colors.green,
        ),
        _buildStatCard(
          title: 'Comptes Inactifs',
          value: adminStats['inactiveAccounts'].toString(),
          icon: Icons.people_outline,
          color: Colors.orange,
        ),
        _buildStatCard(
          title: 'Total Cours',
          value: adminStats['totalCourses'].toString(),
          icon: Icons.play_circle_filled,
          color: const Color(0xff6849ef),
        ),
        _buildStatCard(
          title: 'Catégories',
          value: adminStats['totalCategories'].toString(),
          icon: Icons.category,
          color: Colors.blue,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        _playClickSound();
      },
      child: Container(
        padding: const EdgeInsets.all(16),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesStats() {
    return Container(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Cours par Catégorie',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff2d3436),
                ),
              ),
              Text(
                'Total: ${adminStats['coursesConsumed']} consommés',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ...adminStats['categoriesWithCourses']
              .map<Widget>((category) => _buildCategoryItem(category))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(Map<String, dynamic> category) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: const Color(0xff6849ef),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              category['name'],
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xff6849ef).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${category['courses']} cours',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xff6849ef),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddCategoryButton() {
    return GestureDetector(
      onTap: () {
        _playClickSound();
        // TODO: Navigation vers AddCategoryScreen
        Navigator.pushNamed(context, '/add-category');
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xff667eea), Color(0xff764ba2)],
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: const Color(0xff6849ef).withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle, color: Colors.white, size: 24),
            SizedBox(width: 12),
            Text(
              'Ajouter une Nouvelle Catégorie',
              style: TextStyle(
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

  Widget _buildProfileSection() {
    return AnimatedBuilder(
      animation: _cardFadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _cardFadeAnimation.value,
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
                      const Text(
                        'Profil Utilisateur',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff2d3436),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _playClickSound();
                          setState(() {
                            _isEditingProfile = !_isEditingProfile;
                          });
                          if (_isEditingProfile) {
                            _profileAnimationController.forward();
                          } else {
                            _profileAnimationController.reverse();
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xff6849ef).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            _isEditingProfile ? Icons.save : Icons.edit,
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
                  if (_isEditingProfile) ...[
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
        onTap: _isEditingProfile ? _pickImage : null,
        child: AnimatedBuilder(
          animation: _profileScaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _isEditingProfile ? _profileScaleAnimation.value : 1.0,
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
                    child: _selectedImage != null
                        ? ClipOval(
                      child: Image.file(
                        _selectedImage!,
                        fit: BoxFit.cover,
                      ),
                    )
                        : const Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  if (_isEditingProfile)
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
      children: [
        _buildInfoTile('Prénom', _firstNameController.text, Icons.person),
        _buildInfoTile('Nom', _lastNameController.text, Icons.person_outline),
        _buildInfoTile('Email', _emailController.text, Icons.email),
        _buildInfoTile('Nom d\'utilisateur', _usernameController.text, Icons.alternate_email),
        _buildInfoTile('Téléphone', _phoneController.text, Icons.phone),
      ],
    );
  }

  Widget _buildInfoTile(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xff6849ef), size: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
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
              child: _buildEditTextField(_firstNameController, 'Prénom', Icons.person),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildEditTextField(_lastNameController, 'Nom', Icons.person_outline),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildEditTextField(_emailController, 'Email', Icons.email),
        const SizedBox(height: 16),
        _buildEditTextField(_usernameController, 'Nom d\'utilisateur', Icons.alternate_email),
        const SizedBox(height: 16),
        _buildEditTextField(_phoneController, 'Téléphone', Icons.phone),
        const SizedBox(height: 20),
        _buildSaveButton(),
      ],
    );
  }

  Widget _buildEditTextField(TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      controller: controller,
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
      onTap: _saveProfile,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xff667eea), Color(0xff764ba2)],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.save, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(
              'Sauvegarder',
              style: TextStyle(
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

  Widget _buildAccountSettings() {
    return AnimatedBuilder(
      animation: _cardFadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _cardFadeAnimation.value,
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
                  const Text(
                    'Paramètres du Compte',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff2d3436),
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildSettingTile(
                    title: 'Notifications',
                    subtitle: 'Gérer les notifications',
                    icon: Icons.notifications,
                    onTap: () {
                      _playClickSound();
                      // TODO: Ouvrir les paramètres de notifications
                    },
                  ),
                  _buildSettingTile(
                    title: 'Confidentialité',
                    subtitle: 'Contrôler vos données',
                    icon: Icons.privacy_tip,
                    onTap: () {
                      _playClickSound();
                      // TODO: Ouvrir les paramètres de confidentialité
                    },
                  ),
                  _buildSettingTile(
                    title: 'Sécurité',
                    subtitle: 'Mot de passe et authentification',
                    icon: Icons.security,
                    onTap: () {
                      _playClickSound();
                      // TODO: Ouvrir les paramètres de sécurité
                    },
                  ),
                  _buildSettingTile(
                    title: 'Langue',
                    subtitle: 'Français (France)',
                    icon: Icons.language,
                    onTap: () {
                      _playClickSound();
                      // TODO: Ouvrir les paramètres de langue
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

  Widget _buildDangerZone() {
    return AnimatedBuilder(
      animation: _cardFadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _cardFadeAnimation.value,
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
                      const Text(
                        'Zone Dangereuse',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff2d3436),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  _buildDangerButton(
                    title: 'Se Déconnecter',
                    subtitle: 'Fermer votre session',
                    icon: Icons.logout,
                    color: Colors.orange,
                    onTap: _logout,
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

  // Méthodes d'action
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

  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);

    try {
      // TODO: Appel API pour sauvegarder le profil
      await Future.delayed(const Duration(seconds: 1));

      _playSuccessSound();
      _showSnackBar('Profil mis à jour avec succès !', Colors.green);

      setState(() {
        _isEditingProfile = false;
      });
      _profileAnimationController.reverse();

    } catch (e) {
      _showSnackBar('Erreur lors de la sauvegarde', Colors.red);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _logout() {
    _playClickSound();
    _showConfirmDialog(
      title: 'Se Déconnecter',
      content: 'Êtes-vous sûr de vouloir vous déconnecter ?',
      confirmText: 'Déconnexion',
      onConfirm: () {
        // TODO: Appel à AuthController.logout()
        _playSuccessSound();
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      },
    );
  }

  void _deactivateAccount() {
    _playClickSound();
    _showConfirmDialog(
      title: 'Désactiver le Compte',
      content: 'Attention ! Cette action désactivera temporairement votre compte. Vous pourrez le réactiver en vous reconnectant.',
      confirmText: 'Désactiver',
      isDestructive: true,
      onConfirm: () async {
        try {
          // TODO: Appel API pour désactiver le compte
          await Future.delayed(const Duration(seconds: 1));

          _playSuccessSound();
          _showSnackBar('Compte désactivé avec succès', Colors.orange);

          Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        } catch (e) {
          _showSnackBar('Erreur lors de la désactivation', Colors.red);
        }
      },
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
                'Annuler',
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
}