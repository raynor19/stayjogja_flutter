import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:stayjogja_flutter/core/theme/app_theme.dart';
import 'package:stayjogja_flutter/core/constants/app_constants.dart';
import 'package:stayjogja_flutter/core/constants/mock_data.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _userName = 'Budiarti';
  String _userEmail = 'budiarti@gmail.com';
  String _userPhone = '+62 812-3456-7890';
  String _currentLanguage = 'Bahasa Indonesia';
  bool _notifBooking = true;
  bool _notifPromo = true;
  bool _notifItinerary = true;

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
                      child: Center(
                        child: Text(
                          _userName.isNotEmpty ? _userName[0].toUpperCase() : 'B',
                          style: const TextStyle(
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
                              Text(
                                _userName,
                                style: const TextStyle(
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
                          Text(
                            _userEmail,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              color: AppColors.grey600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _userPhone,
                            style: const TextStyle(
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
                      onPressed: _showEditProfileSheet,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ─── Section 1: Aktivitas ──────────────────────────────────
              _sectionTitle('Aktivitas & Favorit'),
              const SizedBox(height: 10),
              _settingsCard([
                _tile(Icons.favorite_outline_rounded, 'Wishlist Hotel', '3 Hotel disimpan', _showWishlistSheet),
                _tile(Icons.rate_review_outlined, 'Ulasan Saya', 'Riwayat ulasan hotel & atraksi', _showReviewsSheet),
                _tile(Icons.confirmation_number_outlined, 'Voucher & Promo', '2 Kode promo aktif', _showPromoSheet),
              ]),
              const SizedBox(height: 20),

              // ─── Section 2: Pengaturan Aplikasi ────────────────────────
              _sectionTitle('Pengaturan & Preferensi'),
              const SizedBox(height: 10),
              _settingsCard([
                _tile(Icons.notifications_none_rounded, 'Notifikasi', 'Pengingat check-in & promo', _showNotificationsDialog),
                _tile(Icons.language_rounded, 'Bahasa', _currentLanguage, _showLanguageDialog),
                _tile(Icons.security_rounded, 'Keamanan & Sandi', 'Ubah kata sandi & PIN', _showSecuritySheet),
              ]),
              const SizedBox(height: 20),

              // ─── Section 3: Bantuan & Legalitas (UU PDP) ────────────────
              _sectionTitle('Dukungan & Privasi'),
              const SizedBox(height: 10),
              _settingsCard([
                _tile(Icons.help_center_outlined, 'Pusat Bantuan & FAQ', 'Solusi kendala booking', _showFaqDialog),
                _tile(Icons.phone_in_talk_outlined, 'Hubungi Layanan Stay Jogja', '24/7 CS Yogyakarta', _contactSupport),
                _tile(Icons.shield_outlined, 'Kebijakan Privasi (UU PDP)', 'Kepatuhan pelindungan data pribadi', _showPrivacyPolicyDialog),
                _tile(Icons.delete_outline_rounded, 'Hapus Akun', 'Penghapusan data pribadi permanen', _showDeleteAccountDialog, isDestructive: true),
              ]),
              const SizedBox(height: 24),

              // Logout Button
              Center(
                child: TextButton.icon(
                  onPressed: _showLogoutDialog,
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: Column(children: children),
        ),
      ),
    );
  }

  Widget _tile(IconData icon, String title, String subtitle, VoidCallback onTap, {bool isDestructive = false}) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
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
      ),
    );
  }

  // ─── 1. Edit Profile Sheet ────────────────────────────────────────────────
  void _showEditProfileSheet() {
    final nameCtrl = TextEditingController(text: _userName);
    final emailCtrl = TextEditingController(text: _userEmail);
    final phoneCtrl = TextEditingController(text: _userPhone);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.grey400, borderRadius: BorderRadius.circular(2))),
              ),
              const SizedBox(height: 16),
              const Text('Edit Profil Pengguna', style: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: 'Nama Lengkap',
                  prefixIcon: const Icon(Icons.person_outline),
                  filled: true,
                  fillColor: AppColors.grey50,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  filled: true,
                  fillColor: AppColors.grey50,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Nomor WhatsApp',
                  prefixIcon: const Icon(Icons.phone_outlined),
                  filled: true,
                  fillColor: AppColors.grey50,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _userName = nameCtrl.text.trim();
                    _userEmail = emailCtrl.text.trim();
                    _userPhone = phoneCtrl.text.trim();
                  });
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profil berhasil diperbarui! ✅'), backgroundColor: AppColors.emerald),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text('Simpan Perubahan'),
              ),
            ],
          ),
        );
      },
    );
  }

  // ─── 2. Wishlist Sheet ────────────────────────────────────────────────────
  void _showWishlistSheet() {
    final wishlistHotels = MockData.hotels.take(3).toList();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          builder: (_, scrollCtrl) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.grey400, borderRadius: BorderRadius.circular(2))),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Wishlist Hotel Saya', style: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w700)),
                      Text('${wishlistHotels.length} Disimpan', style: const TextStyle(fontSize: 12, color: AppColors.emerald, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.separated(
                      controller: scrollCtrl,
                      itemCount: wishlistHotels.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, i) {
                        final h = wishlistHotels[i];
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.grey50,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.grey200),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CachedNetworkImage(imageUrl: h.images.first, width: 70, height: 70, fit: BoxFit.cover),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(h.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                                    const SizedBox(height: 2),
                                    Text('${h.area} • ★ ${h.rating}', style: const TextStyle(fontSize: 11, color: AppColors.grey600)),
                                    const SizedBox(height: 4),
                                    Text('Rp ${h.startingPrice ~/ 1000}k/malam', style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.emerald, fontSize: 12)),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                                onPressed: () {
                                  Navigator.pop(ctx);
                                  context.push('/hotel/${h.id}');
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ─── 3. Reviews Sheet ─────────────────────────────────────────────────────
  void _showReviewsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.grey400, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 16),
              const Icon(Icons.rate_review_outlined, size: 48, color: AppColors.emerald),
              const SizedBox(height: 12),
              const Text('Ulasan Saya', style: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              const Text(
                'Anda belum menulis ulasan menginap. Ulasan dapat diberikan setelah pesanan Anda berstatus selesai menginap.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: AppColors.grey600, height: 1.5),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  context.go(AppRoutes.bookings);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 46),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text('Buka Riwayat Booking'),
              ),
            ],
          ),
        );
      },
    );
  }

  // ─── 4. Promo Vouchers Sheet ──────────────────────────────────────────────
  void _showPromoSheet() {
    final promos = [
      {'code': 'STAYJOGJA10', 'title': 'Diskon 10% Semua Hotel Jogja', 'desc': 'Min. transaksi Rp 500.000', 'valid': 'Berlaku s/d 31 Des 2026'},
      {'code': 'AITRIPFREE', 'title': 'Gratis Generate AI Itinerary Unlimited', 'desc': 'Khusus pengguna aplikasi Stay Jogja', 'valid': 'Tanpa batas waktu'},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.grey400, borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 16),
              const Text('Voucher & Kode Promo Aktif', style: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 14),
              ...promos.map((p) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.grey50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.emerald.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: AppColors.emeraldLight, borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.confirmation_number_outlined, color: AppColors.emerald, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p['title']!, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                            const SizedBox(height: 2),
                            Text(p['desc']!, style: const TextStyle(fontSize: 11, color: AppColors.grey600)),
                            const SizedBox(height: 4),
                            Text(p['valid']!, style: const TextStyle(fontSize: 10, color: AppColors.grey400)),
                          ],
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Kode ${p['code']} berhasil disalin!'), backgroundColor: AppColors.emerald),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.emerald,
                          side: const BorderSide(color: AppColors.emerald),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        ),
                        child: const Text('Salin', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  // ─── 5. Notifications Dialog ──────────────────────────────────────────────
  void _showNotificationsDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDlgState) {
            return AlertDialog(
              backgroundColor: AppColors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              title: const Text('Pengaturan Notifikasi', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w700)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SwitchListTile(
                    activeColor: AppColors.emerald,
                    title: const Text('Status Pemesanan', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    subtitle: const Text('Notifikasi pembayaran dan konfirmasi e-voucher', style: TextStyle(fontSize: 11)),
                    value: _notifBooking,
                    onChanged: (v) {
                      setDlgState(() => _notifBooking = v);
                      setState(() {});
                    },
                  ),
                  SwitchListTile(
                    activeColor: AppColors.emerald,
                    title: const Text('Pengingat Itinerary Harian', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    subtitle: const Text('Jadwal kunjungan tempat wisata dari hotel', style: TextStyle(fontSize: 11)),
                    value: _notifItinerary,
                    onChanged: (v) {
                      setDlgState(() => _notifItinerary = v);
                      setState(() {});
                    },
                  ),
                  SwitchListTile(
                    activeColor: AppColors.emerald,
                    title: const Text('Promo & Penawaran Hotel', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    subtitle: const Text('Info harga diskon spesial daerah Jogja', style: TextStyle(fontSize: 11)),
                    value: _notifPromo,
                    onChanged: (v) {
                      setDlgState(() => _notifPromo = v);
                      setState(() {});
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Tutup', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700))),
              ],
            );
          },
        );
      },
    );
  }

  // ─── 6. Language Dialog ───────────────────────────────────────────────────
  void _showLanguageDialog() {
    final languages = ['Bahasa Indonesia', 'English (US)'];
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Text('Pilih Bahasa / Language', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w700)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: languages.map((lang) {
              final isSel = _currentLanguage == lang;
              return ListTile(
                title: Text(lang, style: TextStyle(fontWeight: isSel ? FontWeight.w700 : FontWeight.w500, color: isSel ? AppColors.emerald : AppColors.grey900)),
                trailing: isSel ? const Icon(Icons.check_circle_rounded, color: AppColors.emerald) : null,
                onTap: () {
                  setState(() => _currentLanguage = lang);
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Bahasa diubah ke $lang'), backgroundColor: AppColors.emerald),
                  );
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  // ─── 7. Security Sheet ────────────────────────────────────────────────────
  void _showSecuritySheet() {
    final passCtrl = TextEditingController();
    final newPassCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.grey400, borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 16),
              const Text('Ubah Kata Sandi', style: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              TextField(
                controller: passCtrl,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Kata Sandi Lama', prefixIcon: const Icon(Icons.lock_outline), border: OutlineInputBorder(borderRadius: BorderRadius.circular(14))),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: newPassCtrl,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Kata Sandi Baru (Min. 6 Karakter)', prefixIcon: const Icon(Icons.lock_reset_outlined), border: OutlineInputBorder(borderRadius: BorderRadius.circular(14))),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Kata sandi berhasil diperbarui! 🔒'), backgroundColor: AppColors.emerald),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, minimumSize: const Size(double.infinity, 48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
                child: const Text('Update Kata Sandi'),
              ),
            ],
          ),
        );
      },
    );
  }

  // ─── 8. FAQ Dialog ────────────────────────────────────────────────────────
  void _showFaqDialog() {
    final faqs = [
      {'q': 'Bagaimana cara AI Trip Planner bekerja?', 'a': 'AI Stay Jogja menyaring atraksi terkurasi di Yogyakarta berdasarkan hotel pilihanmu, lalu menghitung rute efisien per hari.'},
      {'q': 'Apakah booking hotel bisa dibatalkan?', 'a': 'Kebijakan pembatalan bergantung pada masing-masing tipe kamar yang kamu pilih, sebagian besar memiliki opsi free cancellation.'},
      {'q': 'Kapan saya menerima E-Voucher?', 'a': 'E-voucher diterbitkan otomatis seketika setelah pembayaran terkonfirmasi dan dapat diakses secara offline.'},
    ];

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Text('Pusat Bantuan & FAQ', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w700)),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: faqs.length,
              separatorBuilder: (_, __) => const Divider(height: 20),
              itemBuilder: (_, i) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(faqs[i]['q']!, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                    const SizedBox(height: 4),
                    Text(faqs[i]['a']!, style: const TextStyle(fontSize: 11.5, color: AppColors.grey600, height: 1.4)),
                  ],
                );
              },
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Tutup', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700))),
          ],
        );
      },
    );
  }

  // ─── 9. Contact Support ───────────────────────────────────────────────────
  void _contactSupport() async {
    final uri = Uri.parse('https://wa.me/6281234567890?text=Halo%20Layanan%20Stay%20Jogja%2C%20saya%20butuh%20bantuan');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hubungi Layanan CS Stay Jogja: +62 812-3456-7890')),
        );
      }
    }
  }

  // ─── 10. Privacy Policy (UU PDP) ──────────────────────────────────────────
  void _showPrivacyPolicyDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Text('Kepatuhan Privasi (UU PDP)', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w700)),
          content: const SingleChildScrollView(
            child: Text(
              'Stay Jogja berkomitmen penuh mematuhi Undang-Undang Pelindungan Data Pribadi (UU PDP No. 27 Tahun 2022).\n\n'
              '1. Data Pribadi yang Dikumpulkan: Nama, email, nomor telepon, dan preferensi perjalanan.\n\n'
              '2. Penggunaan Data: Hanya digunakan untuk memproses reservasi hotel, penerbitan e-voucher, dan pembuatan rencana perjalanan AI.\n\n'
              '3. Hak Pengguna: Anda berhak memperbarui data, menarik persetujuan, atau meminta penghapusan akun dan seluruh riwayat Anda kapan saja.',
              style: TextStyle(fontSize: 12, color: AppColors.grey800, height: 1.5),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Saya Mengerti', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700))),
          ],
        );
      },
    );
  }

  // ─── 11. Delete Account Dialog ────────────────────────────────────────────
  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Text('Hapus Akun & Data?', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.error)),
          content: const Text(
            'Tindakan ini tidak dapat dibatalkan. Seluruh riwayat pemesanan hotel, e-voucher, dan itinerary AI Anda akan dihapus permanen sesuai ketentuan UU PDP.',
            style: TextStyle(fontSize: 12, color: AppColors.grey600, height: 1.5),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal', style: TextStyle(color: AppColors.grey600))),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                context.go(AppRoutes.login);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Akun Anda telah berhasil dihapus.'), backgroundColor: AppColors.error),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
              child: const Text('Ya, Hapus Akun'),
            ),
          ],
        );
      },
    );
  }

  // ─── 12. Logout Dialog ────────────────────────────────────────────────────
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Text('Keluar dari Akun', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w700)),
          content: const Text('Apakah Anda yakin ingin keluar dari akun Stay Jogja?', style: TextStyle(fontSize: 13, color: AppColors.grey600)),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal', style: TextStyle(color: AppColors.grey600))),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                context.go(AppRoutes.login);
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: const Text('Keluar'),
            ),
          ],
        );
      },
    );
  }
}
