import 'package:flutter/material.dart';
import 'package:skymiles_app/Profile/profile.dart';
import 'package:skymiles_app/Rewards/rewards_page.dart';
import 'package:skymiles_app/screens/booking_tab.dart';
import 'package:skymiles_app/flights/flight_search.dart';
import 'package:skymiles_app/screens/popular_destinations.dart';

// User data model with mutable miles
class UserData {
  final String name;
  int miles; // no longer final
  final String email; // Add this

  UserData({required this.name, required this.email, this.miles = 0});

  String get tier {
    if (miles >= 50000) return 'Platinum';
    if (miles >= 30000) return 'Gold';
    if (miles >= 15000) return 'Silver';
    return 'Bronze';
  }

  List<String> get rewards {
    switch (tier) {
      case 'Platinum':
        return ['Flight to any country'];
      case 'Gold':
        return ['Cruise ticket (discounted)'];
      case 'Silver':
        return ['Grab discount', 'Movie tickets'];
      default:
        return ['Food coupon'];
    }
  }
}

class HomePage extends StatefulWidget {
  final UserData user;
  final int initialTabIndex;

  const HomePage({super.key, required this.user, this.initialTabIndex = 0});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;
  late int _currentIndex;

  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;

  late UserData user;

  @override
  void initState() {
    super.initState();

    _currentIndex = widget.initialTabIndex;
    user = widget.user;

    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeInAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _animationController.forward();
  }

  void _onBookingComplete(int milesEarned) {
    setState(() {
      user.miles += milesEarned;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return buildMainContent();
      case 1:
        return SearchScreen(user: user);
      case 2:
        return BookingPage(onBookingComplete: _onBookingComplete);
      case 3:
        return RewardsPage(
          user: user,
          onClaimReward: (int cost) {
            setState(() {
              if (user.miles >= cost) {
                user.miles -= cost;
              }
            });
          },
        );
      case 4:
        return ProfilePage(
          user: user,
          onLogout: () {
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil('/login', (route) => false);
          },
        );
      default:
        return buildMainContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F2228),
      body: _getPage(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF2A2E35),
        selectedItemColor: const Color(0xFFAF7A38),
        unselectedItemColor: const Color(0xFFBDC6C7),
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        elevation: 12,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_online),
            label: 'Booking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: 'Rewards',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget buildMainContent() {
    return Stack(
      children: [
        Positioned.fill(
          top: _scrollOffset * 0.2,
          child: const DiagonalBackground(),
        ),
        SafeArea(
          child: FadeTransition(
            opacity: _fadeInAnimation,
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 24,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.7),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  border: Border.all(
                    color: const Color(0xFFAF7A38).withOpacity(0.7),
                    width: 1.5,
                  ),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildHeader(),
                    const SizedBox(height: 40),
                    buildRecommendationTitle(),
                    const SizedBox(height: 24),
                    buildRecommendationCard(),
                    const SizedBox(height: 40),
                    buildPromotionTitle(),
                    const SizedBox(height: 24),
                    buildPromotionCard(),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, ${user.name}',
              style: const TextStyle(
                color: Color(0xFFE6CEA1),
                fontSize: 28,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.1,
                fontFamily: 'Georgia',
                shadows: [
                  Shadow(
                    blurRadius: 4,
                    color: Color(0xFFAF7A38),
                    offset: Offset(1, 1),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Where to next?',
              style: TextStyle(
                color: Color(0xFFCCA770),
                fontSize: 18,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
                letterSpacing: 0.7,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'Available Miles',
              style: TextStyle(
                color: Color(0xFFCCA770),
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              '${user.miles}',
              style: const TextStyle(
                color: Color(0xFFAF7A38),
                fontWeight: FontWeight.bold,
                fontSize: 20,
                letterSpacing: 1.2,
              ),
            ),
            TextButton(
              onPressed: () => _showMilesDialog(context, user),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 30),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'View All Miles',
                style: TextStyle(
                  color: Color(0xFFE6CEA1),
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildRecommendationTitle() {
    return const Text(
      'Recommendation',
      style: TextStyle(
        color: Color(0xFFE6CEA1),
        fontSize: 22,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.1,
      ),
    );
  }

  Widget buildRecommendationCard() {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const PopularDestinationsPage(),
        ),
      );
    },
    child: Container(
      height: 240,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        image: const DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=80',
          ),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Color(0xAA000000), BlendMode.darken),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.85),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
        border: Border.all(
          color: const Color(0xFFE6CEA1).withOpacity(0.6),
          width: 1.2,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 24,
            left: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.75),
                    Colors.black.withOpacity(0.4),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Row(
                children: [
                  Icon(Icons.star, size: 18, color: Color(0xFFFFD700)),
                  SizedBox(width: 6),
                  Text(
                    '4.9',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.65),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black87,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'Sydney Opera House',
                      style: TextStyle(
                        color: Color(0xFFE6CEA1),
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Sydney, Australia',
                      style: TextStyle(
                        color: Color(0xFFCCA770),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget buildPromotionTitle() {
    return const Text(
      'Promotion & Discounts',
      style: TextStyle(
        color: Color(0xFFE6CEA1),
        fontSize: 22,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.1,
      ),
    );
  }

  Widget buildPromotionCard() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        image: const DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1494526585095-c41746248156?auto=format&fit=crop&w=800&q=80',
          ),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Color(0xAA000000), BlendMode.darken),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.85),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
        border: Border.all(
          color: const Color(0xFFE6CEA1).withOpacity(0.6),
          width: 1.2,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.65),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black87,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'Special Summer Sale!',
                      style: TextStyle(
                        color: Color(0xFFE6CEA1),
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Up to 40% off on selected flights',
                      style: TextStyle(
                        color: Color(0xFFCCA770),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMilesDialog(BuildContext context, UserData user) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: const Color(0xFF3A3F47),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: const BorderSide(color: Color(0xFFAF7A38), width: 2),
            ),
            title: Text(
              '${user.tier} Member',
              style: const TextStyle(
                color: Color(0xFFE6CEA1),
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.7,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  user.rewards
                      .map(
                        (reward) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Text(
                            '🎁 $reward',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                      .toList(),
            ),
            actions: [
              TextButton(
                child: const Text(
                  'Close',
                  style: TextStyle(
                    color: Color(0xFFAF7A38),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
    );
  }
}

// Diagonal background painter classes
class DiagonalBackground extends StatelessWidget {
  const DiagonalBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: DiagonalPainter());
  }
}

class DiagonalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintLeft = Paint()..color = const Color(0xFF8C642B);
    final paintRight = Paint()..color = const Color(0xFF1F2228);

    final pathLeft =
        Path()
          ..lineTo(0, size.height)
          ..lineTo(size.width, size.height * 0.65)
          ..lineTo(size.width, 0)
          ..close();

    final pathRight =
        Path()
          ..moveTo(0, size.height)
          ..lineTo(size.width, size.height)
          ..lineTo(size.width, size.height * 0.65)
          ..lineTo(0, size.height * 0.95)
          ..close();

    canvas.drawPath(pathLeft, paintLeft);
    canvas.drawPath(pathRight, paintRight);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
