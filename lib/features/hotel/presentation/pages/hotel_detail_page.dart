import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:stayjogja_flutter/core/theme/app_theme.dart';
import 'package:stayjogja_flutter/core/constants/app_constants.dart';
import 'package:stayjogja_flutter/core/constants/mock_data.dart';
import 'package:stayjogja_flutter/core/utils/location_helper.dart';
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Header Image with Back Button & Counter (Screen 3) ───
            Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: hotel.images.first,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(color: AppColors.grey200),
                  errorWidget: (_, __, ___) => Container(color: AppColors.grey200),
                ),
                // Gradient overlay
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.45),
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.50),
                      ],
                    ),
                  ),
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
                // Info Badge di foto
                Positioned(
                  bottom: 16,
                  left: 20,
                  right: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.emerald,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '★ ${hotel.rating} • ${hotel.area}',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '1/${hotel.images.length}',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 11,
                            color: AppColors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
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
                  // Nama Hotel & Alamat
                  Text(
                    hotel.name,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.grey900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 14, color: AppColors.grey600),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          hotel.address,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: AppColors.grey600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // ─── Pinpoint Jarak & Tombol Google Maps ────────────────
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.grey200),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.emeraldLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.explore_outlined, size: 20, color: AppColors.emerald),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                LocationHelper.getPinpointText(
                                  area: hotel.area,
                                  lat: hotel.latitude,
                                  lng: hotel.longitude,
                                ),
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.grey900,
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                '${hotel.latitude.toStringAsFixed(4)}, ${hotel.longitude.toStringAsFixed(4)} (GPS Presisi)',
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 10,
                                  color: AppColors.grey600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.map_rounded, color: AppColors.emerald, size: 22),
                          tooltip: 'Buka di Google Maps',
                          onPressed: () async {
                            final url = LocationHelper.getGoogleMapsUrl(
                              lat: hotel.latitude,
                              lng: hotel.longitude,
                              placeName: hotel.name,
                            );
                            final uri = Uri.parse(url);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri, mode: LaunchMode.externalApplication);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // ─── 3 Amenities Box Grid (Mockup exact) ─────────────
                  Row(
                    children: [
                      _amenityBox(icon: Icons.wifi_rounded, label: 'Free Wi-Fi'),
                      const SizedBox(width: 12),
                      _amenityBox(icon: Icons.pool_rounded, label: 'Pool & Spa'),
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
                  const SizedBox(height: 24),

                  // Tentang Hotel & Deskripsi Lengkap
                  const Text(
                    'Tentang Properti',
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    hotel.description,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12.5,
                      color: AppColors.grey800,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Fasilitas Populer Chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: hotel.facilities.map((f) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.grey100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.grey200),
                        ),
                        child: Text(
                          f,
                          style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: AppColors.grey800),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 28),

                  // ─── Pilihan Tipe Kamar Detail (Agoda/Tiket.com Style) ───
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Pilihan Kamar Tersedia',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        '${hotel.rooms.length} Tipe Kamar',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.emerald,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Render seluruh kamar detail
                  ...hotel.rooms.map((r) => _DetailedRoomCard(hotel: hotel, room: r)),

                  const SizedBox(height: 20),

                  // ─── Kebijakan Hotel ─────────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.grey200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.info_outline_rounded, size: 16, color: AppColors.grey800),
                            SizedBox(width: 6),
                            Text(
                              'Kebijakan Hotel & Check-in',
                              style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          hotel.policy,
                          style: const TextStyle(fontFamily: 'Poppins', fontSize: 11.5, color: AppColors.grey600, height: 1.5),
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

// ── Detailed Room Card Component (Kamar Super Detail) ───────────────────────
class _DetailedRoomCard extends StatelessWidget {
  final Hotel hotel;
  final RoomType room;

  const _DetailedRoomCard({required this.hotel, required this.room});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
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
          // Nama Kamar & Badge Stok
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  room.name,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.grey900,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.badgeOrangeBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Sisa ${room.stock} kamar!',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.badgeOrangeText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            room.description,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11.5,
              color: AppColors.grey600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),

          // Detail Fasilitas Kamar Chips (m², bed, bathtub, dll)
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: room.facilities.map((fac) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.grey50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.grey200),
                ),
                child: Text(
                  fac,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 10.5,
                    color: AppColors.grey800,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),

          // Kebijakan & Sarapan Status
          Row(
            children: [
              Icon(
                room.hasBreakfast ? Icons.check_circle_outline_rounded : Icons.info_outline_rounded,
                size: 14,
                color: room.hasBreakfast ? AppColors.emerald : AppColors.grey600,
              ),
              const SizedBox(width: 4),
              Text(
                room.hasBreakfast ? 'Sarapan Termasuk' : 'Tanpa Sarapan',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: room.hasBreakfast ? AppColors.emerald : AppColors.grey600,
                ),
              ),
              const Spacer(),
              const Icon(Icons.verified_user_outlined, size: 13, color: AppColors.emerald),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  room.cancellationPolicy,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontFamily: 'Poppins', fontSize: 10.5, color: AppColors.emerald),
                ),
              ),
            ],
          ),
          const Divider(height: 24),

          // Harga & Tombol Book Room
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rp ${_formatPrice(room.originalPrice)}',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      decoration: TextDecoration.lineThrough,
                      color: AppColors.grey400,
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Rp ${_formatPrice(room.pricePerNight)}',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.grey900,
                          ),
                        ),
                        const TextSpan(
                          text: '/malam',
                          style: TextStyle(
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
              ElevatedButton(
                onPressed: () {
                  context.push('${AppRoutes.checkout}?hotelId=${hotel.id}&roomId=${room.id}');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text(
                  'Book Room',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600),
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
