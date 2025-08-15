import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:skymiles_app/payment.dart';
import 'package:skymiles_app/booking.dart';
import 'package:skymiles_app/screens/home_page.dart';

class BookingSummaryPage extends StatelessWidget {
  final Map<String, dynamic> flight;
  final Map<String, dynamic>? returnFlight; // optional return
  final String flightClass;
  final String selectedSeat;
  final String? selectedReturnSeat;
  final int basePrice;
  final int? returnPrice; // optional return
  final int extraCost;
  final int passengers;
  final UserData user;
  final void Function(int) onBookingComplete;

  const BookingSummaryPage({
    super.key,
    required this.flight,
    this.returnFlight,
    required this.flightClass,
    required this.selectedSeat,
    this.selectedReturnSeat,
    required this.basePrice,
    this.returnPrice,
    required this.extraCost,
    required this.passengers,
    required this.user,
    required this.onBookingComplete,
  });

  int get totalPrice => basePrice + (returnPrice ?? 0) + extraCost;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121418),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Booking Summary',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset(
                'assets/plane_summary.png',
                fit: BoxFit.cover,
                height: 180,
                width: double.infinity,
              ),
            ),
            const SizedBox(height: 24),

            // Outbound flight
            _buildGlassCard(
              child: _buildFlightDetailCard(
                date: flight['departDate']?.toString() ?? '—',
                departTime: flight['departTime']?.toString() ?? '—',
                arriveTime: flight['arrivalTime']?.toString() ?? '—',
                from: flight['from']?.toString() ?? '—',
                to: flight['to']?.toString() ?? '—',
                flightNo: flight['flightNo']?.toString() ?? '—',
                classType: flightClass,
                seat: selectedSeat,
                isReturn: false,
              ),
            ),

            // Return flight (if exists)
            if (returnFlight != null && selectedReturnSeat != null)
              _buildGlassCard(
                child: _buildFlightDetailCard(
                  date: returnFlight!['departDate']?.toString() ?? '—',
                  departTime: returnFlight!['departTime']?.toString() ?? '—',
                  arriveTime: returnFlight!['arrivalTime']?.toString() ?? '—',
                  from: returnFlight!['from']?.toString() ?? '—',
                  to: returnFlight!['to']?.toString() ?? '—',
                  flightNo: returnFlight!['flightNo']?.toString() ?? '—',
                  classType: flightClass,
                  seat: selectedReturnSeat!,
                  isReturn: true,
                ),
              ),

            const SizedBox(height: 16),
            _buildGlassCard(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    Text(
                      'SGD $totalPrice',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final booking = Booking(
                    id: 'B001',
                    from: flight['from']?.toString() ?? '',
                    to:
                        returnFlight != null
                            ? returnFlight!['to']?.toString() ?? ''
                            : flight['to']?.toString() ?? '',
                    flightNumber: flight['flightNo']?.toString() ?? '',
                    travelClass: flightClass,
                    departure: DateTime.now(),
                    seat: selectedSeat,
                    passengerName: user.name,
                    price: totalPrice.toDouble(),
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => PaymentMethodPage(
                            booking: booking,
                            onBookingComplete: onBookingComplete,
                          ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  backgroundColor: const Color(0xFFFFD700),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 8,
                  shadowColor: const Color(0xFFFFD700).withOpacity(0.5),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlightDetailCard({
    required String date,
    required String departTime,
    required String arriveTime,
    required String from,
    required String to,
    required String flightNo,
    required String classType,
    required String seat,
    bool isReturn = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${isReturn ? 'Return Flight' : 'Departure Flight'} • $date',
          style: const TextStyle(color: Color(0xFFBDC6C7)),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  departTime,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$from • Seat: $seat',
                  style: const TextStyle(color: Color(0xFFBDC6C7)),
                ),
              ],
            ),
            const Icon(Icons.flight, color: Colors.white, size: 28),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  arriveTime,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(to, style: const TextStyle(color: Color(0xFFBDC6C7))),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(flightNo, style: const TextStyle(color: Colors.white)),
            Text(classType, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ],
    );
  }

  Widget _buildGlassCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xFF3A3F47).withOpacity(0.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Padding(padding: const EdgeInsets.all(16), child: child),
        ),
      ),
    );
  }
}
