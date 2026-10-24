import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:stayjogja_flutter/core/theme/app_theme.dart';
import 'package:stayjogja_flutter/core/theme/language_cubit.dart';
import 'package:stayjogja_flutter/core/constants/app_constants.dart';
import 'package:stayjogja_flutter/core/constants/mock_data.dart';
import 'package:stayjogja_flutter/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:stayjogja_flutter/features/profile/presentation/widgets/ktp_verification_sheet.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _userName = 'Raynor';
  String _userEmail = 'raynormuhammad19@gmail.com';
  String _userPhone = '+62 812-3456-7890';
  bool _notifBooking = true;
  bool _notifPromo = true;
  bool _notifItinerary = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, AppLanguage>(
      builder: (context, currentLang) {
        final isId = currentLang == AppLanguage.indonesian;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 110),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isId ? 'Akun Saya' : 'My Account',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.grey900,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ─── User Profile Card (Dinamis dari Firestore via AuthCubit) ──
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, authState) {
                      String displayName = _userName;
                      String displayEmail = _userEmail;
                      String displayPhone = _userPhone;
                      bool isVerified = false;
                      String? nik;
                      String? ktpPhoto;

                      if (authState is Authenticated) {
                        displayName = authState.user.name;
                        displayEmail = authState.user.email;
                        displayPhone = authState.user.phoneNumber.isNotEmpty
                            ? authState.user.phoneNumber
                            : _userPhone;
                        isVerified = authState.user.isKtpVerified;
                        nik = authState.user.nik;
                        ktpPhoto = authState.user.ktpPhoto;
                      }

                      return Container(
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
                        child: Column(
                          children: [
                            Row(
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
                                      displayName.isNotEmpty ? displayName[0].toUpperCase() : 'U',
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
                                          Flexible(
                                            child: Text(
                                              displayName,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.grey900,
                                              ),
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
                                        displayEmail,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 12,
                                          color: AppColors.grey600,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        displayPhone,
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
                                  onPressed: () => _showEditProfileSheet(isId, displayName, displayEmail, displayPhone),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Divider(height: 1, color: AppColors.grey100),
                            const SizedBox(height: 12),

                            // ─── Status Verifikasi KTP ───
                            InkWell(
                              onTap: () => KtpVerificationSheet.show(
                                context,
                                currentUserName: displayName,
                                currentNik: nik,
                                currentKtpPhoto: ktpPhoto,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isVerified ? const Color(0xFFF0FDF4) : const Color(0xFFFFFBEB),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isVerified ? const Color(0xFFBBF7D0) : const Color(0xFFFDE68A),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      isVerified ? Icons.verified_user_rounded : Icons.shield_outlined,
                                      size: 18,
                                      color: isVerified ? AppColors.emerald : Colors.amber.shade800,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            isVerified ? 'Identitas Terverifikasi' : 'Belum Verifikasi KTP',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              color: isVerified ? Colors.green.shade900 : Colors.amber.shade900,
                                            ),
                                          ),
                                          Text(
                                            isVerified
                                                ? 'Check-in hotel otomatis & paperless aktif'
                                                : 'Verifikasi KTP sekarang untuk check-in cepat',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 10,
                                              color: isVerified ? Colors.green.shade700 : Colors.amber.shade800,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right_rounded,
                                      size: 18,
                                      color: isVerified ? AppColors.emerald : Colors.amber.shade800,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // ─── Section 1: Aktivitas ──────────────────────────────────
                  _sectionTitle(isId ? 'Aktivitas & Favorit' : 'Activities & Favorites'),
                  const SizedBox(height: 10),
                  _settingsCard([
                    _tile(
                      Icons.favorite_outline_rounded,
                      isId ? 'Wishlist Hotel' : 'Hotel Wishlist',
                      isId ? '3 Hotel disimpan' : '3 Saved Hotels',
                      () => _showWishlistSheet(isId),
                    ),
                    _tile(
                      Icons.rate_review_outlined,
                      isId ? 'Ulasan Saya' : 'My Reviews',
                      isId ? 'Riwayat ulasan hotel & atraksi' : 'Hotel & attraction reviews',
                      () => _showReviewsSheet(isId),
                    ),
                    _tile(
                      Icons.confirmation_number_outlined,
                      isId ? 'Voucher & Promo' : 'Vouchers & Promos',
                      isId ? '2 Kode promo aktif' : '2 Active promo codes',
                      () => _showPromoSheet(isId),
                    ),
                  ]),
                  const SizedBox(height: 20),

                  // ─── Section 2: Pengaturan Aplikasi ────────────────────────
                  _sectionTitle(isId ? 'Pengaturan & Preferensi' : 'Settings & Preferences'),
                  const SizedBox(height: 10),
                  _settingsCard([
                    _tile(
                      Icons.notifications_none_rounded,
                      isId ? 'Notifikasi' : 'Notifications',
                      isId ? 'Pengingat check-in & promo' : 'Check-in reminders & promos',
                      () => _showNotificationsDialog(isId),
                    ),
                    _tile(
                      Icons.language_rounded,
                      isId ? 'Bahasa' : 'Language',
                      currentLang.displayName,
                      () => _showLanguageDialog(currentLang),
                    ),
                    _tile(
                      Icons.badge_outlined,
                      isId ? 'Verifikasi Identitas (KTP)' : 'Identity Verification (KTP)',
                      isId ? 'Unggah KTP untuk check-in instan' : 'Upload KTP for instant check-in',
                      () {
                        final authState = context.read<AuthCubit>().state;
                        String currentName = _userName;
                        String? nik;
                        String? ktpPhoto;
                        if (authState is Authenticated) {
                          currentName = authState.user.name;
                          nik = authState.user.nik;
                          ktpPhoto = authState.user.ktpPhoto;
                        }
                        KtpVerificationSheet.show(
                          context,
                          currentUserName: currentName,
                          currentNik: nik,
                          currentKtpPhoto: ktpPhoto,
                        );
                      },
                    ),
                    _tile(
                      Icons.security_rounded,
                      isId ? 'Keamanan & Sandi' : 'Security & Password',
                      isId ? 'Ubah kata sandi & PIN' : 'Change password & PIN',
                      () => _showSecuritySheet(isId),
                    ),
                  ]),
                  const SizedBox(height: 20),

                  // ─── Section 3: Bantuan & Legalitas (UU PDP) ────────────────
                  _sectionTitle(isId ? 'Dukungan & Privasi' : 'Support & Privacy'),
                  const SizedBox(height: 10),
                  _settingsCard([
                    _tile(
                      Icons.help_center_outlined,
                      isId ? 'Pusat Bantuan & FAQ' : 'Help Center & FAQ',
                      isId ? 'Solusi kendala booking' : 'Booking assistance & FAQs',
                      () => _showFaqDialog(isId),
                    ),
                    _tile(
                      Icons.phone_in_talk_outlined,
                      isId ? 'Hubungi Layanan Stay Jogja' : 'Contact Stay Jogja Support',
                      isId ? '24/7 CS Yogyakarta' : '24/7 Yogyakarta CS',
                      _contactSupport,
                    ),
                    _tile(
                      Icons.shield_outlined,
                      isId ? 'Kebijakan Privasi (UU PDP)' : 'Privacy Policy (PDP Law)',
                      isId ? 'Kepatuhan pelindungan data pribadi' : 'Personal data protection compliance',
                      () => _showPrivacyPolicyDialog(isId),
                    ),
                    _tile(
                      Icons.delete_outline_rounded,
                      isId ? 'Hapus Akun' : 'Delete Account',
                      isId ? 'Penghapusan data pribadi permanen' : 'Permanent personal data deletion',
                      () => _showDeleteAccountDialog(isId),
                      isDestructive: true,
                    ),
                  ]),
                  const SizedBox(height: 24),

                  // Logout Button
                  Center(
                    child: TextButton.icon(
                      onPressed: () => _showLogoutDialog(isId),
                      icon: const Icon(Icons.logout_rounded, size: 18, color: AppColors.error),
                      label: Text(
                        isId ? 'Keluar dari Akun' : 'Log Out',
                        style: const TextStyle(
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
      },
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
  void _showEditProfileSheet(bool isId, String initName, String initEmail, String initPhone) {
    final nameCtrl = TextEditingController(text: initName);
    final emailCtrl = TextEditingController(text: initEmail);
    final phoneCtrl = TextEditingController(text: initPhone);

    showModalBottomSheet(
      context: context,
      useRootNavigator: true, // Tampil di atas floating navigation bar
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + MediaQuery.of(ctx).padding.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.grey400, borderRadius: BorderRadius.circular(2))),
              ),
              const SizedBox(height: 16),
              Text(
                isId ? 'Edit Profil Pengguna' : 'Edit User Profile',
                style: const TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: isId ? 'Nama Lengkap' : 'Full Name',
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
                  labelText: isId ? 'Email' : 'Email Address',
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
                  labelText: isId ? 'Nomor WhatsApp' : 'WhatsApp Number',
                  prefixIcon: const Icon(Icons.phone_outlined),
                  filled: true,
                  fillColor: AppColors.grey50,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final newName = nameCtrl.text.trim();
                  final newEmail = emailCtrl.text.trim();
                  final newPhone = phoneCtrl.text.trim();

                  setState(() {
                    _userName = newName;
                    _userEmail = newEmail;
                    _userPhone = newPhone;
                  });

                  // Update reaktif ke AuthCubit & Cloud Firestore langsung
                  context.read<AuthCubit>().updateProfile(
                    name: newName,
                    email: newEmail,
                    phone: newPhone,
                  );

                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isId ? 'Profil tersimpan ke Cloud Firestore! ✅' : 'Profile saved to Cloud Firestore! ✅'),
                      backgroundColor: AppColors.emerald,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: Text(isId ? 'Simpan Perubahan' : 'Save Changes'),
              ),
            ],
          ),
        );
      },
    );
  }

  // ─── 2. Wishlist Sheet ────────────────────────────────────────────────────
  void _showWishlistSheet(bool isId) {
    final wishlistHotels = MockData.hotels.take(3).toList();
    showModalBottomSheet(
      context: context,
      useRootNavigator: true, // Tampil di atas floating navigation bar
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
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(ctx).padding.bottom + 20,
              ),
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
                      Text(
                        isId ? 'Wishlist Hotel Saya' : 'My Hotel Wishlist',
                        style: const TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        '${wishlistHotels.length} ${isId ? 'Disimpan' : 'Saved'}',
                        style: const TextStyle(fontSize: 12, color: AppColors.emerald, fontWeight: FontWeight.w600),
                      ),
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
                                    Text('Rp ${h.startingPrice ~/ 1000}k/${isId ? 'malam' : 'night'}', style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.emerald, fontSize: 12)),
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
  void _showReviewsSheet(bool isId) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true, // Tampil di atas floating navigation bar
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(ctx).padding.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.grey400, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 16),
              const Icon(Icons.rate_review_outlined, size: 48, color: AppColors.emerald),
              const SizedBox(height: 12),
              Text(
                isId ? 'Ulasan Saya' : 'My Reviews',
                style: const TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                isId
                    ? 'Anda belum menulis ulasan menginap. Ulasan dapat diberikan setelah pesanan Anda berstatus selesai menginap.'
                    : 'You haven\'t submitted any reviews yet. You can leave reviews after your completed stays.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: AppColors.grey600, height: 1.5),
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
                child: Text(isId ? 'Buka Riwayat Booking' : 'Open Booking History'),
              ),
            ],
          ),
        );
      },
    );
  }

  // ─── 4. Promo Vouchers Sheet ──────────────────────────────────────────────
  void _showPromoSheet(bool isId) {
    final promos = isId
        ? [
            {'code': 'STAYJOGJA10', 'title': 'Diskon 10% Semua Hotel Jogja', 'desc': 'Min. transaksi Rp 500.000', 'valid': 'Berlaku s/d 31 Des 2026'},
            {'code': 'AITRIPFREE', 'title': 'Gratis Generate AI Itinerary Unlimited', 'desc': 'Khusus pengguna aplikasi Stay Jogja', 'valid': 'Tanpa batas waktu'},
          ]
        : [
            {'code': 'STAYJOGJA10', 'title': '10% OFF All Jogja Hotels', 'desc': 'Min. spend IDR 500,000', 'valid': 'Valid until 31 Dec 2026'},
            {'code': 'AITRIPFREE', 'title': 'Free Unlimited AI Trip Generator', 'desc': 'Exclusive for Stay Jogja users', 'valid': 'No expiration'},
          ];

    showModalBottomSheet(
      context: context,
      useRootNavigator: true, // Tampil di atas floating navigation bar
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).padding.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.grey400, borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 16),
              Text(
                isId ? 'Voucher & Kode Promo Aktif' : 'Active Vouchers & Promo Codes',
                style: const TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w700),
              ),
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
                            SnackBar(
                              content: Text(isId ? 'Kode ${p['code']} berhasil disalin!' : 'Promo code ${p['code']} copied!'),
                              backgroundColor: AppColors.emerald,
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.emerald,
                          side: const BorderSide(color: AppColors.emerald),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        ),
                        child: Text(isId ? 'Salin' : 'Copy', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
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
  void _showNotificationsDialog(bool isId) {
    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDlgState) {
            return AlertDialog(
              backgroundColor: AppColors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              title: Text(
                isId ? 'Pengaturan Notifikasi' : 'Notification Settings',
                style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w700),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SwitchListTile(
                    activeColor: AppColors.emerald,
                    title: Text(isId ? 'Status Pemesanan' : 'Booking Status', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    subtitle: Text(isId ? 'Notifikasi pembayaran dan konfirmasi e-voucher' : 'Payment updates & e-voucher alerts', style: const TextStyle(fontSize: 11)),
                    value: _notifBooking,
                    onChanged: (v) {
                      setDlgState(() => _notifBooking = v);
                      setState(() {});
                    },
                  ),
                  SwitchListTile(
                    activeColor: AppColors.emerald,
                    title: Text(isId ? 'Pengingat Itinerary Harian' : 'Daily Itinerary Reminders', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    subtitle: Text(isId ? 'Jadwal kunjungan tempat wisata dari hotel' : 'Attraction schedule and travel time', style: const TextStyle(fontSize: 11)),
                    value: _notifItinerary,
                    onChanged: (v) {
                      setDlgState(() => _notifItinerary = v);
                      setState(() {});
                    },
                  ),
                  SwitchListTile(
                    activeColor: AppColors.emerald,
                    title: Text(isId ? 'Promo & Penawaran Hotel' : 'Promos & Hotel Deals', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    subtitle: Text(isId ? 'Info harga diskon spesial daerah Jogja' : 'Special discounts across Jogja regions', style: const TextStyle(fontSize: 11)),
                    value: _notifPromo,
                    onChanged: (v) {
                      setDlgState(() => _notifPromo = v);
                      setState(() {});
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(isId ? 'Tutup' : 'Close', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ─── 6. Language Dialog (Directly switches app-wide state) ────────────────
  void _showLanguageDialog(AppLanguage activeLang) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Text('Pilih Bahasa / Language', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w700)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: AppLanguage.values.map((lang) {
              final isSel = activeLang == lang;
              return ListTile(
                title: Text(
                  lang.displayName,
                  style: TextStyle(
                    fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                    color: isSel ? AppColors.emerald : AppColors.grey900,
                  ),
                ),
                trailing: isSel ? const Icon(Icons.check_circle_rounded, color: AppColors.emerald) : null,
                onTap: () {
                  context.read<LanguageCubit>().changeLanguage(lang);
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Language changed to ${lang.displayName}'),
                      backgroundColor: AppColors.emerald,
                    ),
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
  void _showSecuritySheet(bool isId) {
    final passCtrl = TextEditingController();
    final newPassCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      useRootNavigator: true, // Tampil di atas floating navigation bar
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + MediaQuery.of(ctx).padding.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.grey400, borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 16),
              Text(
                isId ? 'Ubah Kata Sandi' : 'Change Password',
                style: const TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passCtrl,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: isId ? 'Kata Sandi Lama' : 'Current Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: newPassCtrl,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: isId ? 'Kata Sandi Baru (Min. 6 Karakter)' : 'New Password (Min. 6 Characters)',
                  prefixIcon: const Icon(Icons.lock_reset_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isId ? 'Kata sandi berhasil diperbarui! 🔒' : 'Password updated successfully! 🔒'),
                      backgroundColor: AppColors.emerald,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: Text(isId ? 'Update Kata Sandi' : 'Update Password'),
              ),
            ],
          ),
        );
      },
    );
  }

  // ─── 8. FAQ Dialog ────────────────────────────────────────────────────────
  void _showFaqDialog(bool isId) {
    final faqs = isId
        ? [
            {'q': 'Bagaimana cara AI Trip Planner bekerja?', 'a': 'AI Stay Jogja menyaring atraksi terkurasi di Yogyakarta berdasarkan hotel pilihanmu, lalu menghitung rute efisien per hari.'},
            {'q': 'Apakah booking hotel bisa dibatalkan?', 'a': 'Kebijakan pembatalan bergantung pada masing-masing tipe kamar yang kamu pilih, sebagian besar memiliki opsi free cancellation.'},
            {'q': 'Kapan saya menerima E-Voucher?', 'a': 'E-voucher diterbitkan otomatis seketika setelah pembayaran terkonfirmasi dan dapat diakses secara offline.'},
          ]
        : [
            {'q': 'How does the AI Trip Planner work?', 'a': 'Stay Jogja AI filters curated attractions based on your chosen hotel location and computes efficient routes per day.'},
            {'q': 'Can I cancel my hotel reservation?', 'a': 'Cancellation policies depend on the chosen room type. Most rooms support free cancellation.'},
            {'q': 'When do I receive my E-Voucher?', 'a': 'E-vouchers are issued immediately upon confirmed payment and can be accessed offline.'},
          ];

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text(
            isId ? 'Pusat Bantuan & FAQ' : 'Help Center & FAQ',
            style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w700),
          ),
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
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(isId ? 'Tutup' : 'Close', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
            ),
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
  void _showPrivacyPolicyDialog(bool isId) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text(
            isId ? 'Kepatuhan Privasi (UU PDP)' : 'Privacy Policy (PDP Law)',
            style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w700),
          ),
          content: SingleChildScrollView(
            child: Text(
              isId
                  ? 'Stay Jogja berkomitmen penuh mematuhi Undang-Undang Pelindungan Data Pribadi (UU PDP No. 27 Tahun 2022).\n\n'
                      '1. Data Pribadi yang Dikumpulkan: Nama, email, nomor telepon, dan preferensi perjalanan.\n\n'
                      '2. Penggunaan Data: Hanya digunakan untuk memproses reservasi hotel, penerbitan e-voucher, dan pembuatan rencana perjalanan AI.\n\n'
                      '3. Hak Pengguna: Anda berhak memperbarui data, menarik persetujuan, atau meminta penghapusan akun dan seluruh riwayat Anda kapan saja.'
                  : 'Stay Jogja is fully compliant with the Indonesian Personal Data Protection Law (UU PDP No. 27 of 2022).\n\n'
                      '1. Collected Data: Name, email address, phone number, and trip preferences.\n\n'
                      '2. Purpose: Used strictly for hotel booking fulfillment, e-voucher generation, and AI trip recommendations.\n\n'
                      '3. Your Rights: You retain the right to update, withdraw consent, or request permanent deletion of your data at any time.',
              style: const TextStyle(fontSize: 12, color: AppColors.grey800, height: 1.5),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(isId ? 'Saya Mengerti' : 'I Understand', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
            ),
          ],
        );
      },
    );
  }

  // ─── 11. Delete Account Dialog ────────────────────────────────────────────
  void _showDeleteAccountDialog(bool isId) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text(
            isId ? 'Hapus Akun & Data?' : 'Delete Account & Data?',
            style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.error),
          ),
          content: Text(
            isId
                ? 'Tindakan ini tidak dapat dibatalkan. Seluruh riwayat pemesanan hotel, e-voucher, dan itinerary AI Anda akan dihapus permanen sesuai ketentuan UU PDP.'
                : 'This action cannot be undone. All your bookings, e-vouchers, and saved AI itineraries will be permanently deleted.',
            style: const TextStyle(fontSize: 12, color: AppColors.grey600, height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(isId ? 'Batal' : 'Cancel', style: const TextStyle(color: AppColors.grey600)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                context.go(AppRoutes.login);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isId ? 'Akun Anda telah berhasil dihapus.' : 'Your account has been deleted.'),
                    backgroundColor: AppColors.error,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
              child: Text(isId ? 'Ya, Hapus Akun' : 'Yes, Delete Account'),
            ),
          ],
        );
      },
    );
  }

  // ─── 12. Logout Dialog ────────────────────────────────────────────────────
  void _showLogoutDialog(bool isId) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text(
            isId ? 'Keluar dari Akun' : 'Log Out',
            style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w700),
          ),
          content: Text(
            isId ? 'Apakah Anda yakin ingin keluar dari akun Stay Jogja?' : 'Are you sure you want to log out from Stay Jogja?',
            style: const TextStyle(fontSize: 13, color: AppColors.grey600),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(isId ? 'Batal' : 'Cancel', style: const TextStyle(color: AppColors.grey600)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                context.go(AppRoutes.login);
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: Text(isId ? 'Keluar' : 'Log Out'),
            ),
          ],
        );
      },
    );
  }
}
