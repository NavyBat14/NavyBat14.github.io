import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skymiles_app/user_data.dart'; // AppUser/UserData

class ReturnBookingFlightsPage extends StatelessWidget {
  final String from;
  final String to;
  final DateTime returnDate;
  final int passengers;
  final List<Map<String, dynamic>> flights;
  final Function(Map<String, dynamic>) onBookReturn;

  ReturnBookingFlightsPage({
    Key? key,
    required this.from,
    required this.to,
    required this.returnDate,
    required this.passengers,
    required this.flights,
    required this.onBookReturn,
  }) : super(key: key);

  String formatDateTime(DateTime dt) =>
      DateFormat('yyyy-MM-dd HH:mm').format(dt);

  final Color primary = const Color(0xFFFFD700); // neon gold accent
  final Color secondary = const Color(0xFFCCA770);
  final Color backgroundDark = const Color(0xFF0A0A0F);
  final Color cardBackground = const Color(0xFF1E1E2A);
  final Color textPrimary = const Color(0xFFFFFFFF);
  final Color textSecondary = const Color(0xFFBDC6C7);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Select Return Flight',
          style: TextStyle(
            color: primary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        itemCount: flights.length,
        itemBuilder: (context, index) {
          final flight = flights[index];
          return _buildFlightCard(flight, context);
        },
      ),
    );
  }

  Widget _buildFlightCard(Map<String, dynamic> flight, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF1E1E2A), Color(0xFF0A0A0F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.amber.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: primary.withOpacity(0.3), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Flight Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${flight['airline']} (${flight['flightNumber']})',
                  style: TextStyle(
                    color: primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  '\$${flight['price'].toStringAsFixed(2)}',
                  style: TextStyle(
                    color: secondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Flight Timings
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTimeInfo('Departure', flight['departure']),
                Icon(Icons.flight_takeoff, color: primary, size: 28),
                _buildTimeInfo('Arrival', flight['arrival']),
              ],
            ),
            const SizedBox(height: 20),
            // Book Button
            Center(
              child: GestureDetector(
                onTap: () => onBookReturn(flight),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 36,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                      colors: [
                        primary.withOpacity(0.9),
                        primary.withOpacity(0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: primary.withOpacity(0.5),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Text(
                    'Book Return',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeInfo(String label, DateTime dt) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: textSecondary, fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          formatDateTime(dt),
          style: TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
