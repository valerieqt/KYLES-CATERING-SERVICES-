import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg_kyles.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Gradient overlay
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xAAAD1F23), Color(0xAA741D1F)],
              ),
            ),
          ),

          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Image.asset('assets/logo_kyles.png', height: 80),
                    const SizedBox(height: 20),
                    const Text(
                      "Reset Your Password",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF2E3D4),
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildFormCard(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              "Enter your email or username below and we'll send you a link to reset your password.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Email or Username',
                prefixIcon: const Icon(Icons.email, color: Color(0xFF741D1F)),
                hintStyle: const TextStyle(color: Colors.black45),
                filled: true,
                fillColor: const Color(0xFFF2E3D4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final input = _emailController.text.trim();
                  if (input.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Password reset link sent!"),
                        backgroundColor: Color(0xFF637C33),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF741D1F),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text("Send Reset Link"),
              ),
            ),
            const SizedBox(height: 15),
            TextButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/'),
              child: const Text(
                "Back to Login",
                style: TextStyle(
                  color: Color(0xFF741D1F),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
