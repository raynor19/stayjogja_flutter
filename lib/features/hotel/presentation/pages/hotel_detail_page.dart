import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // ─── Header Image with Gradient & Back Button ─────────────
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                backgroundColor: AppColors.primary,
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                    color: AppColors.grey900,
                    onPressed: () => context.pop(),
                  ),
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.bookmark_border_rounded, size: 20),
                      color: AppColors.grey900,
                      onPressed: () {},
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        color: AppColors.primaryLight,
                        child: const Center(
                          child: Icon(Icons.hotel_rounded, size: 80, color: AppColors.white),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.4),
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.6),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        left: 20,
                        right: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.accent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                hotel.badge.isNotEmpty ? hotel.badge : 'Jogja Authentic',
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              hotel.name,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ─── Hotel Details Body ────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Rating & Location
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: AppColors.highlight, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            '${hotel.rating}',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            ' (${hotel.totalReviews} ulasan)',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const Spacer(),
                          const Icon(Icons.location_on, color: AppColors.accent, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            hotel.area,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        hotel.address,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.grey600,
                        ),
                      ),
                      const Divider(height: 32),

                      // ─── AI Itinerary Banner CTA ──────────────────────
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, AppColors.primaryLight],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: const [
                                      Icon(Icons.auto_awesome, color: AppColors.highlight, size: 18),
                                      SizedBox(width: 6),
                                      Text(
                                        'Pembeda Utama Stay Jogja',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.highlight,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'AI Trip Planner Sekitar Hotel',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Susun jadwal wisata otomatis dari hotel ini',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12,
                                      color: AppColors.white.withValues(alpha: 0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: () {
                                context.push(
                                  '${AppRoutes.itineraryPreference}?hotelId=${hotel.id}',
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.accent,
                                minimumSize: const Size(0, 38),
                                padding: const EdgeInsets.symmetric(horizontal: 14),
                              ),
                              child: const Text('Rencanakan', style: TextStyle(fontSize: 12)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Deskripsi
                      Text('Tentang Hotel', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text(
                        hotel.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.grey800,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Fasilitas Populer
                      Text('Fasilitas Populer', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: hotel.facilities.map((f) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.grey200),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.check_circle_outline, size: 16, color: AppColors.success),
                                const SizedBox(width: 6),
                                Text(f, style: Theme.of(context).textTheme.bodySmall),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 28),

                      // ─── Pilihan Kamar ─────────────────────────────────
                      Text('Pilihan Kamar', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 12),
                      ...hotel.rooms.map((room) => _RoomCard(hotel: hotel, room: room)),

                      const SizedBox(height: 100), // spacing for bottom bar
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ─── Bottom Price Bar ──────────────────────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cardShadow,
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Mulai dari',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.grey600,
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Rp ${_formatPrice(hotel.startingPrice)}',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextSpan(
                                text: '/mlm',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        // Pilih kamar pertama default
                        final firstRoom = hotel.rooms.first;
                        context.push(
                          '${AppRoutes.checkout}?hotelId=${hotel.id}&roomId=${firstRoom.id}',
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(140, 48),
                        backgroundColor: AppColors.primary,
                      ),
                      child: const Text('Pilih Kamar'),
                    ),
                  ],
                ),
              ),
            ),
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

// ── Room Card ──────────────────────────────────────────────────────────────
class _RoomCard extends StatelessWidget {
  final Hotel hotel;
  final RoomType room;
  const _RoomCard({required this.hotel, required this.room});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: const Center(
              child: Icon(Icons.bed_rounded, size: 48, color: AppColors.primaryLight),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(room.name, style: Theme.of(context).textTheme.titleMedium),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.grey100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Sisa ${room.stock} kamar',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  room.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.grey600),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: room.facilities.map((f) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.grey50,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.grey200),
                      ),
                      child: Text(f, style: const TextStyle(fontSize: 11)),
                    );
                  }).toList(),
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rp ${_formatPrice(room.originalPrice)}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: AppColors.grey400,
                          ),
                        ),
                        Text(
                          'Rp ${_formatPrice(room.pricePerNight)}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.accent,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.push(
                          '${AppRoutes.checkout}?hotelId=${hotel.id}&roomId=${room.id}',
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        minimumSize: const Size(100, 40),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      child: const Text('Pesan', style: TextStyle(fontSize: 13)),
                    ),
                  ],
                ),
              ],
            ),
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
