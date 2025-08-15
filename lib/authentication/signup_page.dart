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
  final confirmPasswordController = TextEditingController();
  final fullNameController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreedToTerms = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    fullNameController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> generateAndSendOtp(String email) async {
    final otp = (Random().nextInt(900000) + 100000).toString();
    final firestore = FirebaseFirestore.instance;
    final safeEmailId = Uri.encodeComponent(email);

    try {
      await firestore.collection('emailOtps').doc(safeEmailId).set({
        'otp': otp,
        'timestamp': DateTime.now(),
      });
      print("OTP sent to $email: $otp");
    } catch (e) {
      print('Firestore OTP collection error: $e');
    }
  }

  void _signup() async {
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to the terms and conditions'),
        ),
      );
      return;
    }

    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();
    final fullName = fullNameController.text.trim();

    if ([email, password, confirmPassword, fullName].any((e) => e.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }

    try {
      // 1️⃣ Create user in Firebase Auth
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final uid = userCredential.user!.uid;

      // 2️⃣ Save user data safely
      try {
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'name': fullName,
          'miles': 0,
        });
      } catch (e) {
        print('Firestore users collection error: $e');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving user info: $e')));
        return;
      }

      // 3️⃣ Navigate to OTP page first
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => OtpVerificationPage(email: email)),
      );

      // 4️⃣ Send OTP asynchronously
      generateAndSendOtp(email);
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'This email is already registered.';
          break;
        case 'invalid-email':
          message = 'The email address is invalid.';
          break;
        case 'weak-password':
          message = 'Password must be at least 6 characters.';
          break;
        default:
          message = e.message ?? 'Signup failed';
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Unexpected error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0F0F1B), Color(0xFF1E1E2E)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Positioned(top: 50, left: -50, child: _circleGlow(100)),
          Positioned(top: 200, right: -70, child: _circleGlow(150)),
          Positioned(bottom: 100, left: -40, child: _circleGlow(120)),
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 40,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Create Account",
                          style: GoogleFonts.orbitron(
                            fontSize: 36,
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
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 30),
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
                          suffix: _visibilityToggle(_obscurePassword, () {
                            setState(
                              () => _obscurePassword = !_obscurePassword,
                            );
                          }),
                        ),
                        const SizedBox(height: 16),
                        _buildGlassInput(
                          Icons.lock,
                          "Confirm Password",
                          obscureText: _obscureConfirmPassword,
                          controller: confirmPasswordController,
                          suffix: _visibilityToggle(
                            _obscureConfirmPassword,
                            () {
                              setState(
                                () =>
                                    _obscureConfirmPassword =
                                        !_obscureConfirmPassword,
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Checkbox(
                              value: _agreedToTerms,
                              onChanged:
                                  (value) => setState(
                                    () => _agreedToTerms = value ?? false,
                                  ),
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
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFD700),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 10,
                              shadowColor: Colors.black54,
                            ),
                            onPressed: _signup,
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
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already have an account? ",
                              style: TextStyle(color: Colors.white70),
                            ),
                            GestureDetector(
                              onTap:
                                  () => Navigator.pushReplacementNamed(
                                    context,
                                    '/',
                                  ),
                              child: const Text(
                                "Sign In",
                                style: TextStyle(color: Color(0xFFFFD700)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleGlow(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.08),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.05),
            blurRadius: 80,
            spreadRadius: 30,
          ),
        ],
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
      width: double.infinity,
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
