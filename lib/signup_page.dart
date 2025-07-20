import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _selectedRole;

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
    _animationController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg_kyles.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/logo_kyles.png', height: 80),
                    const SizedBox(height: 20),
                    const Text(
                      "Create Account",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF2E3D4),
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildSignupForm(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignupForm(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(_usernameController, "Username", Icons.person),
              const SizedBox(height: 20),
              _buildTextField(_emailController, "Email", Icons.email),
              const SizedBox(height: 20),
              _buildTextField(
                _passwordController,
                "Password",
                Icons.lock,
                obscureText: true,
              ),
              const SizedBox(height: 20),
              _buildRoleDropdown(),
              const SizedBox(height: 30),
              _buildSignupButton(),
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
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    IconData icon, {
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF741D1F)),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black45),
        filled: true,
        fillColor: const Color(0xFFF2E3D4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) => value!.isEmpty ? 'Please enter your $hint' : null,
    );
  }

  Widget _buildRoleDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedRole,
      hint: const Text(
        "Select Role",
        style: TextStyle(color: Color(0xFF741D1F)),
      ),
      onChanged: (value) => setState(() => _selectedRole = value),
      dropdownColor: Colors.white,
      style: const TextStyle(color: Color(0xFF741D1F)),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.account_circle, color: Color(0xFF741D1F)),
        filled: true,
        fillColor: const Color(0xFFF2E3D4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
      items: ['Admin', 'Staff'].map((role) {
        return DropdownMenuItem(value: role, child: Text(role));
      }).toList(),
      validator: (value) => value == null ? 'Please select a role' : null,
    );
  }

  Widget _buildSignupButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate() && _selectedRole != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Account created successfully as $_selectedRole!",
                ),
                backgroundColor: const Color(0xFF637C33),
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
        child: const Text("Sign Up"),
      ),
    );
  }
}
