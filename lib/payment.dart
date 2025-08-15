import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:skymiles_app/booking_success.dart';
import 'package:skymiles_app/booking.dart';

class PaymentMethodPage extends StatefulWidget {
  final Booking booking;
  final void Function(int) onBookingComplete;

  const PaymentMethodPage({
    super.key,
    required this.booking,
    required this.onBookingComplete,
  });

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

// Reward points calculation based on travel class
int _calculateRewards(String? travelClass) {
  switch (travelClass) {
    case 'Economy':
      return 400;
    case 'Premium Economy':
      return 800;
    case 'Business Class':
      return 1200;
    case 'First Class':
      return 2000;
    default:
      return 0;
  }
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  String? _selectedPayment;

  @override
  Widget build(BuildContext context) {
    final isButtonEnabled = _selectedPayment != null;

    return Scaffold(
      backgroundColor: const Color(0xFF1F2228),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Payment Method',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Illustrative header
            Center(
              child: Container(
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFAF7A38), Color(0xFFFFD700)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.6),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(Icons.payment, size: 80, color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Choose Payment Method',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),

            // Payment options with glassmorphism
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildPaymentOption('Visa **** 7332'),
                  _buildPaymentOption('Master Card **** 7327'),
                  _buildPaymentOption('Bank Transfer'),
                  _buildPaymentOption('E-Wallet'),
                ],
              ),
            ),

            // Continue button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    isButtonEnabled
                        ? () {
                          final miles = _calculateRewards(
                            widget.booking.travelClass,
                          );
                          widget.onBookingComplete(miles);

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => BookingSuccessPage(
                                    booking: widget.booking,
                                    rewardsEarned: miles,
                                    onBookingComplete: widget.onBookingComplete,
                                  ),
                            ),
                          );
                        }
                        : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isButtonEnabled
                          ? const Color(0xFFAF7A38)
                          : Colors.grey.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 12,
                  shadowColor: Colors.black.withOpacity(0.6),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String title) {
    final isSelected = _selectedPayment == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPayment = title;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.35),
                borderRadius: BorderRadius.circular(20),
                border:
                    isSelected
                        ? Border.all(color: const Color(0xFFFFD700), width: 2)
                        : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.6),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.credit_card, color: Colors.white, size: 28),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(
                    isSelected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: Colors.amber,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
