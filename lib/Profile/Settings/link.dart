import 'package:flutter/material.dart';

class LinkedAccountsPage extends StatelessWidget {
  const LinkedAccountsPage({super.key});

  final Color backgroundDark = const Color(0xFF121212);
  final Color tileBackground = const Color(0xFF1E1F23);
  final Color accentGold = const Color(0xFFFFD700);
  final Color subtitleConnected = Colors.greenAccent;
  final Color subtitleDisconnected = Colors.white54;

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
          'Linked Accounts',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.link, color: accentGold),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Connect your accounts for faster login and a more personalized experience.',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildAccountTile(
              iconUrl: 'https://img.icons8.com/color/48/google-logo.png',
              title: 'Google',
              connected: true,
              onTap: () {},
              actionText: 'Unlink',
            ),
            _buildAccountTile(
              iconUrl: 'https://img.icons8.com/color/48/facebook-new.png',
              title: 'Facebook',
              connected: false,
              onTap: () {},
              actionText: '+ Link',
            ),
            _buildAccountTile(
              iconUrl: 'https://img.icons8.com/ios-filled/50/apple-logo.png',
              title: 'Apple',
              connected: true,
              onTap: () {},
              actionText: 'Unlink',
            ),
            _buildAccountTile(
              iconUrl: 'https://img.icons8.com/color/48/twitter--v1.png',
              title: 'Twitter',
              connected: false,
              onTap: () {},
              actionText: '+ Link',
            ),
            const SizedBox(height: 20),
            const Text(
              'Linking your accounts allows for faster sign-in and ensures a more seamless experience. We will never post to your accounts without your permission.',
              style: TextStyle(color: Colors.white54, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountTile({
    required String iconUrl,
    required String title,
    required bool connected,
    required VoidCallback onTap,
    required String actionText,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            tileBackground.withOpacity(0.6),
            tileBackground.withOpacity(0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: accentGold.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: connected ? subtitleConnected : Colors.transparent,
          width: connected ? 1.5 : 0,
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: Colors.black26,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.network(
              iconUrl,
              fit: BoxFit.cover,
              errorBuilder:
                  (_, __, ___) => const Icon(Icons.link, color: Colors.white),
            ),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          connected ? 'Connected' : 'Not connected',
          style: TextStyle(
            color: connected ? subtitleConnected : subtitleDisconnected,
            fontSize: 12,
          ),
        ),
        trailing: Container(
          decoration: BoxDecoration(
            gradient:
                connected
                    ? null
                    : LinearGradient(
                      colors: [
                        accentGold.withOpacity(0.9),
                        accentGold.withOpacity(0.6),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
            borderRadius: BorderRadius.circular(30),
            border: connected ? Border.all(color: Colors.redAccent) : null,
            boxShadow: [
              if (!connected)
                BoxShadow(
                  color: accentGold.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
            ],
          ),
          child: TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              foregroundColor: connected ? Colors.redAccent : Colors.black,
              backgroundColor:
                  connected ? Colors.transparent : Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              actionText,
              style: TextStyle(
                color: connected ? Colors.redAccent : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
