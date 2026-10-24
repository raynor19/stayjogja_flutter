import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
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
  final MapController _mapController = MapController();
  Hotel? _selectedHotel;
  String _selectedArea = 'Semua';

  // Titik Pusat Kota Yogyakarta (Tugu Jogja)
  static const LatLng _centerJogja = LatLng(-7.7956, 110.3695);

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

  void _moveToLocation(double lat, double lng, {double zoom = 15.0}) {
    _mapController.move(LatLng(lat, lng), zoom);
  }

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
      backgroundColor: const Color(0xFFF1F5F9),
      body: Stack(
        children: [
          // ─── 1. Peta Nyata Leaflet (OpenStreetMap Tile Layer) ───────
          FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              initialCenter: _centerJogja,
              initialZoom: 13.5,
              minZoom: 9.0,
              maxZoom: 18.0,
            ),
            children: [
              // OpenStreetMap Standard Tiles (Bebas API Key & Tanpa Limit Biaya)
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.stayjogja.stayjogjaFlutter',
                maxZoom: 19,
              ),

              // Pin Marker Pusat Tugu Jogja
              MarkerLayer(
                markers: [
                  Marker(
                    point: _centerJogja,
                    width: 90,
                    height: 40,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade900,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.amberAccent, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star_rounded, size: 14, color: Colors.amberAccent),
                          SizedBox(width: 4),
                          Text('Tugu Jogja', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Marker Layer Hotel dari Firestore (Pill Harga Interaktif)
              MarkerLayer(
                markers: filteredHotels.map((hotel) {
                  final isSelected = _selectedHotel?.id == hotel.id;

                  return Marker(
                    point: LatLng(hotel.latitude, hotel.longitude),
                    width: isSelected ? 100 : 85,
                    height: isSelected ? 50 : 42,
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _selectedHotel = hotel);
                        _moveToLocation(hotel.latitude - 0.003, hotel.longitude, zoom: 15.5);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : AppColors.emerald,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white,
                            width: isSelected ? 2.5 : 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.25),
                              blurRadius: isSelected ? 12 : 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.hotel_rounded,
                              size: isSelected ? 13 : 11,
                              color: isSelected ? AppColors.emerald : Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                _formatK(hotel.startingPrice),
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          // ─── 2. Top Header Navigation & Area Filter ─────────────────
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  child: Row(
                    children: [
                      // Tombol Kembali
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.12),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: AppColors.grey900),
                          onPressed: () => context.pop(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.12),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.explore_rounded, size: 16, color: AppColors.emerald),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Peta DIY • ${filteredHotels.length} Hotel',
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                    color: AppColors.grey900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Tombol Pusatkan ke Tugu Malioboro
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.12),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.my_location_rounded, size: 19, color: AppColors.emerald),
                          tooltip: 'Pusatkan ke Malioboro',
                          onPressed: () {
                            _mapController.move(_centerJogja, 13.5);
                          },
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
                          });
                          // Geser peta otomatis ke koordinat hotel di area tersebut jika ada
                          final matched = allHotels.where((h) => h.area.toLowerCase().contains(area.toLowerCase())).toList();
                          if (matched.isNotEmpty) {
                            setState(() => _selectedHotel = matched.first);
                            _moveToLocation(matched.first.latitude - 0.003, matched.first.longitude, zoom: 14.5);
                          } else if (area == 'Semua') {
                            _mapController.move(_centerJogja, 13.5);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSel ? AppColors.primary : AppColors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            area,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                              color: isSel ? Colors.white : AppColors.grey800,
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

          // ─── 3. Floating Hotel Preview Card di Bawah Layar ─────────
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
                        color: Colors.black.withValues(alpha: 0.22),
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
