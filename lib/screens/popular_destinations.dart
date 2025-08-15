import 'dart:ui';
import 'package:flutter/material.dart';

class PopularDestinationsPage extends StatelessWidget {
  const PopularDestinationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> destinations = [
      {
        'city': 'Paris',
        'country': 'France',
        'image':
            'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=800',
        'price': '899',
      },
      {
        'city': 'Tokyo',
        'country': 'Japan',
        'image':
            'https://images.unsplash.com/photo-1549693578-d683be217e58?w=800',
        'price': '899',
      },
      {
        'city': 'Bali',
        'country': 'Indonesia',
        'image':
            'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800',
        'price': '749',
      },
      {
        'city': 'New York',
        'country': 'USA',
        'image':
            'https://images.unsplash.com/photo-1534447677768-be436bb09401?w=800',
        'price': '999',
      },
      {
        'city': 'Singapore',
        'country': 'Singapore',
        'image':
            'https://images.unsplash.com/photo-1505765050516-f72dcac9c60b?w=800',
        'price': '799',
      },
      {
        'city': 'London',
        'country': 'United Kingdom',
        'image':
            'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=800',
        'price': '899',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF1F2228),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F2228),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Popular Destinations",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 0.7,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Explore our most popular destinations and\nfind your next adventure",
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: destinations.length,
                itemBuilder: (context, index) {
                  final dest = destinations[index];
                  return _destinationCard(dest);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _destinationCard(Map<String, String> dest) {
    return GestureDetector(
      onTap: () {}, // Add navigation or action
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image
            Image.network(dest['image']!, fit: BoxFit.cover),
            // Dark Glassmorphic Overlay
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.amber.withOpacity(0.4),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
              ),
            ),
            // Gradient Overlay for depth
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
            ),
            // Text Info
            Positioned(
              left: 16,
              bottom: 48,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dest['city']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      shadows: [
                        Shadow(
                          color: Colors.amberAccent,
                          blurRadius: 6,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    dest['country']!,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 16,
              bottom: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orangeAccent.withOpacity(0.6),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  "from \$${dest['price']}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            // Neon Glow Accent Circle
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.amberAccent.withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amberAccent.withOpacity(0.7),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
