import 'dart:math';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:skymiles_app/booking/booking_step3.dart';
import 'package:skymiles_app/screens/home_page.dart';

class ClassSelectionPage extends StatefulWidget {
  final Map<String, dynamic> flight; // flight object from API
  final int passengers;
  final UserData user;

  const ClassSelectionPage({
    super.key,
    required this.flight,
    required this.passengers,
    required this.user,
  });

  @override
  State<ClassSelectionPage> createState() => _ClassSelectionPageState();
}

class _ClassSelectionPageState extends State<ClassSelectionPage> {
  final PageController _controller = PageController(viewportFraction: 0.85);

  final List<Map<String, dynamic>> _classes = [
    {
      'title': 'Economy',
      'subtitle': 'Flex',
      'multiplier': 1.0,
      'features': [
        'Earn 400 credit',
        '1 free change',
        'Cancel within 24 hours',
        '1 Checked bag - 23kg',
        '1 Hand bag - 7kg',
        'No seat selection',
      ],
      'image':
          'https://images.unsplash.com/photo-1556388158-158ea5ccacbd?auto=format&fit=crop&w=800&q=80',
    },
    {
      'title': 'Premium Economy',
      'subtitle': 'Flex+',
      'multiplier': 1.5,
      'features': [
        'Earn 800 credit',
        '2 free changes',
        'Free cancellation',
        '2 Checked bags - 23kg',
        'Priority boarding',
        'Standard seat selection',
      ],
      'image':
          'https://images.unsplash.com/photo-1601314183715-b93f94a27b19?auto=format&fit=crop&w=800&q=80',
    },
    {
      'title': 'Business Class',
      'subtitle': 'Smart',
      'multiplier': 2.5,
      'features': [
        'Earn 1200 credit',
        'Unlimited changes',
        'Full refund',
        '3 Checked bags - 32kg',
        'Lounge access',
        'Recliner seat & meals',
      ],
      'image':
          'https://images.unsplash.com/photo-1549921296-3a73f4b63238?auto=format&fit=crop&w=800&q=80',
    },
    {
      'title': 'First Class',
      'subtitle': 'Elite',
      'multiplier': 4.0,
      'features': [
        'Earn 2000 credit',
        'Unlimited flexibility',
        'Private cabin',
        '4 Checked bags - 32kg',
        'Gourmet dining',
        'Personal concierge',
      ],
      'image':
          'https://images.unsplash.com/photo-1527090400539-b977951a97d8?auto=format&fit=crop&w=800&q=80',
    },
  ];

  double getCountryMultiplier(String country) {
    switch (country) {
      case 'SG':
        return 1.1;
      case 'US':
        return 1.0;
      case 'IN':
        return 0.8;
      case 'UK':
        return 1.2;
      default:
        return 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final flight = widget.flight;
    final double countryMultiplier = getCountryMultiplier(
      flight['userCountry'] ?? 'SG',
    );
    final int basePrice = (flight['price'] ?? 0).toInt();

    return Scaffold(
      backgroundColor: const Color(0xFF1E2128),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          '${flight['from']} → ${flight['to']}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 0.8,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: _classes.length,
              itemBuilder: (context, index) {
                final item = _classes[index];
                final double totalClassPrice =
                    basePrice * (item['multiplier'] as double);
                final int finalPrice =
                    (totalClassPrice * countryMultiplier).round();

                return AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    double value = 1.0;
                    if (_controller.hasClients &&
                        _controller.position.haveDimensions) {
                      value = _controller.page! - index;
                      value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
                    }
                    final double angle = (1 - value) * pi / 12;

                    return Transform(
                      transform:
                          Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateY(angle),
                      alignment: Alignment.center,
                      child: Opacity(
                        opacity: value,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 20,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.grey.shade900.withOpacity(0.8),
                                  Colors.grey.shade800.withOpacity(0.6),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 20,
                                  offset: const Offset(0, 12),
                                ),
                              ],
                              border: Border.all(
                                color: Colors.amberAccent.withOpacity(0.4),
                                width: 1.5,
                              ),
                            ),
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: 180,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.black.withOpacity(0.3),
                                              Colors.transparent,
                                            ],
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                          ),
                                        ),
                                        child: Image.network(
                                          item['image'],
                                          height: 180,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return const Center(
                                              child: Icon(
                                                Icons.airplane_ticket,
                                                size: 60,
                                                color: Colors.grey,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 10,
                                        right: 10,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(
                                              0.7,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: Text(
                                            item['title'],
                                            style: const TextStyle(
                                              color: Colors.amberAccent,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      item['title'],
                                      style: const TextStyle(
                                        fontSize: 24,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    Text(
                                      'USD $finalPrice',
                                      style: const TextStyle(
                                        fontSize: 22,
                                        color: Colors.amberAccent,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  item['subtitle'],
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ...List<Widget>.from(
                                  item['features'].map(
                                    (feature) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4,
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.check_circle,
                                            color: Colors.amberAccent,
                                            size: 18,
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              feature,
                                              style: const TextStyle(
                                                color: Colors.white70,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => SeatSelectionPage(
                                                flight: flight,
                                                selectedClass: item['title'],
                                                finalPrice: finalPrice,
                                                passengers: widget.passengers,
                                                user: widget.user,
                                              ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Colors.amberAccent.shade400,
                                      foregroundColor: Colors.black87,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 60,
                                        vertical: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      elevation: 8,
                                      shadowColor: Colors.amberAccent
                                          .withOpacity(0.4),
                                    ),
                                    child: const Text(
                                      'Select',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: SmoothPageIndicator(
              controller: _controller,
              count: _classes.length,
              effect: ExpandingDotsEffect(
                dotColor: Colors.grey.shade700,
                activeDotColor: Colors.amberAccent,
                dotHeight: 12,
                dotWidth: 12,
                spacing: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
