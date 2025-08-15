import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skymiles_app/authentication/forgot_password.dart';
import 'package:skymiles_app/screens/home_page.dart';

class DemoUser {
  final String title;
  final String email;
  final String name;
  final int miles;

  const DemoUser({
    required this.title,
    required this.email,
    required this.name,
    required this.miles,
  });
}

class StyledLoginPage extends StatefulWidget {
  const StyledLoginPage({super.key});

  @override
  State<StyledLoginPage> createState() => _StyledLoginPageState();
}

class _StyledLoginPageState extends State<StyledLoginPage>
    with SingleTickerProviderStateMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _demoName;
  int? _demoMiles;

  late AnimationController _particleController;
  final Random _random = Random();
  final List<_Particle> _particles = [];

  static const List<DemoUser> demoUsers = [
    DemoUser(
      title: '🥉 Bronze User',
      email: 'michael@gmail.com',
      name: 'Michael',
      miles: 5000,
    ),
    DemoUser(
      title: '🥈 Silver User',
      email: 'sarah@gmail.com',
      name: 'Sarah',
      miles: 15000,
    ),
    DemoUser(
      title: '🥇 Gold User',
      email: 'alex@gmail.com',
      name: 'Alex',
      miles: 30000,
    ),
    DemoUser(
      title: '💎 Platinum User',
      email: 'jess@gmail.com',
      name: 'Jess',
      miles: 50000,
    ),
  ];

  @override
  void initState() {
    super.initState();

    // Create particles
    for (int i = 0; i < 40; i++) {
      _particles.add(
        _Particle(
          dx: _random.nextDouble(),
          dy: _random.nextDouble(),
          size: _random.nextDouble() * 3 + 1,
          speed: _random.nextDouble() * 0.0005 + 0.0002,
        ),
      );
    }

    // Particle animation controller
    _particleController =
        AnimationController(vsync: this, duration: const Duration(seconds: 60))
          ..addListener(() {
            setState(() {
              for (var p in _particles) {
                p.dy += p.speed;
                if (p.dy > 1) {
                  p.dy = 0;
                  p.dx = _random.nextDouble();
                }
              }
            });
          })
          ..repeat();
  }

  @override
  void dispose() {
    _particleController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void autofill(String email, String name, int miles) {
    setState(() {
      emailController.text = email;
      passwordController.text = '123456'; // demo password
      _demoName = name;
      _demoMiles = miles;
    });
  }

  Future<void> _handleLogin() async {
    String name = _demoName ?? '';
    int miles = _demoMiles ?? 0;

    if (_demoName == null) {
      try {
        final userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
            );

        final firebaseUser = userCredential.user;
        if (firebaseUser != null) {
          name = firebaseUser.displayName ?? 'User';
          miles = 0;
        }
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed: ${e.message}'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (context) => HomePage(
              user: UserData(
                name: name,
                email: emailController.text.trim(),
                miles: miles,
              ),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D0B08), Color(0xFF1A1713), Color(0xFF3A352F)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // ✨ Animated gold particles
            Positioned.fill(
              child: CustomPaint(painter: _ParticlePainter(_particles)),
            ),

            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 48,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Luxury gradient title
                      ShaderMask(
                        shaderCallback:
                            (bounds) => LinearGradient(
                              colors: [
                                const Color(0xFFD9B382),
                                Colors.amberAccent.shade100,
                              ],
                            ).createShader(bounds),
                        child: Text(
                          "Aurora",
                          style: GoogleFonts.playfairDisplay(
                            fontWeight: FontWeight.w900,
                            fontSize: 52,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Experience the Pinnacle of Luxury",
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 16,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 48),

                      // Glassmorphic card
                      Container(
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.07),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.white24, width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.amber.withOpacity(0.2),
                              blurRadius: 30,
                              spreadRadius: 1,
                            ),
                          ],
                          backgroundBlendMode: BlendMode.overlay,
                        ),
                        child: Column(
                          children: [
                            _buildInputField(
                              Icons.email,
                              "Email Address",
                              controller: emailController,
                            ),
                            const SizedBox(height: 24),
                            _buildInputField(
                              Icons.lock,
                              "Password",
                              controller: passwordController,
                              obscureText: _obscurePassword,
                              suffix: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.amberAccent.shade100,
                                ),
                                onPressed:
                                    () => setState(
                                      () =>
                                          _obscurePassword = !_obscurePassword,
                                    ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed:
                                    () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => const ForgotPasswordPage(),
                                      ),
                                    ),
                                child: const Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                    color: Color(0xFFD9B382),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Sign In button
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFD9B382),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                elevation: 12,
                                shadowColor: Colors.amberAccent,
                              ),
                              onPressed: _handleLogin,
                              child: Text(
                                "Sign In",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black87,
                                ),
                              ),
                            ),

                            const SizedBox(height: 28),

                            // Demo users
                            ...demoUsers.map(_demoUserWidget),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
    IconData icon,
    String hintText, {
    bool obscureText = false,
    Widget? suffix,
    TextEditingController? controller,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: GoogleFonts.lato(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.12),
        prefixIcon: Icon(
          icon,
          color: const Color(0xFFD9B382).withOpacity(0.85),
        ),
        suffixIcon: suffix,
        hintText: hintText,
        hintStyle: GoogleFonts.lato(
          color: Colors.white54,
          fontWeight: FontWeight.w400,
          fontSize: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xFFD9B382), width: 2),
        ),
      ),
    );
  }

  Widget _demoUserWidget(DemoUser user) {
    return GestureDetector(
      onTap: () => autofill(user.email, user.name, user.miles),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              user.title,
              style: GoogleFonts.poppins(
                color: const Color(0xFFD9B382),
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            Text(
              user.email,
              style: GoogleFonts.lato(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

// Particle model
class _Particle {
  double dx;
  double dy;
  double size;
  double speed;

  _Particle({
    required this.dx,
    required this.dy,
    required this.size,
    required this.speed,
  });
}

// Particle painter
class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;

  _ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFFD9B382).withOpacity(0.8);
    for (var p in particles) {
      canvas.drawCircle(
        Offset(p.dx * size.width, p.dy * size.height),
        p.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
