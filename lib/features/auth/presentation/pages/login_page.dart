import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stayjogja_flutter/core/constants/app_constants.dart';
import 'package:stayjogja_flutter/core/theme/app_theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController(text: 'budiarti@gmail.com');
  final _passwordCtrl = TextEditingController(text: 'password123');
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _login() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      context.go(AppRoutes.home);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // Luxury mint pastel canvas
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),

                // ─── Header: Liquid Glass Logo Emblem ──────────────────
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 68,
                        height: 68,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF0F2618).withValues(alpha: 0.10),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(22),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white.withValues(alpha: 0.95),
                                    Colors.white.withValues(alpha: 0.65),
                                  ],
                                ),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  width: 1.5,
                                ),
                              ),
                              child: const Center(
                                child: Icon(Icons.hotel_rounded, size: 34, color: AppColors.emerald),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Welcome Back 👋',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.grey900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Masuk untuk melanjutkan liburanmu di Jogja',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: AppColors.grey600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // ─── Form Card (White Rounded 28) ──────────────────────
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Email
                      const Text(
                        'Email Address',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.grey800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'nama@email.com',
                          prefixIcon: const Icon(Icons.email_outlined, size: 20, color: AppColors.grey600),
                          filled: true,
                          fillColor: AppColors.grey50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: AppColors.grey200),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: AppColors.grey200),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: AppColors.emerald, width: 1.5),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Email wajib diisi';
                          return null;
                        },
                      ),
                      const SizedBox(height: 18),

                      // Password
                      const Text(
                        'Password',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.grey800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _passwordCtrl,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: '••••••••',
                          prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20, color: AppColors.grey600),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                              size: 20,
                              color: AppColors.grey600,
                            ),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                          filled: true,
                          fillColor: AppColors.grey50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: AppColors.grey200),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: AppColors.grey200),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: AppColors.emerald, width: 1.5),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Password wajib diisi';
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),

                      // Forgot Password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Lupa Password?',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              color: AppColors.grey600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Obsidian Black Pill Button
                      ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          minimumSize: const Size(double.infinity, 52),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 2),
                              )
                            : const Text(
                                'Masuk ke Akun',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Divider
                Row(
                  children: const [
                    Expanded(child: Divider(color: AppColors.grey200)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      child: Text(
                        'atau masuk dengan',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: AppColors.grey600),
                      ),
                    ),
                    Expanded(child: Divider(color: AppColors.grey200)),
                  ],
                ),
                const SizedBox(height: 20),

                // Google Button Pill
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: AppColors.grey200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () {
                      context.go(AppRoutes.home);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.g_mobiledata_rounded, size: 28, color: AppColors.grey900),
                        SizedBox(width: 8),
                        Text(
                          'Lanjutkan dengan Google',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.grey900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // Register Link
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Belum punya akun? ',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.grey600),
                      ),
                      GestureDetector(
                        onTap: () => context.push(AppRoutes.register),
                        child: const Text(
                          'Daftar Sekarang',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.emerald,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 36),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
