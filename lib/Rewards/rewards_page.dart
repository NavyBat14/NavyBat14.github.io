import 'package:flutter/material.dart';
import 'package:skymiles_app/screens/home_page.dart';

class RewardsPage extends StatelessWidget {
  final UserData user;
  final void Function(int milesCost) onClaimReward;

  const RewardsPage({
    super.key,
    required this.user,
    required this.onClaimReward,
  });

  @override
  Widget build(BuildContext context) {
    final allRewards = _getAllRewards();
    final unlockedTiers = _getUnlockedTiers(user.tier);

    return Scaffold(
      backgroundColor: const Color(0xFF1E1F23), // Dark, futuristic
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Your Rewards',
          style: TextStyle(
            color: Color(0xFFE6CEA1),
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 1.0,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildProgressCard(),
            const SizedBox(height: 24),
            const Text(
              'Available Rewards',
              style: TextStyle(
                color: Color(0xFFE6CEA1),
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 16),
            ...allRewards.map((reward) {
              final isUnlocked = unlockedTiers.contains(reward['tier']);
              return _buildRewardCard(reward, isUnlocked);
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard() {
    int nextTierMiles = 0;
    String nextTier = '';

    if (user.miles < 15000) {
      nextTier = 'Silver';
      nextTierMiles = 15000;
    } else if (user.miles < 30000) {
      nextTier = 'Gold';
      nextTierMiles = 30000;
    } else if (user.miles < 50000) {
      nextTier = 'Platinum';
      nextTierMiles = 50000;
    } else {
      nextTier = 'Platinum+';
      nextTierMiles = user.miles;
    }

    double progress = user.miles / nextTierMiles;
    int milesToGo = nextTierMiles - user.miles;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
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
            color: Colors.black.withOpacity(0.5),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Miles Progress',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${user.miles}',
                style: const TextStyle(
                  color: Color(0xFFE6CEA1),
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$milesToGo miles to $nextTier',
                style: const TextStyle(
                  color: Color(0xFFCCA770),
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: Colors.grey[800],
              color: const Color(0xFFAF7A38),
              minHeight: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardCard(Map<String, dynamic> reward, bool isUnlocked) {
    final String title = reward['title'];
    final int cost = reward['cost'];
    final String category = reward['category'];
    final String image = reward['image'];
    final String tier = reward['tier'];
    final bool hasEnoughMiles = user.miles >= cost;

    final bool canClaim = isUnlocked && hasEnoughMiles;

    return Opacity(
      opacity: isUnlocked ? 1.0 : 0.3,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.02),
              Colors.white.withOpacity(0.08),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: Colors.white12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white12,
              ),
              child: Image.network(image, fit: BoxFit.contain),
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
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$cost miles · $category',
                    style: const TextStyle(color: Color(0xFFBDC6C7)),
                  ),
                  if (!isUnlocked)
                    Text(
                      '🔒 Requires $tier Tier',
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: canClaim ? () => onClaimReward(cost) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    canClaim ? const Color(0xFFAF7A38) : Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              child: Text(
                isUnlocked ? 'Claim' : 'Locked',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getAllRewards() {
    return [
      {
        'title': 'Food coupon',
        'cost': 8000,
        'category': 'Food',
        'image': 'https://cdn-icons-png.flaticon.com/512/2921/2921822.png',
        'tier': 'Bronze',
      },
      {
        'title': 'Coffee voucher',
        'cost': 9000,
        'category': 'Food',
        'image': 'https://cdn-icons-png.flaticon.com/512/1046/1046784.png',
        'tier': 'Bronze',
      },
      {
        'title': 'Shopping discount',
        'cost': 10000,
        'category': 'Retail',
        'image': 'https://cdn-icons-png.flaticon.com/512/1040/1040982.png',
        'tier': 'Bronze',
      },
      {
        'title': 'Grab discount',
        'cost': 15000,
        'category': 'Transport',
        'image': 'https://cdn-icons-png.flaticon.com/512/2983/2983921.png',
        'tier': 'Silver',
      },
      {
        'title': 'Movie tickets',
        'cost': 18000,
        'category': 'Entertainment',
        'image': 'https://cdn-icons-png.flaticon.com/512/1261/1261153.png',
        'tier': 'Silver',
      },
      {
        'title': 'Gym membership (1 month)',
        'cost': 20000,
        'category': 'Health',
        'image': 'https://cdn-icons-png.flaticon.com/512/847/847969.png',
        'tier': 'Silver',
      },
      {
        'title': 'Cruise ticket (discounted)',
        'cost': 30000,
        'category': 'Travel',
        'image': 'https://cdn-icons-png.flaticon.com/512/3050/3050525.png',
        'tier': 'Gold',
      },
      {
        'title': 'Theme park entry',
        'cost': 32000,
        'category': 'Entertainment',
        'image': 'https://cdn-icons-png.flaticon.com/512/2838/2838912.png',
        'tier': 'Gold',
      },
      {
        'title': 'Luxury dining voucher',
        'cost': 35000,
        'category': 'Food',
        'image': 'https://cdn-icons-png.flaticon.com/512/3075/3075977.png',
        'tier': 'Gold',
      },
      {
        'title': 'Flight to any country',
        'cost': 50000,
        'category': 'Flight',
        'image': 'https://cdn-icons-png.flaticon.com/512/3062/3062634.png',
        'tier': 'Platinum',
      },
      {
        'title': 'Lounge membership (1 year)',
        'cost': 52000,
        'category': 'Flight',
        'image': 'https://cdn-icons-png.flaticon.com/512/3558/3558872.png',
        'tier': 'Platinum',
      },
      {
        'title': 'Private jet experience',
        'cost': 60000,
        'category': 'Luxury',
        'image': 'https://cdn-icons-png.flaticon.com/512/1046/1046772.png',
        'tier': 'Platinum',
      },
    ];
  }

  List<String> _getUnlockedTiers(String currentTier) {
    switch (currentTier) {
      case 'Platinum':
        return ['Bronze', 'Silver', 'Gold', 'Platinum'];
      case 'Gold':
        return ['Bronze', 'Silver', 'Gold'];
      case 'Silver':
        return ['Bronze', 'Silver'];
      default:
        return ['Bronze'];
    }
  }
}
