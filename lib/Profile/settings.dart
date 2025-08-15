import 'package:flutter/material.dart';
import 'package:skymiles_app/Profile/Settings/change_password.dart';
import 'package:skymiles_app/Profile/Settings/link.dart';
import 'package:skymiles_app/Profile/Settings/privacy_settings.dart';
import 'package:skymiles_app/Profile/Settings/profile_settings.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool darkMode = true;
  bool biometricLogin = false;

  void _navigateWithFade(BuildContext context, Widget page) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder:
            (_, animation, __, child) =>
                FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  void _navigateWithSlideFromBottom(BuildContext context, Widget page) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, animation, __, child) {
          final offsetAnimation = Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(animation);
          return SlideTransition(position: offsetAnimation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  void _navigateWithScale(BuildContext context, Widget page) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, animation, __, child) {
          final scaleAnimation = Tween<double>(
            begin: 0.8,
            end: 1.0,
          ).animate(animation);
          return ScaleTransition(scale: scaleAnimation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1F23),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Row(
            children: [
              Icon(Icons.settings, color: Color(0xFFCCA770), size: 26),
              SizedBox(width: 8),
              Text(
                'Customize your app experience',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSectionTitle('App Preferences'),
          _buildSettingsCard([
            _buildSwitchTile(
              icon: Icons.dark_mode,
              title: 'Dark Mode',
              value: darkMode,
              onChanged: (val) => setState(() => darkMode = val),
            ),
            _buildSwitchTile(
              icon: Icons.fingerprint,
              title: 'Biometric Login',
              value: biometricLogin,
              onChanged: (val) => setState(() => biometricLogin = val),
            ),
            _buildNavigationTile(
              icon: Icons.language,
              title: 'Language',
              trailingText: 'English',
              onTap: () {},
            ),
          ]),
          const SizedBox(height: 16),
          _buildSectionTitle('Privacy & Security'),
          _buildSettingsCard([
            _buildNavigationTile(
              icon: Icons.lock_outline,
              title: 'Change Password',
              onTap:
                  () => _navigateWithScale(context, const ChangePasswordPage()),
            ),
            _buildNavigationTile(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Settings',
              onTap:
                  () => _navigateWithFade(context, const PrivacySettingsPage()),
            ),
          ]),
          const SizedBox(height: 16),
          _buildSectionTitle('Account'),
          _buildSettingsCard([
            _buildNavigationTile(
              icon: Icons.person_outline,
              title: 'Edit Profile',
              onTap: () => _navigateWithScale(context, const EditProfilePage()),
            ),
            _buildNavigationTile(
              icon: Icons.link,
              title: 'Linked Accounts',
              onTap:
                  () => _navigateWithSlideFromBottom(
                    context,
                    const LinkedAccountsPage(),
                  ),
            ),
          ]),
          const SizedBox(height: 24),
          _buildDangerZoneButton(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFFE6CEA1),
          fontWeight: FontWeight.bold,
          fontSize: 16,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.02),
            Colors.white.withOpacity(0.07),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      activeColor: const Color(0xFFAF7A38),
      tileColor: Colors.transparent,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      secondary: Icon(icon, color: Colors.white, size: 26),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildNavigationTile({
    required IconData icon,
    required String title,
    String? trailingText,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white, size: 26),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing:
          trailingText != null
              ? Text(
                trailingText,
                style: const TextStyle(color: Colors.white70),
              )
              : const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white38,
                size: 16,
              ),
      onTap: onTap,
    );
  }

  Widget _buildDangerZoneButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red[800],
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 6,
        shadowColor: Colors.redAccent.withOpacity(0.5),
      ),
      child: const Text(
        'Danger Zone',
        style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
      ),
    );
  }
}
