import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stayjogja_flutter/core/theme/app_theme.dart';
import 'package:stayjogja_flutter/core/constants/app_constants.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Akun Saya',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.grey900,
                ),
              ),
              const SizedBox(height: 20),

              // ─── User Profile Card ─────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Avatar
                    Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        color: AppColors.emeraldLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          'B',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppColors.emerald,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Budiarti',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.grey900,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.badgeMemberBg,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'MEMBER',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.badgeMemberText,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'budiarti@gmail.com',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              color: AppColors.grey600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            '+62 812-3456-7890',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 11,
                              color: AppColors.grey400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 20, color: AppColors.grey600),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ─── Section 1: Aktivitas ──────────────────────────────────
              _sectionTitle('Aktivitas & Favorit'),
              const SizedBox(height: 10),
              _settingsCard([
                _tile(Icons.favorite_outline_rounded, 'Wishlist Hotel', '3 Hotel disimpan', () {}),
                _tile(Icons.rate_review_outlined, 'Ulasan Saya', 'Belum ada ulasan', () {}),
                _tile(Icons.confirmation_number_outlined, 'Voucher & Promo', '2 Kode promo aktif', () {}),
              ]),
              const SizedBox(height: 20),

              // ─── Section 2: Pengaturan Aplikasi ────────────────────────
              _sectionTitle('Pengaturan & Preferensi'),
              const SizedBox(height: 10),
              _settingsCard([
                _tile(Icons.notifications_none_rounded, 'Notifikasi', 'Check-in & promo', () {}),
                _tile(Icons.language_rounded, 'Bahasa', 'Bahasa Indonesia', () {}),
                _tile(Icons.security_rounded, 'Keamanan & Sandi', 'Kata sandi terlindungi', () {}),
              ]),
              const SizedBox(height: 20),

              // ─── Section 3: Bantuan & Legalitas (UU PDP) ────────────────
              _sectionTitle('Dukungan & Privasi'),
              const SizedBox(height: 10),
              _settingsCard([
                _tile(Icons.help_center_outlined, 'Pusat Bantuan & FAQ', 'Solusi kendala booking', () {}),
                _tile(Icons.phone_in_talk_outlined, 'Hubungi Layanan Stay Jogja', '24/7 CS Jogja', () {}),
                _tile(Icons.shield_outlined, 'Kebijakan Privasi (UU PDP)', 'Perlindungan data Anda', () {}),
                _tile(Icons.delete_outline_rounded, 'Hapus Akun', 'Penghapusan data pribadi', () {}, isDestructive: true),
              ]),
              const SizedBox(height: 24),

              // Logout Button
              Center(
                child: TextButton.icon(
                  onPressed: () {
                    context.go(AppRoutes.login);
                  },
                  icon: const Icon(Icons.logout_rounded, size: 18, color: AppColors.error),
                  label: const Text(
                    'Keluar dari Akun',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.error,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.grey600,
      ),
    );
  }

  Widget _settingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _tile(IconData icon, String title, String subtitle, VoidCallback onTap, {bool isDestructive = false}) {
    return ListTile(
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: isDestructive ? AppColors.error.withValues(alpha: 0.1) : AppColors.grey100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 20, color: isDestructive ? AppColors.error : AppColors.grey800),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: isDestructive ? AppColors.error : AppColors.grey900,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 11,
          color: AppColors.grey400,
        ),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.grey400),
      onTap: onTap,
    );
  }
}
