import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skymiles_app/authentication/otp_verification_page.dart';

class StyledSignupPage extends StatefulWidget {
  const StyledSignupPage({super.key});

  @override
  State<StyledSignupPage> createState() => _StyledSignupPageState();
}

class _StyledSignupPageState extends State<StyledSignupPage>
    with SingleTickerProviderStateMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreedToTerms = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> generateAndSendOtp(String email) async {
    final otp = (Random().nextInt(900000) + 100000).toString();
    final firestore = FirebaseFirestore.instance;

    await firestore.collection('emailOtps').doc(email).set({
      'otp': otp,
      'timestamp': DateTime.now(),
    });

    print("OTP sent to $email: $otp");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F0F1B), Color(0xFF1E1E2E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Button
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 10),

                  // Title
                  Text(
                    "Create Account",
                    style: GoogleFonts.orbitron(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFFFD700),
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Your journey starts here.",
                    style: GoogleFonts.lato(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Input fields
                  _buildGlassInput(
                    Icons.person,
                    "Full Name",
                    controller: fullNameController,
                  ),
                  const SizedBox(height: 16),

                  _buildGlassInput(
                    Icons.email,
                    "Email",
                    controller: emailController,
                  ),
                  const SizedBox(height: 16),

                  _buildGlassInput(
                    Icons.lock,
                    "Password",
                    obscureText: _obscurePassword,
                    controller: passwordController,
                    suffix: _visibilityToggle(
                      _obscurePassword,
                      () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildGlassInput(
                    Icons.lock,
                    "Confirm Password",
                    obscureText: _obscureConfirmPassword,
                    suffix: _visibilityToggle(
                      _obscureConfirmPassword,
                      () => setState(
                        () =>
                            _obscureConfirmPassword = !_obscureConfirmPassword,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Terms
                  Row(
                    children: [
                      Checkbox(
                        value: _agreedToTerms,
                        onChanged:
                            (value) =>
                                setState(() => _agreedToTerms = value ?? false),
                        activeColor: const Color(0xFFFFD700),
                      ),
                      Flexible(
                        child: Text.rich(
                          TextSpan(
                            text: "I agree to the ",
                            style: const TextStyle(color: Colors.white70),
                            children: [
                              TextSpan(
                                text: "Terms & Conditions",
                                style: const TextStyle(
                                  color: Color(0xFFFFD700),
                                ),
                              ),
                              const TextSpan(text: " and "),
                              TextSpan(
                                text: "Privacy Policy",
                                style: const TextStyle(
                                  color: Color(0xFFFFD700),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: const Color(0xFFFFD700),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 10,
                        shadowColor: Colors.black54,
                      ),
                      onPressed: () async {
                        if (_agreedToTerms) {
                          try {
                            final email = emailController.text.trim();
                            final password = passwordController.text.trim();
                            final fullName = fullNameController.text.trim();

                            final userCredential = await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                  email: email,
                                  password: password,
                                );

                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(userCredential.user!.uid)
                                .set({'name': fullName, 'miles': 0});

                            await generateAndSendOtp(email);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => OtpVerificationPage(email: email),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Signup failed: ${e.toString()}'),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please agree to the terms and conditions',
                              ),
                            ),
                          );
                        }
                      },
                      child: Text(
                        "Create Account",
                        style: GoogleFonts.orbitron(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Already have account
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account? ",
                        style: TextStyle(color: Colors.white70),
                      ),
                      GestureDetector(
                        onTap:
                            () => Navigator.pushReplacementNamed(context, '/'),
                        child: const Text(
                          "Sign In",
                          style: TextStyle(color: Color(0xFFFFD700)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassInput(
    IconData icon,
    String hintText, {
    bool obscureText = false,
    Widget? suffix,
    TextEditingController? controller,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: const Color(0xFFFFD700)),
          suffixIcon: suffix,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white54),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
        ),
      ),
    );
  }

  Widget _visibilityToggle(bool isObscured, VoidCallback onTap) {
    return IconButton(
      icon: Icon(
        isObscured ? Icons.visibility_off : Icons.visibility,
        color: Colors.white54,
      ),
      onPressed: onTap,
    );
  }
}
