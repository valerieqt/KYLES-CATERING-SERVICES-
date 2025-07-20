import 'package:flutter/material.dart';

class StyledLoginPage extends StatefulWidget {
  const StyledLoginPage({super.key});

  @override
  State<StyledLoginPage> createState() => _StyledLoginPageState();
}

class _StyledLoginPageState extends State<StyledLoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  String? _selectedRole;

  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
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
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/logo_kyles.png', height: 80),
                    const SizedBox(height: 20),
                    const Text(
                      "Kyle’s Catering Services by RA",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF2E3D4),
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildLoginCard(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginCard() {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              _buildTextField(
                controller: _usernameController,
                hintText: "Username",
                icon: Icons.person,
                isPassword: false,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: _emailController,
                hintText: "Email",
                icon: Icons.email,
                isPassword: false,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: _passwordController,
                hintText: "Password",
                icon: Icons.lock,
                isPassword: true,
              ),
              const SizedBox(height: 15),
              _buildRoleDropdown(),
              const SizedBox(height: 10),
              _buildForgotPassword(),
              const SizedBox(height: 25),
              _buildLoginButton(),
              const SizedBox(height: 10),
              const Text("or", style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 10),
              _buildCreateAccountButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required bool isPassword,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? !_isPasswordVisible : false,
      keyboardType: hintText == "Email"
          ? TextInputType.emailAddress
          : TextInputType.text,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF741D1F)),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  color: const Color(0xFF741D1F),
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              )
            : null,
        hintText: hintText,
        filled: true,
        fillColor: const Color(0xFFF2E3D4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter your ${hintText.toLowerCase()}';
        }
        if (hintText == "Email" &&
            !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Enter a valid email';
        }
        return null;
      },
    );
  }

  Widget _buildRoleDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedRole,
      hint: const Text("Roles", style: TextStyle(color: Color(0xFF741D1F))),
      onChanged: (String? newValue) => setState(() => _selectedRole = newValue),
      dropdownColor: Colors.white,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.account_circle, color: Color(0xFF741D1F)),
        filled: true,
        fillColor: const Color(0xFFF2E3D4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
      items: ['Admin', 'Staff']
          .map((role) => DropdownMenuItem(value: role, child: Text(role)))
          .toList(),
      validator: (value) => value == null ? 'Please select a role' : null,
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          Navigator.pushNamed(context, '/forgot-password');
        },
        child: const Text(
          "Forgot Password?",
          style: TextStyle(
            color: Color(0xFF741D1F),
            fontSize: 13,
            fontStyle: FontStyle.italic,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            if (_selectedRole == 'Staff') {
              Navigator.pushNamed(
                context,
                '/staff-dashboard',
                arguments: {
                  'userName': _usernameController.text,
                  'userEmail': _emailController.text,
                },
              );
            } else {
              if (_selectedRole == 'Admin') {
                Navigator.pushNamed(
                  context,
                  '/admin-dashboard',
                  arguments: {
                    'userName': _usernameController.text.trim(),
                    'userEmail': _emailController.text.trim(),
                  },
                );
              }
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Logged in as Admin"),
                  backgroundColor: Color(0xFF637C33),
                ),
              );
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF637C33),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text("Login"),
      ),
    );
  }

  Widget _buildCreateAccountButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/signup');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF741D1F),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text("Create an account"),
      ),
    );
  }
}
