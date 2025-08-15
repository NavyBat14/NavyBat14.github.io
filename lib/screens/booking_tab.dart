import 'package:flutter/material.dart';
import 'package:skymiles_app/booking.dart';
import 'package:skymiles_app/booking_success.dart';

class BookingPage extends StatelessWidget {
  final void Function(int) onBookingComplete;

  const BookingPage({super.key, required this.onBookingComplete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F2228),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your Bookings',
                style: TextStyle(
                  color: Color(0xFFE6CEA1),
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 24),
              _buildBookingCard(context),
              const Spacer(),
              Center(child: _buildConfirmButton(context)),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookingCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.02),
            Colors.white.withOpacity(0.06),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'SFO → MIL',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Flight: LY2651  |  Class: Business',
            style: TextStyle(color: Color(0xFFCCA770), fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            'Departure: 14 Jan, 08:05',
            style: TextStyle(color: Color(0xFFBDC6C7), fontSize: 15),
          ),
          SizedBox(height: 4),
          Text(
            'Seat: 14C',
            style: TextStyle(color: Color(0xFFBDC6C7), fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        final booking = Booking(
          id: 'B001',
          from: 'SFO',
          to: 'MIL',
          flightNumber: 'LY2651',
          travelClass: 'Business',
          departure: DateTime(2025, 1, 14, 8, 5),
          seat: '14C',
          passengerName: 'John Doe',
          price: 1200.0,
        );

        const milesEarned = 1500;

        onBookingComplete(milesEarned);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => BookingSuccessPage(
                  booking: booking,
                  rewardsEarned: milesEarned,
                  onBookingComplete: onBookingComplete,
                ),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFAF7A38),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 70),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 12,
        shadowColor: const Color(0xFFAF7A38).withOpacity(0.6),
      ),
      child: const Text(
        'Confirm Booking',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 16,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
