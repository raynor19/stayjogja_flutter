import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  GoogleMapController? _mapController;
  Hotel? _selectedHotel;
  final Set<Marker> _markers = {};

  // Titik Pusat Kota Yogyakarta (Tugu Jogja)
  static const CameraPosition _initialCamera = CameraPosition(
    target: LatLng(-7.7956, 110.3695),
    zoom: 13.2,
  );

  @override
  void initState() {
    super.initState();
    _buildMarkers();
  }

  void _buildMarkers() {
    List<Hotel> hotelsList = MockData.hotels;
    final hotelState = context.read<HotelCubit>().state;
    if (hotelState is HotelLoaded && hotelState.hotels.isNotEmpty) {
      hotelsList = hotelState.hotels;
    }

    _markers.clear();
    for (final hotel in hotelsList) {
      _markers.add(
        Marker(
          markerId: MarkerId(hotel.id),
          position: LatLng(hotel.latitude, hotel.longitude),
          infoWindow: InfoWindow(
            title: hotel.name,
            snippet: 'Rp ${_formatK(hotel.startingPrice)}/malam • ★ ${hotel.rating}',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            _selectedHotel?.id == hotel.id
                ? BitmapDescriptor.hueAzure
                : BitmapDescriptor.hueRed,
          ),
          onTap: () {
            setState(() {
              _selectedHotel = hotel;
            });
            _animateToHotel(hotel);
          },
        ),
      );
    }
  }

  void _animateToHotel(Hotel hotel) {
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(hotel.latitude - 0.003, hotel.longitude), // offset sedikit agar tidak tertutup kartu
            zoom: 15.0,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Hotel> hotelsList = MockData.hotels;
    final hotelState = context.read<HotelCubit>().state;
    if (hotelState is HotelLoaded && hotelState.hotels.isNotEmpty) {
      hotelsList = hotelState.hotels;
    }

    // Default hotel yang terpilih pertama kali
    _selectedHotel ??= hotelsList.first;

    return Scaffold(
      body: Stack(
        children: [
          // ─── 1. Peta Interaktif Google Maps ────────────────────────
          GoogleMap(
            initialCameraPosition: _initialCamera,
            markers: _markers,
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            compassEnabled: true,
            onMapCreated: (controller) {
              _mapController = controller;
              if (_selectedHotel != null) {
                _animateToHotel(_selectedHotel!);
              }
            },
            onTap: (_) {
              // Tap area kosong di peta
            },
          ),

          // ─── 2. Top Header Floating Controls ───────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back Button Bulat Putih
                  Container(
                    width: 44,
                    height: 44,
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
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.grey900),
                      onPressed: () => context.pop(),
                    ),
                  ),

                  // Pill Judul Peta & Hotel Terdeteksi
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(24),
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
                        const Icon(Icons.place_rounded, size: 16, color: AppColors.emerald),
                        const SizedBox(width: 6),
                        Text(
                          'Peta Hotel DIY (${hotelsList.length} Lokasi)',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.grey900,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Tombol Reset / Pusatkan ke Malioboro
                  Container(
                    width: 44,
                    height: 44,
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
                      icon: const Icon(Icons.my_location_rounded, size: 20, color: AppColors.emerald),
                      tooltip: 'Pusatkan ke Malioboro',
                      onPressed: () {
                        if (_mapController != null) {
                          _mapController!.animateCamera(
                            CameraUpdate.newCameraPosition(_initialCamera),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ─── 3. Floating Hotel Preview Card di Bawah Layar ─────────
          if (_selectedHotel != null)
            Positioned(
              left: 16,
              right: 16,
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
                        color: Colors.black.withValues(alpha: 0.18),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Foto Thumbnail
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: CachedNetworkImage(
                              imageUrl: _selectedHotel!.images.first,
                              width: 86,
                              height: 86,
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
