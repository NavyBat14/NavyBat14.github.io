import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool flightAlerts = true;
  bool priceAlerts = true;
  bool milesRewards = true;
  bool promotions = false;
  bool customerSupport = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1F23),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.notifications, color: Color(0xFFCCA770)),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Manage your notification preferences',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            _buildToggleCard(
              icon: Icons.flight_takeoff,
              title: 'Flight Alerts',
              subtitle:
                  'Get notified about upcoming flights, gate changes, and delays',
              value: flightAlerts,
              onChanged: (val) => setState(() => flightAlerts = val),
            ),
            _buildToggleCard(
              icon: Icons.price_change,
              title: 'Price Alerts',
              subtitle: 'Be alerted when prices drop on saved routes',
              value: priceAlerts,
              onChanged: (val) => setState(() => priceAlerts = val),
            ),
            _buildToggleCard(
              icon: Icons.card_giftcard,
              title: 'Miles & Rewards',
              subtitle:
                  'Updates about your miles balance and new reward opportunities',
              value: milesRewards,
              onChanged: (val) => setState(() => milesRewards = val),
            ),
            _buildToggleCard(
              icon: Icons.local_offer,
              title: 'Promotions',
              subtitle: 'Receive special offers, discounts, and deals',
              value: promotions,
              onChanged: (val) => setState(() => promotions = val),
            ),
            _buildToggleCard(
              icon: Icons.support_agent,
              title: 'Customer Support',
              subtitle: 'Updates about your support tickets and inquiries',
              value: customerSupport,
              onChanged: (val) => setState(() => customerSupport = val),
            ),

            const SizedBox(height: 20),
            const Text(
              'You can change these settings at any time. '
              'See our Privacy Policy for more information on how we handle your data.',
              style: TextStyle(color: Colors.white60, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.02),
            Colors.white.withOpacity(0.07),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: const Color(0xFFCCA770),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFFAF7A38),
        ),
      ),
    );
  }
}
