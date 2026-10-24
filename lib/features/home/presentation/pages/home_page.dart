import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:stayjogja_flutter/core/theme/app_theme.dart';
import 'package:stayjogja_flutter/core/constants/app_constants.dart';
import 'package:stayjogja_flutter/core/widgets/skeleton_loading.dart';
import 'package:stayjogja_flutter/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:stayjogja_flutter/features/hotel/domain/entities/hotel.dart';
import 'package:stayjogja_flutter/features/hotel/presentation/bloc/hotel_cubit.dart';
import 'package:stayjogja_flutter/features/profile/presentation/widgets/ktp_verification_sheet.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // ─── Header: Hi, [User Name] 👋 + Notif button ───────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, authState) {
                      String greetingName = 'Traveler';
                      if (authState is Authenticated) {
                        greetingName = authState.user.name.split(' ').first;
                      }
                      return Text(
                        'Hi, $greetingName 👋',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.grey900,
                          letterSpacing: -0.5,
                        ),
                      );
                    },
                  ),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.notifications_none_rounded, size: 22, color: AppColors.grey900),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ─── Search Pill Bar (khas mockup) ─────────────────────────
              GestureDetector(
                onTap: () => context.go(AppRoutes.search),
                child: Container(
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  child: Row(
                    children: [
                      const Icon(Icons.search_rounded, color: AppColors.grey800, size: 22),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Where do you want to stay?',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            color: AppColors.grey400,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.grey100,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.tune_rounded, size: 16, color: AppColors.grey800),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ─── Rekomendasi Verifikasi KTP (Check-in Instan & Paperless) ──
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, authState) {
                  final isVerified = authState is Authenticated && authState.user.isKtpVerified;
                  final userName = authState is Authenticated ? authState.user.name : 'Traveler';
                  final nik = authState is Authenticated ? authState.user.nik : null;
                  final ktpPhoto = authState is Authenticated ? authState.user.ktpPhoto : null;

                  if (isVerified) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFBBF7D0)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: AppColors.emeraldLight,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.verified_user_rounded, color: AppColors.emerald, size: 20),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'KTP Terverifikasi Resmi',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.grey900,
                                  ),
                                ),
                                Text(
                                  'Check-in cepat langsung scan QR di resepsionis',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 10,
                                    color: AppColors.grey600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.emerald,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'AKTIF',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // Jika belum terverifikasi: Tampilkan Banner Rekomendasi Estetik
                  return Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                          ),
                          child: const Icon(Icons.badge_rounded, color: Colors.amberAccent, size: 26),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Verifikasi KTP Mandiri',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Check-in hotel instan tanpa antre fotokopi fisik',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 10.5,
                                  color: Colors.white.withValues(alpha: 0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => KtpVerificationSheet.show(
                            context,
                            currentUserName: userName,
                            currentNik: nik,
                            currentKtpPhoto: ktpPhoto,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.emerald,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Verifikasi',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // ─── Hero Promo Card: Escape The Ordinary ──────────────────
              GestureDetector(
                onTap: () => context.go(AppRoutes.search),
                child: Container(
                  height: 230,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Image villa malam
                        CachedNetworkImage(
                          imageUrl:
                              'https://images.unsplash.com/photo-1540541338287-41700207dee6?w=900&auto=format&fit=crop',
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(color: AppColors.grey200),
                          errorWidget: (_, __, ___ ) => Container(
                            color: AppColors.grey200,
                            child: const Icon(Icons.hotel_rounded, size: 60, color: AppColors.grey400),
                          ),
                        ),
                        // Dark overlay gradient
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.2),
                                Colors.black.withValues(alpha: 0.75),
                              ],
                            ),
                          ),
                        ),
                        // Content Center-Bottom
                        Positioned(
                          left: 20,
                          right: 20,
                          bottom: 24,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Escape The Ordinary',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.white,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Find exclusive hotel deals in Yogyakarta',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  color: AppColors.white.withValues(alpha: 0.85),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 14),
                              // Frosted pill button
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.25),
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
                                ),
                                child: const Text(
                                  'Explore Now',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ─── Featured Offers Header ────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Featured Offers',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.grey900,
                      letterSpacing: -0.3,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.search),
                    child: const Text(
                      'View all',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.emerald,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // ─── Horizontal Cards from Cloud Firestore ─────────────────
              SizedBox(
                height: 245,
                child: BlocBuilder<HotelCubit, HotelState>(
                  builder: (context, state) {
                    if (state is HotelLoading) {
                      return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        clipBehavior: Clip.none,
                        itemCount: 3,
                        separatorBuilder: (_, __) => const SizedBox(width: 16),
                        itemBuilder: (_, __) => const FeaturedHotelSkeleton(),
                      );
                    }

                    List<Hotel> hotels = [];
                    if (state is HotelLoaded) {
                      hotels = state.hotels;
                    }

                    if (hotels.isEmpty) {
                      return const Center(
                        child: Text(
                          'Memuat hotel dari Firestore...',
                          style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.grey600),
                        ),
                      );
                    }

                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      itemCount: hotels.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 16),
                      itemBuilder: (context, i) {
                        final h = hotels[i];
                        return GestureDetector(
                          onTap: () => context.push('/hotel/${h.id}'),
                          child: Container(
                            width: 220,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 14,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Foto dengan emerald price badge
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                      child: CachedNetworkImage(
                                        imageUrl: h.images.isNotEmpty ? h.images.first : '',
                                        height: 145,
                                        width: 220,
                                        fit: BoxFit.cover,
                                        placeholder: (_, __) => Container(color: AppColors.grey100),
                                        errorWidget: (_, __, ___) => Container(color: AppColors.grey200),
                                      ),
                                    ),
                                    // Badge harga emerald hijau di pojok kanan atas
                                    Positioned(
                                      top: 10,
                                      right: 10,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: AppColors.emerald,
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Text(
                                          'Rp ${_formatK(h.startingPrice)}/night',
                                          style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        h.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.grey900,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        '${h.area} • Jogja Heritage',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 11,
                                          color: AppColors.grey600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 28),

              // ─── AI Trip Planner Banner Khas Stay Jogja ────────────────
              GestureDetector(
                onTap: () => context.push('${AppRoutes.itineraryPreference}?hotelId=htl-1'),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.emerald.withValues(alpha: 0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.emeraldLight,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.auto_awesome, color: AppColors.emerald, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'AI Trip Planner Jogja ✨',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.grey900,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Rute wisata harian otomatis dari hotelmu',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 11,
                                color: AppColors.grey600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Buat',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 110), // Safe space for floating glass navbar
            ],
          ),
        ),
      ),
    );
  }

  static String _formatK(int price) {
    if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(0)}k';
    }
    return price.toString();
  }
}
