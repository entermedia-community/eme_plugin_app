import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  final Function(String) onLoginSuccess;

  const LoginScreen({super.key, required this.onLoginSuccess});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'demo@emeworld.com');
  final _passwordController = TextEditingController(text: 'password123');
  bool _obscurePassword = true;
  bool _rememberMe = true;
  bool _isLoading = false;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _autofill(String email, String password) {
    setState(() {
      _emailController.text = email;
      _passwordController.text = password;
    });
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate SSO handshake
    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      widget.onLoginSuccess(_emailController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 600;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0B0F13), Color(0xFF141923), Color(0xFF0F1319)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Decorative glowing elements
            Positioned(
              top: -size.height * 0.2,
              right: -size.width * 0.1,
              child: Container(
                width: size.width * 0.6,
                height: size.width * 0.6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF38B6FF).withValues(alpha: 0.08),
                ),
              ),
            ),
            Positioned(
              bottom: -size.height * 0.2,
              left: -size.width * 0.1,
              child: Container(
                width: size.width * 0.6,
                height: size.width * 0.6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF8A2387).withValues(alpha: 0.06),
                ),
              ),
            ),

            // Main content
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isDesktop ? 450 : double.infinity,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: BackdropFilter(
                          filter: ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF161C24,
                              ).withValues(alpha: 0.65),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.08),
                                width: 1.5,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 40,
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Logo Container
                                  Center(
                                    child: Container(
                                      width: 64,
                                      height: 64,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(
                                              0xFF38B6FF,
                                            ).withValues(alpha: 0.2),
                                            blurRadius: 15,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: const Image(
                                        image: AssetImage('assets/logo.png'),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  // Title
                                  const Text(
                                    'TestU Labs',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: -0.5,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Single Sign-On (SSO)',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF90A4AE),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 32),

                                  // Email Address Input
                                  const Text(
                                    'Email Address',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  _buildInputField(
                                    controller: _emailController,
                                    hintText: 'Enter your enterprise email',
                                    prefixIcon: Icons.email_outlined,
                                    validator: (val) {
                                      if (val == null || val.trim().isEmpty) {
                                        return 'Please enter your email';
                                      }
                                      if (!val.contains('@')) {
                                        return 'Please enter a valid email address';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20),

                                  // Password Input
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Password',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'SSO password reset must be completed through eME Admin portal.',
                                              ),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          'Forgot Password?',
                                          style: TextStyle(
                                            color: Color(0xFF38B6FF),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  _buildInputField(
                                    controller: _passwordController,
                                    hintText: 'Enter your password',
                                    prefixIcon: Icons.lock_outline_rounded,
                                    obscureText: _obscurePassword,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: Colors.white38,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                    ),
                                    validator: (val) {
                                      if (val == null || val.isEmpty) {
                                        return 'Please enter your password';
                                      }
                                      if (val.length < 6) {
                                        return 'Password must be at least 6 characters';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),

                                  // Remember me checkbox
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: Checkbox(
                                          value: _rememberMe,
                                          activeColor: const Color(0xFF38B6FF),
                                          checkColor: Colors.black,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          side: BorderSide(
                                            color: Colors.white.withValues(
                                              alpha: 0.2,
                                            ),
                                          ),
                                          onChanged: (val) {
                                            setState(() {
                                              _rememberMe = val ?? false;
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Remember my session',
                                        style: TextStyle(
                                          color: Color(0xFF90A4AE),
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 28),

                                  // Sign in Button
                                  _isLoading
                                      ? const Center(
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Color(0xFF38B6FF),
                                                ),
                                          ),
                                        )
                                      : Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xFF38B6FF),
                                                Color(0xFF8A2387),
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(
                                                  0xFF38B6FF,
                                                ).withValues(alpha: 0.25),
                                                blurRadius: 12,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: ElevatedButton(
                                            onPressed: _submit,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.transparent,
                                              shadowColor: Colors.transparent,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 16,
                                                  ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                              ),
                                            ),
                                            child: const Text(
                                              'Sign In with eME World',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                  const SizedBox(height: 24),

                                  // Divider
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Divider(
                                          color: Colors.white.withValues(
                                            alpha: 0.1,
                                          ),
                                          thickness: 1,
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        child: Text(
                                          'DEMO ACCOUNTS',
                                          style: TextStyle(
                                            color: Colors.white24,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.0,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Divider(
                                          color: Colors.white.withValues(
                                            alpha: 0.1,
                                          ),
                                          thickness: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),

                                  // Quick autofill buttons
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildAutofillButton(
                                          label: 'Demo User',
                                          email: 'demo@emeworld.com',
                                          password: 'password123',
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: _buildAutofillButton(
                                          label: 'Admin User',
                                          email: 'admin@emeworld.com',
                                          password: 'adminSecure123',
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 24),
                                  Text(
                                    textAlign: TextAlign.center,
                                    'Powered by eMe.world',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white.withValues(
                                        alpha: 0.5,
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
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F1319),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white38, fontSize: 14),
          prefixIcon: Icon(prefixIcon, color: Colors.white38, size: 20),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 32,
            minHeight: 20,
          ),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          errorStyle: const TextStyle(color: Color(0xFFE94057), fontSize: 11),
        ),
      ),
    );
  }

  Widget _buildAutofillButton({
    required String label,
    required String email,
    required String password,
  }) {
    return InkWell(
      onTap: () => _autofill(email, password),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.02),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              email.split('@')[0],
              style: const TextStyle(color: Colors.white38, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
