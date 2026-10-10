import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:stayjogja_flutter/core/theme/app_theme.dart';
import 'package:stayjogja_flutter/core/constants/app_constants.dart';
import 'package:stayjogja_flutter/core/constants/mock_data.dart';
import 'package:stayjogja_flutter/features/hotel/domain/entities/hotel.dart';

class HotelDetailPage extends StatelessWidget {
  final String hotelId;
  const HotelDetailPage({super.key, required this.hotelId});

  @override
  Widget build(BuildContext context) {
    final hotel = MockData.hotels.firstWhere(
      (h) => h.id == hotelId,
      orElse: () => MockData.hotels.first,
    );
    final room = hotel.rooms.first;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Header Image with Back Button & Counter (Screen 3) ───
            Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: hotel.images.first,
                  height: 290,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(color: AppColors.grey200),
                  errorWidget: (_, __, ___ ) => Container(color: AppColors.grey200),
                ),
                // Back Button Bulat Putih
                Positioned(
                  top: MediaQuery.of(context).padding.top + 10,
                  left: 20,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.grey900),
                      onPressed: () => context.pop(),
                    ),
                  ),
                ),
                // Counter Badge 2/27
                Positioned(
                  bottom: 16,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      '2/27',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        color: AppColors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ─── Content Body ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama Kamar & Kapasitas
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          room.name,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.grey900,
                          ),
                        ),
                      ),
                      const Text(
                        '2 Adults • 1 Child',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: AppColors.grey600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ─── 3 Amenities Box Grid (Mockup exact) ─────────────
                  Row(
                    children: [
                      _amenityBox(icon: Icons.wifi_rounded, label: 'Wi-Fi'),
                      const SizedBox(width: 12),
                      _amenityBox(icon: Icons.coffee_outlined, label: 'Breakfast'),
                      const SizedBox(width: 12),
                      _amenityBox(icon: Icons.local_parking_rounded, label: 'Free Parking'),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ─── AI Itinerary Jogja CTA Card ──────────────────────
                  GestureDetector(
                    onTap: () {
                      context.push('${AppRoutes.itineraryPreference}?hotelId=${hotel.id}');
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.emerald.withValues(alpha: 0.3)),
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
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.emeraldLight,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.auto_awesome, color: AppColors.emerald, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'AI Trip Planner Jogja ✨',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.grey900,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Susun rute wisata dari ${hotel.name}',
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 11,
                                    color: AppColors.grey600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.grey400),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ─── Option 1: Member Exclusive Card (Mockup exact) ──
                  _OfferCard(
                    badgeText: 'Member Exclusive',
                    badgeBg: AppColors.badgeMemberBg,
                    badgeColor: AppColors.badgeMemberText,
                    title: 'Book Now, Pay Later',
                    subtitle: 'Free cancellation available',
                    price: room.pricePerNight,
                    onBook: () {
                      context.push(
                        '${AppRoutes.checkout}?hotelId=${hotel.id}&roomId=${room.id}',
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // ─── Option 2: Best Value Card (Mockup exact) ────────
                  _OfferCard(
                    badgeText: 'Best Value',
                    badgeBg: AppColors.badgeValueBg,
                    badgeColor: AppColors.badgeValueText,
                    title: 'Book Now, Pay Later',
                    subtitle: 'Non-Refundable',
                    price: (room.pricePerNight * 0.85).round(),
                    onBook: () {
                      context.push(
                        '${AppRoutes.checkout}?hotelId=${hotel.id}&roomId=${room.id}',
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // ─── Policy Footer (Mockup exact) ────────────────────
                  Center(
                    child: Column(
                      children: const [
                        Text(
                          'No payment required until check-in',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: AppColors.grey600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Check-in : From 2:00 PM • Check-out : Before 12:00 PM',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 11,
                            color: AppColors.grey400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _amenityBox({required IconData icon, required String label}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 24, color: AppColors.emerald),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.grey800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Offer Card (Member Exclusive / Best Value) ──────────────────────────────
class _OfferCard extends StatelessWidget {
  final String badgeText;
  final Color badgeBg;
  final Color badgeColor;
  final String title;
  final String subtitle;
  final int price;
  final VoidCallback onBook;

  const _OfferCard({
    required this.badgeText,
    required this.badgeBg,
    required this.badgeColor,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              badgeText,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: badgeColor,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Title & Subtitle
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.grey900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: AppColors.grey600,
            ),
          ),
          const SizedBox(height: 16),

          // Price & Black Pill Book Room Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Rp ${_formatPrice(price)}',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.grey900,
                      ),
                    ),
                    const TextSpan(
                      text: '/night',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: AppColors.grey600,
                      ),
                    ),
                  ],
                ),
              ),

              // Black Pill Button: Book Room
              ElevatedButton(
                onPressed: onBook,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Book Room',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _formatPrice(int price) {
    final s = price.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buffer.write('.');
      buffer.write(s[i]);
    }
    return buffer.toString();
  }
}
