import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stayjogja_flutter/core/theme/app_theme.dart';
import 'package:stayjogja_flutter/core/constants/app_constants.dart';
import 'package:stayjogja_flutter/core/constants/mock_data.dart';
import 'package:stayjogja_flutter/features/hotel/domain/entities/hotel.dart';
import 'package:stayjogja_flutter/features/hotel/presentation/bloc/hotel_cubit.dart';
import 'package:stayjogja_flutter/features/itinerary/presentation/bloc/itinerary_cubit.dart';

class ItineraryGeneratePage extends StatefulWidget {
  final String hotelId;
  final int days;
  final String pace;

  const ItineraryGeneratePage({
    super.key,
    required this.hotelId,
    required this.days,
    required this.pace,
  });

  @override
  State<ItineraryGeneratePage> createState() => _ItineraryGeneratePageState();
}

class _ItineraryGeneratePageState extends State<ItineraryGeneratePage> {
  int _currentStep = 0;
  final List<String> _steps = [
    'Menghubungkan ke database atraksi terkurasi Jogja di Cloud Firestore...',
    'Menyaring tempat buka & menghitung jarak rute dari hotel...',
    'Algoritma AI menyusun jadwal aktivitas efisien per hari...',
    'Memvalidasi batas waktu tempuh (≤ 2.5 jam/hari)...',
    'Menyimpan itinerary ke akun Cloud Firestore...',
  ];

  @override
  void initState() {
    super.initState();
    _startGeneration();
  }

  Future<void> _startGeneration() async {
    // 1. Dapatkan hotel target
    Hotel hotel = MockData.hotels.first;
    final hotelState = context.read<HotelCubit>().state;
    if (hotelState is HotelLoaded) {
      hotel = hotelState.hotels.firstWhere(
        (h) => h.id == widget.hotelId,
        orElse: () => hotelState.hotels.first,
      );
    } else {
      hotel = MockData.hotels.firstWhere(
        (h) => h.id == widget.hotelId,
        orElse: () => MockData.hotels.first,
      );
    }

    // 2. Trigger Firestore AI Generator via Cubit
    try {
      context.read<ItineraryCubit>().generateItinerary(
        hotel: hotel,
        daysCount: widget.days,
        pace: widget.pace,
        preferences: ['Budaya', 'Kuliner', 'Wisata Alam'],
      );
    } catch (_) {}

    // 3. Visual progress simulation
    for (int i = 0; i < _steps.length; i++) {
      await Future.delayed(const Duration(milliseconds: 650));
      if (!mounted) return;
      setState(() => _currentStep = i);
    }
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;

    // Navigate to results page
    context.pushReplacement(
      '${AppRoutes.itineraryList}/result?hotelId=${widget.hotelId}&days=${widget.days}&pace=${widget.pace}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated AI Icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.highlight.withValues(alpha: 0.4),
                    width: 2,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.auto_awesome,
                    size: 48,
                    color: AppColors.highlight,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              const Text(
                'AI Sedang Merancang\nPerjalananmu...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Menyusun rute ${widget.days} hari dari Cloud Firestore',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  color: AppColors.white.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 48),

              // Progress Indicator
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: (_currentStep + 1) / _steps.length,
                  backgroundColor: AppColors.white.withValues(alpha: 0.15),
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 24),

              // Step list
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  _steps[_currentStep],
                  key: ValueKey<int>(_currentStep),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    color: AppColors.highlight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
