import 'package:flutter/material.dart';
import 'package:skymiles_app/booking/booking_summary.dart';
import 'package:skymiles_app/screens/home_page.dart';
import 'dart:ui';

class ExtraServicesPage extends StatefulWidget {
  final Map<String, dynamic> flight;
  final String selectedSeat;
  final String selectedClass;
  final int price;
  final int passengers;
  final UserData user;
  final void Function(int) onBookingComplete;

  const ExtraServicesPage({
    super.key,
    required this.flight,
    required this.selectedSeat,
    required this.selectedClass,
    required this.price,
    required this.passengers,
    required this.user,
    required this.onBookingComplete,
  });

  @override
  State<ExtraServicesPage> createState() => _ExtraServicesPageState();
}

class _ExtraServicesPageState extends State<ExtraServicesPage> {
  int selectedBaggage = 0;
  bool loungeAccess = false;
  bool wifiOnBoard = false;
  bool mealOnBoard = false;

  final Color darkBg = const Color(0xFF121418);
  final Color cardBg = const Color(0xFF1F232B);
  final Color golden = const Color(0xFFFFD700);
  final Color textPrimary = Colors.white;
  final Color textSecondary = const Color(0xFFBDC6C7);

  int get totalExtras {
    int total = 0;
    total += selectedBaggage;
    if (loungeAccess) total += 23;
    if (wifiOnBoard) total += 15;
    if (mealOnBoard) total += 18;
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final totalPrice = widget.price + totalExtras;
    final flight = widget.flight;

    return Scaffold(
      backgroundColor: darkBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Booking Process",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStepsProgress(),
            const SizedBox(height: 24),
            _buildFlightInfo(flight),
            _buildBaggageOption(),
            const SizedBox(height: 16),
            _buildSwitchCard(
              icon: Icons.airline_seat_recline_extra,
              title: "Luxury Lounge Access",
              subtitle: "Relax in style before flight",
              price: "23 USD",
              value: loungeAccess,
              onChanged: (val) => setState(() => loungeAccess = val),
            ),
            _buildSwitchCard(
              icon: Icons.wifi,
              title: "WiFi on Board",
              subtitle: "Stay connected during flight",
              price: "15 USD",
              value: wifiOnBoard,
              onChanged: (val) => setState(() => wifiOnBoard = val),
            ),
            _buildSwitchCard(
              icon: Icons.restaurant,
              title: "Premium Meals",
              subtitle: "Gourmet cuisine on board",
              price: "18 USD",
              value: mealOnBoard,
              onChanged: (val) => setState(() => mealOnBoard = val),
            ),
            const SizedBox(height: 24),
            Text(
              "Total: \$$totalPrice",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: golden,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 8,
                  shadowColor: golden.withOpacity(0.5),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => BookingSummaryPage(
                            flight: flight,
                            selectedSeat: widget.selectedSeat,
                            flightClass: widget.selectedClass,
                            basePrice: widget.price,
                            extraCost: totalExtras,
                            passengers: widget.passengers,
                            user: widget.user,
                            onBookingComplete: widget.onBookingComplete,
                          ),
                    ),
                  );
                },
                child: const Text(
                  "Next",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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

  Widget _buildStepsProgress() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        _StepCircle(step: "1", label: "Traveler\nDetails", isDone: true),
        Icon(Icons.arrow_forward_ios, size: 12, color: Colors.white),
        _StepCircle(step: "2", label: "Seating\nPlan", isDone: true),
        Icon(Icons.arrow_forward_ios, size: 12, color: Colors.white),
        _StepCircle(step: "3", label: "Select\nSeat", isDone: true),
        Icon(Icons.arrow_forward_ios, size: 12, color: Colors.white),
        _StepCircle(step: "4", label: "Extra\nServices", isDone: false),
        Icon(Icons.arrow_forward_ios, size: 12, color: Colors.white),
        _StepCircle(step: "5", label: "Booking\nSummary", isDone: false),
      ],
    );
  }

  Widget _buildFlightInfo(Map<String, dynamic> flight) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "From: ${flight['from']} → ${flight['to']}",
            style: TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
          ),
          Text(
            "Class: ${widget.selectedClass}",
            style: TextStyle(color: textSecondary),
          ),
          Text(
            "Seat: ${widget.selectedSeat}",
            style: TextStyle(color: textSecondary),
          ),
          Text(
            "Base Price: \$${widget.price}",
            style: TextStyle(color: textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildBaggageOption() {
    return _buildGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Baggage Options",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:
                [10, 20, 30].map((kg) {
                  int price = kg * 1;
                  bool selected = selectedBaggage == kg;
                  return GestureDetector(
                    onTap: () => setState(() => selectedBaggage = kg),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient:
                            selected
                                ? LinearGradient(
                                  colors: [
                                    golden.withOpacity(0.8),
                                    Colors.orangeAccent,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                                : null,
                        color: selected ? null : cardBg.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          if (selected)
                            BoxShadow(
                              color: golden.withOpacity(0.6),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.luggage, color: Colors.white),
                          const SizedBox(height: 6),
                          Text(
                            "+$kg Kg\n$price USD",
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String price,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return _buildGlassCard(
      child: Row(
        children: [
          Icon(icon, color: golden, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(subtitle, style: TextStyle(color: textSecondary)),
              ],
            ),
          ),
          Column(
            children: [
              Text(price, style: const TextStyle(color: Colors.white)),
              Switch(
                value: value,
                activeColor: golden,
                onChanged: onChanged,
                inactiveTrackColor: Colors.grey.shade700,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGlassCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: child,
        ),
      ),
    );
  }
}

class _StepCircle extends StatelessWidget {
  final String step;
  final String label;
  final bool isDone;

  const _StepCircle({
    required this.step,
    required this.label,
    required this.isDone,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor:
              isDone ? const Color(0xFFFFD700) : const Color(0xFF3A3F47),
          child: Text(
            step,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 10),
        ),
      ],
    );
  }
}
