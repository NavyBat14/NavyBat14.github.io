import 'package:flutter/material.dart';

class PrivacySettingsPage extends StatefulWidget {
  const PrivacySettingsPage({super.key});

  @override
  State<PrivacySettingsPage> createState() => _PrivacySettingsPageState();
}

class _PrivacySettingsPageState extends State<PrivacySettingsPage> {
  bool locationSharing = false;
  bool profileVisibility = true;
  bool dataCollection = true;
  bool marketingComms = false;
  bool cookiePrefs = true;

  final Color backgroundDark = const Color(0xFF121212);
  final Color cardBackground = const Color(0xFF1E1F23);
  final Color accentGold = const Color(0xFFFFD700);
  final Color switchActive = const Color(0xFFAF7A38);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Privacy Settings',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Row(
              children: [
                Icon(Icons.lock_outline, color: accentGold),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Control how your data is used and shared',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSectionCard(
              'Location Sharing',
              Icons.public,
              locationSharing,
              'Allow the app to access your location for better flight recommendations',
              (val) => setState(() => locationSharing = val),
            ),
            _buildSectionCard(
              'Profile Visibility',
              Icons.person,
              profileVisibility,
              'Make your profile visible to other users',
              (val) => setState(() => profileVisibility = val),
            ),
            _buildSectionCard(
              'Data Collection',
              Icons.shield_outlined,
              dataCollection,
              'Allow us to collect usage data to improve your experience',
              (val) => setState(() => dataCollection = val),
            ),
            const SizedBox(height: 16),
            const Text(
              'Marketing Preferences',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            _buildSectionCard(
              'Marketing Communications',
              Icons.email_outlined,
              marketingComms,
              'Receive emails about promotions, offers, and news',
              (val) => setState(() => marketingComms = val),
            ),
            _buildSectionCard(
              'Cookie Preferences',
              Icons.cookie_outlined,
              cookiePrefs,
              'Allow cookies to personalize your experience',
              (val) => setState(() => cookiePrefs = val),
            ),
            const SizedBox(height: 24),
            const Text(
              'We take your privacy seriously. Your data is encrypted and securely stored. You can request a copy of your data or delete your account at any time.',
              style: TextStyle(color: Colors.white54, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(
    String title,
    IconData icon,
    bool value,
    String subtitle,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            cardBackground.withOpacity(0.6),
            cardBackground.withOpacity(0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: accentGold.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: value ? accentGold : Colors.transparent,
          width: value ? 1.5 : 0,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white12,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: accentGold),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white60, fontSize: 12),
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: 1.2,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: switchActive,
              inactiveTrackColor: Colors.grey.shade800,
              inactiveThumbColor: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
