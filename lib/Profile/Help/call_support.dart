import 'package:flutter/material.dart';

class CallEmailSupportPage extends StatelessWidget {
  const CallEmailSupportPage({super.key});

  static const Color primary = Color(0xFFFFD700); // Neon gold accent
  static const Color backgroundDark = Color(0xFF0A0A0F); // Futuristic dark
  static const Color cardBackground = Color(0xFF1E1E2A); // Glassmorphic card
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFBDC6C7);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Contact Us',
          style: TextStyle(
            color: primary,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reach out for support, suggestions, or inquiries. We’re here to help!',
                style: TextStyle(
                  color: textSecondary.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 30),

              // Call and Email Cards
              Row(
                children: [
                  Expanded(
                    child: _buildSupportOption(
                      icon: Icons.call_outlined,
                      title: 'Call Us',
                      subtitle: 'Mon-Fri • 9-17',
                      onTap: () {},
                      iconColor: primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSupportOption(
                      icon: Icons.email_outlined,
                      title: 'Email Us',
                      subtitle: 'Mon-Fri • 9-17',
                      onTap: () {},
                      iconColor: primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              Text(
                'Follow us on Social Media',
                style: TextStyle(
                  color: textSecondary.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),

              _buildSocialMediaOption(
                icon: Icons.camera_alt_outlined,
                platform: 'Instagram',
                followers: '4.6K Followers',
                posts: '118 Posts',
                iconColor: Colors.pinkAccent.shade400,
              ),
              _buildSocialMediaOption(
                icon: Icons.send,
                platform: 'Telegram',
                followers: '1.3K Followers',
                posts: '85 Posts',
                iconColor: const Color(0xFF0088CC),
              ),
              _buildSocialMediaOption(
                icon: Icons.facebook,
                platform: 'Facebook',
                followers: '3.8K Followers',
                posts: '136 Posts',
                iconColor: const Color(0xFF1877F2),
              ),
              _buildSocialMediaOption(
                icon: Icons.message,
                platform: 'WhatsApp',
                followers: 'Available Mon-Fri',
                posts: '9-17',
                iconColor: const Color(0xFF25D366),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSupportOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color iconColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              cardBackground.withOpacity(0.8),
              cardBackground.withOpacity(0.4),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: iconColor.withOpacity(0.4), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: iconColor.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: iconColor.withOpacity(0.2),
              child: Icon(icon, color: iconColor, size: 32),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                color: textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: textPrimary.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialMediaOption({
    required IconData icon,
    required String platform,
    required String followers,
    required String posts,
    required Color iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            cardBackground.withOpacity(0.8),
            cardBackground.withOpacity(0.5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: iconColor.withOpacity(0.5), width: 1),
        boxShadow: [
          BoxShadow(
            color: iconColor.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: iconColor.withOpacity(0.9),
            child: Icon(icon, color: backgroundDark, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  platform,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                ),
                Text(
                  '$followers • $posts',
                  style: TextStyle(fontSize: 12, color: textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
