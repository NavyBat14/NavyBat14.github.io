import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skymiles_app/booking/booking_step1.dart';
import 'package:skymiles_app/screens/home_page.dart'; // UserData
import 'package:skymiles_app/flights/return_flights.dart'; // ReturnBookingFlightsPage

class FlightResultsScreen extends StatelessWidget {
  final String from;
  final String to;
  final DateTime departureDate;
  final int passengers;
  final List<Map<String, dynamic>> flights;
  final UserData user;
  final DateTime? returnDate; // optional

  const FlightResultsScreen({
    Key? key,
    required this.from,
    required this.to,
    required this.departureDate,
    required this.passengers,
    required this.flights,
    required this.user,
    this.returnDate,
  }) : super(key: key);

  String _formatDateTime(dynamic dt) {
    if (dt is DateTime) return DateFormat('yyyy-MM-dd HH:mm').format(dt);
    try {
      return DateFormat(
        'yyyy-MM-dd HH:mm',
      ).format(DateTime.parse(dt.toString()));
    } catch (_) {
      return dt.toString();
    }
  }

  double _parsePrice(dynamic price) {
    if (price == null) return 0.0;
    if (price is num) return price.toDouble();
    if (price is String) return double.tryParse(price) ?? 0.0;
    return 0.0;
  }

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
      body:
          flights.isEmpty
              ? const Center(
                child: Text(
                  'No flights available',
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                ),
              )
              : ListView.builder(
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
    final price = _parsePrice(flight['price']); // safe conversion

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
                const SizedBox(height: 4),
                Text(
                  'Departure: ${_formatDateTime(flight['departure'])} - Arrival: ${_formatDateTime(flight['arrival'])}',
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 4),
                Text(
                  'Price: \$${price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      if (returnDate != null) {
                        // Go to ReturnBookingFlightsPage if returnDate exists
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => ReturnBookingFlightsPage(
                                  from: flight['to'],
                                  to: flight['from'],
                                  returnDate: returnDate!,
                                  passengers: passengers,
                                  flights:
                                      flights, // ideally fetch return flights
                                  onBookReturn: (selectedReturnFlight) {
                                    // After selecting return flight, proceed to booking
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => BookingStep1Page(
                                              flight: flight,
                                              passengers: passengers,
                                              user: user,
                                              returnFlight:
                                                  selectedReturnFlight,
                                            ),
                                      ),
                                    );
                                  },
                                ),
                          ),
                        );
                      } else {
                        // One-way flight booking
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
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD700),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.yellow.withOpacity(0.6),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Text(
                        'Book Now',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
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
  }
}
