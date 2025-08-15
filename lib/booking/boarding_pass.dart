import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:skymiles_app/booking.dart';

class BoardingPassPage extends StatelessWidget {
  final Booking booking;

  const BoardingPassPage({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final fromCode = _extractIata(booking.from ?? '');
    final toCode = _extractIata(booking.to ?? '');
    final fromCity = _extractCity(booking.from ?? '');
    final toCity = _extractCity(booking.to ?? '');

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),
              const Text(
                'Boarding Pass',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 24),
              _buildGlassCard(context, fromCode, toCode, fromCity, toCity),
              const Spacer(),
              _buildGoldButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassCard(
    BuildContext context,
    String fromCode,
    String toCode,
    String fromCity,
    String toCity,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFFFD700).withOpacity(0.5),
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.05),
                  Colors.white.withOpacity(0.02),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildAirportCode(fromCode, fromCity),
                    Column(
                      children: const [
                        Icon(
                          Icons.flight_takeoff,
                          color: Color(0xFFFFD700),
                          size: 28,
                        ),
                        SizedBox(height: 4),
                        Text("—", style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                    _buildAirportCode(toCode, toCity),
                  ],
                ),
                const Divider(color: Colors.white24, height: 30),
                Text(
                  (booking.passengerName ?? '').toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                _detailRow(
                  "Flight",
                  booking.flightNumber ?? '—',
                  "Class",
                  booking.travelClass ?? '—',
                ),
                _detailRow("Seat", booking.seat ?? '—', "Gate", 'A12'),
                _detailRow(
                  "Depart",
                  booking.departure != null
                      ? _formatDepart(booking.departure!)
                      : '—',
                  "Terminal",
                  '3',
                ),
                const SizedBox(height: 20),
                Image.network(
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/f/fd/Barcode.svg/320px-Barcode.svg.png',
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGoldButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFD700), Color(0xFFC9A14D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFD700).withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            // TODO: implement download
          },
          child: const Text(
            'Download Ticket',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAirportCode(String code, String city) {
    return Column(
      children: [
        Text(
          code,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(city, style: const TextStyle(fontSize: 13, color: Colors.white70)),
      ],
    );
  }

  Widget _detailRow(String l1, String v1, String l2, String v2) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _detailItem(l1, v1),
          const SizedBox(width: 16),
          _detailItem(l2, v2),
        ],
      ),
    );
  }

  Widget _detailItem(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDepart(DateTime dt) {
    final mm = _monthName(dt.month);
    final hh = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '${dt.day} $mm $hh:$min';
  }

  String _monthName(int m) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[m];
  }

  String _extractIata(String s) {
    final match = RegExp(r'\(([A-Z]{3})\)').firstMatch(s);
    if (match != null) return match.group(1)!;
    final letters = s.replaceAll(RegExp('[^A-Za-z]'), '');
    return (letters.length >= 3 ? letters.substring(0, 3) : letters)
        .toUpperCase();
  }

  String _extractCity(String s) {
    return s.replaceAll(RegExp(r'\([^)]+\)'), '').trim();
  }
}
