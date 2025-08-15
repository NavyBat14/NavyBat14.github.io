import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'profile_setup_page.dart';

class OtpVerificationPage extends StatefulWidget {
  final String email;

  const OtpVerificationPage({super.key, required this.email});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage>
    with SingleTickerProviderStateMixin {
  final codeController = TextEditingController();
  late AnimationController _gradientController;

  @override
  void initState() {
    super.initState();
    _generateAndSendOtp();

    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _gradientController.dispose();
    codeController.dispose();
    super.dispose();
  }

  Future<void> _generateAndSendOtp() async {
    final otp = (Random().nextInt(900000) + 100000).toString();
    final firestore = FirebaseFirestore.instance;

    await firestore.collection('emailOtps').doc(widget.email).set({
      'otp': otp,
      'timestamp': DateTime.now(),
    });

    // Simulated sending
    // ignore: avoid_print
    print("OTP sent to ${widget.email}: $otp");
  }

  Future<void> verifyOtp() async {
    final enteredCode = codeController.text.trim();
    final doc =
        await FirebaseFirestore.instance
            .collection('emailOtps')
            .doc(widget.email)
            .get();

    if (!doc.exists) {
      showError("No OTP found for this email.");
      return;
    }

    final data = doc.data()!;
    final storedOtp = data['otp'];
    final timestamp = (data['timestamp'] as Timestamp).toDate();
    final isExpired = DateTime.now().difference(timestamp).inMinutes > 5;

    if (isExpired) {
      showError("OTP expired. Please request a new one.");
      return;
    }

    if (enteredCode != storedOtp) {
      showError("Incorrect OTP.");
      return;
    }

    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (_, __, ___) => const ProfileSetupPage(),
        transitionsBuilder:
            (_, animation, __, child) =>
                FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.redAccent.shade200,
        content: Text(message, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _gradientController,
      builder: (context, child) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors:
                    const [
                      Color(0xFF1B1F24),
                      Color(0xFFAF7A38),
                      Color(0xFF1B1F24),
                    ].map((c) => c.withOpacity(0.3)).toList(),
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [
                  0.2,
                  0.5 + (0.1 * sin(_gradientController.value * 2 * pi)),
                  1.0,
                ],
              ),
            ),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(
                    sigmaX: 12,
                    sigmaY: 12,
                  ), // ✅ fixed
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.shield_outlined,
                          size: 80,
                          color: Color(0xFFAF7A38),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Verify Your Email",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "We've sent a 6-digit code to ${widget.email}",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.8),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                        _buildOtpField(),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: verifyOtp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFAF7A38),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 10,
                            shadowColor: const Color(
                              0xFFAF7A38,
                            ).withOpacity(0.6),
                          ),
                          child: const Text(
                            "Verify",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOtpField() {
    return TextField(
      controller: codeController,
      maxLength: 6,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 24,
        letterSpacing: 8,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        counterText: "",
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: const Color(0xFFAF7A38).withOpacity(0.6),
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFAF7A38), width: 2),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}
