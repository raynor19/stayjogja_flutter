import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:stayjogja_flutter/core/theme/app_theme.dart';
import 'package:stayjogja_flutter/core/constants/mock_data.dart';
import 'package:stayjogja_flutter/core/utils/location_helper.dart';
import 'package:stayjogja_flutter/core/utils/date_helper.dart';
import 'package:stayjogja_flutter/features/hotel/domain/entities/hotel.dart';
import 'package:stayjogja_flutter/features/hotel/presentation/bloc/hotel_cubit.dart';

class HotelMapSearchPage extends StatefulWidget {
  final DateTime checkIn;
  final DateTime checkOut;

  const HotelMapSearchPage({
    super.key,
    required this.checkIn,
    required this.checkOut,
  });

  @override
  State<HotelMapSearchPage> createState() => _HotelMapSearchPageState();
}

class _HotelMapSearchPageState extends State<HotelMapSearchPage> {
  Hotel? _selectedHotel;
  String _selectedArea = 'Semua';

  final List<String> _areas = [
    'Semua',
    'Malioboro',
    'Kraton',
    'Prawirotaman',
    'Kotagede',
    'Kaliurang',
    'Sleman',
    'Bantul',
    'Gunungkidul',
  ];

  @override
  Widget build(BuildContext context) {
    List<Hotel> allHotels = MockData.hotels;
    final hotelState = context.read<HotelCubit>().state;
    if (hotelState is HotelLoaded && hotelState.hotels.isNotEmpty) {
      allHotels = hotelState.hotels;
    }

    // Filter berdasarkan area yang dipilih di peta
    final filteredHotels = _selectedArea == 'Semua'
        ? allHotels
        : allHotels.where((h) => h.area.toLowerCase().contains(_selectedArea.toLowerCase())).toList();

    _selectedHotel ??= filteredHotels.isNotEmpty ? filteredHotels.first : allHotels.first;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Dark luxury map canvas
      body: Stack(
        children: [
          // ─── 1. Interactive Radar Map Grid Canvas (100% Anti-Crash) ──
          CustomPaint(
            size: Size.infinite,
            painter: _YogyakartaMapGridPainter(),
          ),

          // ─── 2. Interactive Hotel Coordinate Pins ───────────────────
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final w = constraints.maxWidth;
                final h = constraints.maxHeight;

                // Batas Koordinat DIY (Bounding Box Jogja)
                // Lat: -7.55 (Merapi/Utara) s/d -8.10 (Pantai/Selatan)
                // Lng: 110.15 (Kulon Progo/Barat) s/d 110.65 (Gunungkidul/Timur)
                const minLat = -8.15;
                const maxLat = -7.55;
                const minLng = 110.15;
                const maxLng = 110.65;

                return Stack(
                  children: [
                    // Titik Nol Km / Tugu Center Marker
                    Positioned(
                      left: w * (110.3695 - minLng) / (maxLng - minLng) - 20,
                      top: h * (maxLat - (-7.7956)) / (maxLat - minLat) - 20,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade900.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.amberAccent, width: 1.5),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star_rounded, size: 12, color: Colors.amberAccent),
                            SizedBox(width: 3),
                            Text('Tugu Jogja', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.white)),
                          ],
                        ),
                      ),
                    ),

                    // Pins Hotel Dinamis
                    ...filteredHotels.map((hotel) {
                      final isSelected = _selectedHotel?.id == hotel.id;

                      // Normalisasi koordinat ke posisi piksel layar
                      final normX = ((hotel.longitude - minLng) / (maxLng - minLng)).clamp(0.08, 0.92);
                      final normY = ((maxLat - hotel.latitude) / (maxLat - minLat)).clamp(0.18, 0.70);

                      final posX = normX * w - 38;
                      final posY = normY * h - 18;

                      return Positioned(
                        left: posX,
                        top: posY,
                        child: GestureDetector(
                          onTap: () {
                            setState(() => _selectedHotel = hotel);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: EdgeInsets.symmetric(
                              horizontal: isSelected ? 10 : 8,
                              vertical: isSelected ? 6 : 4,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.emerald : const Color(0xFF1E293B),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? Colors.white : AppColors.emerald.withValues(alpha: 0.6),
                                width: isSelected ? 2 : 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: isSelected
                                      ? AppColors.emerald.withValues(alpha: 0.5)
                                      : Colors.black.withValues(alpha: 0.3),
                                  blurRadius: isSelected ? 12 : 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.hotel_rounded,
                                  size: isSelected ? 13 : 11,
                                  color: isSelected ? Colors.white : AppColors.emerald,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _formatK(hotel.startingPrice),
                                  style: TextStyle(
                                    fontSize: isSelected ? 11 : 9.5,
                                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                );
              },
            ),
          ),

          // ─── 3. Top Floating Navigation & Area Filter Pills ─────────
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: Colors.white),
                          onPressed: () => context.pop(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E293B),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.map_rounded, size: 16, color: AppColors.emerald),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Peta Hotel DIY • ${filteredHotels.length} Hotel',
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Area Filter Pills Horisontal
                SizedBox(
                  height: 38,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    scrollDirection: Axis.horizontal,
                    itemCount: _areas.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, i) {
                      final area = _areas[i];
                      final isSel = _selectedArea == area;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedArea = area;
                            _selectedHotel = null; // reset
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSel ? AppColors.emerald : const Color(0xFF1E293B).withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: isSel ? AppColors.emerald : Colors.white.withValues(alpha: 0.15),
                            ),
                          ),
                          child: Text(
                            area,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                              color: isSel ? Colors.white : Colors.white70,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // ─── 4. Floating Hotel Preview Card di Bawah Layar ─────────
          if (_selectedHotel != null)
            Positioned(
              left: 18,
              right: 18,
              bottom: 24,
              child: SafeArea(
                top: false,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.35),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: CachedNetworkImage(
                              imageUrl: _selectedHotel!.images.first,
                              width: 84,
                              height: 84,
                              fit: BoxFit.cover,
                              placeholder: (_, __) => Container(color: AppColors.grey200),
                              errorWidget: (_, __, ___) => Container(color: AppColors.grey200),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    ...List.generate(
                                      _selectedHotel!.star,
                                      (_) => const Icon(Icons.star_rounded, size: 14, color: AppColors.star),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '${_selectedHotel!.rating} (${_selectedHotel!.totalReviews})',
                                      style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: AppColors.grey600),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _selectedHotel!.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: AppColors.grey900,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  LocationHelper.getPinpointText(
                                    area: _selectedHotel!.area,
                                    lat: _selectedHotel!.latitude,
                                    lng: _selectedHotel!.longitude,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 11, color: AppColors.grey600),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Rp ${_formatPrice(_selectedHotel!.startingPrice)}/malam',
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w800,
                                    fontSize: 13,
                                    color: AppColors.emerald,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                final url = LocationHelper.getGoogleMapsUrl(
                                  lat: _selectedHotel!.latitude,
                                  lng: _selectedHotel!.longitude,
                                  placeName: _selectedHotel!.name,
                                );
                                LocationHelper.launchMapUrl(url);
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.grey800,
                                side: const BorderSide(color: AppColors.grey200),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.directions_outlined, size: 16),
                                  SizedBox(width: 6),
                                  Text('Arah Peta', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: () {
                                final cinStr = DateHelper.formatDate(widget.checkIn);
                                final coutStr = DateHelper.formatDate(widget.checkOut);
                                context.push(
                                  '/hotel/${_selectedHotel!.id}?cin=${Uri.encodeComponent(cinStr)}&cout=${Uri.encodeComponent(coutStr)}',
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Lihat Kamar & Pesan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                                  SizedBox(width: 6),
                                  Icon(Icons.arrow_forward_rounded, size: 16),
                                ],
                              ),
                            ),
                          ),
                        ],
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

  static String _formatK(int price) {
    if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(0)}k';
    }
    return price.toString();
  }

  static String _formatPrice(int price) {
    return price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
  }
}

