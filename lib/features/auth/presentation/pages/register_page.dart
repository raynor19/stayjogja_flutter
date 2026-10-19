import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stayjogja_flutter/core/constants/app_constants.dart';
import 'package:stayjogja_flutter/core/theme/app_theme.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _register() {
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: const BoxDecoration(color: AppColors.white, shape: BoxShape.circle),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
            onPressed: () => context.pop(),
          ),
        ),
        title: const Text('Buat Akun Baru', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/logo_emblem.png',
                        height: 54,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Bergabung dengan Stay Jogja',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.grey600),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Form Container
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('Nama Lengkap'),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _nameCtrl,
                        textCapitalization: TextCapitalization.words,
                        decoration: _inputDeco('Nama lengkap kamu', Icons.person_outline),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Nama wajib diisi';
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      _label('Email Address'),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _inputDeco('email@kamu.com', Icons.email_outlined),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Email wajib diisi';
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      _label('Password'),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _passwordCtrl,
                        obscureText: _obscurePassword,
                        decoration: _inputDeco(
                          'Minimal 6 karakter',
                          Icons.lock_outline,
                          suffix: IconButton(
                            icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 20),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Password wajib diisi';
                          if (v.length < 6) return 'Password minimal 6 karakter';
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      _label('Konfirmasi Password'),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _confirmCtrl,
                        obscureText: _obscureConfirm,
                        decoration: _inputDeco(
                          'Ulangi password',
                          Icons.lock_outline,
                          suffix: IconButton(
                            icon: Icon(_obscureConfirm ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 20),
                            onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                          ),
                        ),
                        validator: (v) {
                          if (v != _passwordCtrl.text) return 'Password tidak cocok';
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      ElevatedButton(
                        onPressed: _isLoading ? null : _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 2),
                              )
                            : const Text('Daftar Sekarang', style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Sudah punya akun? ', style: TextStyle(color: AppColors.grey600, fontSize: 13)),
                      GestureDetector(
                        onTap: () => context.go(AppRoutes.login),
                        child: const Text(
                          'Masuk',
                          style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.emerald, fontSize: 13),
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

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.grey800),
    );
  }

  InputDecoration _inputDeco(String hint, IconData icon, {Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, size: 20, color: AppColors.grey600),
      suffixIcon: suffix,
      filled: true,
      fillColor: AppColors.grey50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.grey200)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.grey200)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.emerald, width: 1.5)),
    );
  }
}
