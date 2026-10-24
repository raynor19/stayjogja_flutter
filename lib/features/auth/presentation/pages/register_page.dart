import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:stayjogja_flutter/core/constants/app_constants.dart';
import 'package:stayjogja_flutter/core/theme/app_theme.dart';
import 'package:stayjogja_flutter/features/auth/presentation/bloc/auth_cubit.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  DateTime? _selectedBirthDate;
  String _selectedGender = 'Laki-laki';
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1930),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.white,
              surface: AppColors.white,
              onSurface: AppColors.grey900,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedBirthDate = picked);
    }
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedBirthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih tanggal lahir Anda'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final birthDateFormatted = DateFormat('dd-MM-yyyy').format(_selectedBirthDate!);

    final success = await context.read<AuthCubit>().register(
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      birthDate: birthDateFormatted,
      gender: _selectedGender,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Selamat datang, ${_nameCtrl.text.trim()}! Akun Anda aktif di StayJogja 🎉'),
          backgroundColor: AppColors.emerald,
        ),
      );
      context.go(AppRoutes.home);
    } else {
      final state = context.read<AuthCubit>().state;
      String errorMsg = 'Pendaftaran gagal. Silakan coba lagi.';
      if (state is AuthError) {
        errorMsg = state.message;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg), backgroundColor: AppColors.error),
      );
    }
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
        title: const Text('Buat Akun Tamu', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700)),
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
                        height: 52,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Lengkapi Profil Anda untuk Reservasi & E-Voucher Hotel',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.grey600),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

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
                      // 1. Nama Lengkap
                      _label('Nama Lengkap Sesuai KTP'),
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

                      // 2. Email Address
                      _label('Email Aktif'),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _inputDeco('email@kamu.com', Icons.email_outlined),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Email wajib diisi';
                          if (!v.contains('@') || !v.contains('.')) return 'Format email tidak valid';
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // 3. Nomor WhatsApp / Telepon
                      _label('Nomor WhatsApp / Telepon'),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _phoneCtrl,
                        keyboardType: TextInputType.phone,
                        decoration: _inputDeco('Contoh: 081234567890', Icons.phone_android_rounded),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Nomor WhatsApp wajib diisi';
                          if (v.trim().length < 9) return 'Nomor telepon minimal 9 digit';
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // 4. Tanggal Lahir (Interactive DatePicker)
                      _label('Tanggal Lahir'),
                      const SizedBox(height: 6),
                      InkWell(
                        onTap: _pickBirthDate,
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          decoration: BoxDecoration(
                            color: AppColors.grey50,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.grey200),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today_rounded, size: 20, color: AppColors.grey600),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _selectedBirthDate != null
                                      ? DateFormat('dd MMMM yyyy').format(_selectedBirthDate!)
                                      : 'Pilih tanggal lahir Anda',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 13,
                                    color: _selectedBirthDate != null ? AppColors.grey900 : AppColors.grey400,
                                    fontWeight: _selectedBirthDate != null ? FontWeight.w600 : FontWeight.w400,
                                  ),
                                ),
                              ),
                              const Icon(Icons.arrow_drop_down, color: AppColors.grey600),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // 5. Jenis Kelamin (Gender Selector)
                      _label('Jenis Kelamin'),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: _genderPill(
                              label: 'Laki-laki',
                              icon: Icons.male_rounded,
                              isSelected: _selectedGender == 'Laki-laki',
                              onTap: () => setState(() => _selectedGender = 'Laki-laki'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _genderPill(
                              label: 'Perempuan',
                              icon: Icons.female_rounded,
                              isSelected: _selectedGender == 'Perempuan',
                              onTap: () => setState(() => _selectedGender = 'Perempuan'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // 6. Password
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

                      // 7. Konfirmasi Password
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

                      // Submit Button
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
                const SizedBox(height: 20),

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

  Widget _genderPill({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.emeraldLight : AppColors.grey50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.emerald : AppColors.grey200,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? AppColors.emerald : AppColors.grey600,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppColors.emerald : AppColors.grey800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.grey800,
      ),
    );
  }

  InputDecoration _inputDeco(String hint, IconData icon, {Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, size: 20, color: AppColors.grey400),
      suffixIcon: suffix,
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
        borderSide: const BorderSide(color: AppColors.emerald, width: 2),
      ),
    );
  }
}