// ─── Custom Canvas Painter: Peta Kontur & Grid Yogyakarta ───────────────────
class _YogyakartaMapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFF0F172A);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final linePaint = Paint()
      ..color = const Color(0xFF1E293B)
      ..strokeWidth = 1.0;

    // Grid garis horizontal & vertikal
    const step = 45.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }

    // Ilustrasi Jalur Utama Jalan DIY (Ringroad & Jalan Malioboro)
    final roadPaint = Paint()
      ..color = const Color(0xFF334155).withValues(alpha: 0.8)
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke;

    // Ringroad Circle
    final center = Offset(size.width * 0.48, size.height * 0.42);
    canvas.drawOval(
      Rect.fromCenter(center: center, width: size.width * 0.55, height: size.height * 0.35),
      roadPaint,
    );

    // Jalur Utama Malioboro (Vertikal tengah)
    final mainRoadPaint = Paint()
      ..color = const Color(0xFF0284C7).withValues(alpha: 0.5)
      ..strokeWidth = 3.0;
    canvas.drawLine(Offset(center.dx, 40), Offset(center.dx, size.height * 0.75), mainRoadPaint);
    // Jalur Solo - Jogja (Diagonal Timur)
    canvas.drawLine(Offset(center.dx, center.dy), Offset(size.width, center.dy - 60), mainRoadPaint);
    // Jalur Wates (Barat)
    canvas.drawLine(Offset(center.dx, center.dy), Offset(0, center.dy + 80), mainRoadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
