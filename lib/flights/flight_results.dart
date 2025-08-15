import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skymiles_app/booking/booking_step1.dart';
import 'package:skymiles_app/screens/home_page.dart'; // For UserData

class FlightResultsScreen extends StatelessWidget {
  final String from;
  final String to;
  final DateTime departureDate;
  final int passengers;
  final List<Map<String, dynamic>> flights;
  final UserData user;

  const FlightResultsScreen({
    Key? key,
    required this.from,
    required this.to,
    required this.departureDate,
    required this.passengers,
    required this.flights,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Flight Results',
          style: TextStyle(
            color: Color(0xFFFFD700),
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 0.8,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: flights.length,
        itemBuilder: (context, index) {
          final flight = flights[index];
          return _buildFlightCard(context, flight);
        },
      ),
    );
  }

  Widget _buildFlightCard(BuildContext context, Map<String, dynamic> flight) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF1E1E2A), Color(0xFF121212)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.3)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${flight['airline']} - ${flight['flightNumber']}',
                  style: const TextStyle(
                    color: Color(0xFFFFD700),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'From: ${flight['from']} → To: ${flight['to']}',
                  style: const TextStyle(color: Colors.white70),
                ),
                Text(
                  'Departure: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(flight['departure']))} - Arrival: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(flight['arrival']))}',
                  style: const TextStyle(color: Colors.white70),
                ),
                Text(
                  'Price: \$${flight['price']}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFD700),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 14,
                      ),
                      elevation: 6,
                      shadowColor: const Color(0xFFFFD700).withOpacity(0.5),
                    ),
                    child: const Text(
                      'Book Now',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => BookingStep1Page(
                                flight: flight,
                                passengers: passengers,
                                user: user,
                              ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
