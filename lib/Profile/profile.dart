import 'package:flutter/material.dart';
import 'package:skymiles_app/Profile/help.dart';
import 'package:skymiles_app/Profile/notifications.dart';
import 'package:skymiles_app/Profile/payment_method.dart';
import 'package:skymiles_app/Profile/settings.dart';
import 'package:skymiles_app/Rewards/tier_benefits.dart';
import 'package:skymiles_app/screens/home_page.dart';

class ProfilePage extends StatelessWidget {
  final UserData user;
  final VoidCallback onLogout;

  const ProfilePage({super.key, required this.user, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1F23),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildMilesCard(context),
              const SizedBox(height: 25),
              _buildMenuItem(context, Icons.credit_card, 'Payment Methods'),
              _buildMenuItem(context, Icons.notifications, 'Notifications'),
              _buildMenuItem(context, Icons.settings, 'Settings'),
              _buildMenuItem(context, Icons.help_outline, 'Help & Support'),
              const SizedBox(height: 25),
              _buildLogoutButton(),
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  'App Version 1.0.0',
                  style: TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 32,
          backgroundColor: const Color(0xFFAF7A38),
          child: Text(
            user.name[0].toUpperCase(),
            style: const TextStyle(fontSize: 28, color: Colors.white),
          ),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${user.name.toLowerCase().replaceAll(' ', '')}@example.com',
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE6CEA1), width: 1),
                ),
                child: Text(
                  '${user.tier} Member',
                  style: const TextStyle(
                    color: Color(0xFFE6CEA1),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMilesCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.03),
            Colors.white.withOpacity(0.09),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Miles Balance', style: TextStyle(color: Colors.white70)),
              Text(
                'View All Miles',
                style: TextStyle(color: Color(0xFFAF7A38)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '${user.miles}',
            style: const TextStyle(
              color: Color(0xFFE6CEA1),
              fontSize: 38,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Member since February 2019',
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TierBenefitsPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFAF7A38),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 6,
                shadowColor: Colors.black54,
              ),
              child: Text('View ${user.tier} Tier Benefits'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white, size: 26),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.white24,
          size: 16,
        ),
        onTap: () {
          switch (title) {
            case 'Payment Methods':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PaymentMethodsPage()),
              );
              break;
            case 'Notifications':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsPage()),
              );
              break;
            case 'Settings':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
              break;
            case 'Help & Support':
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder:
                      (context, animation, secondaryAnimation) =>
                          const HelpSupportPage(),
                  transitionsBuilder: (
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ) {
                    const begin = Offset(0.0, 1.0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOut;
                    final tween = Tween(
                      begin: begin,
                      end: end,
                    ).chain(CurveTween(curve: curve));
                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                  transitionDuration: const Duration(milliseconds: 500),
                ),
              );
              break;
          }
        },
      ),
    );
  }

  Widget _buildLogoutButton() {
    return TextButton.icon(
      onPressed: onLogout,
      icon: const Icon(Icons.logout, color: Colors.redAccent),
      label: const Text(
        'Log Out',
        style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
      ),
      style: TextButton.styleFrom(
        backgroundColor: Colors.white10,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        side: const BorderSide(color: Colors.redAccent, width: 1),
      ),
    );
  }
}
