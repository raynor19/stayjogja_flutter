import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stayjogja_flutter/core/theme/app_theme.dart';
import 'package:stayjogja_flutter/core/constants/app_constants.dart';
import 'package:stayjogja_flutter/features/itinerary/domain/entities/itinerary.dart';
import 'package:stayjogja_flutter/features/itinerary/presentation/bloc/itinerary_cubit.dart';

class SavedItinerariesPage extends StatelessWidget {
  const SavedItinerariesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Itinerary AI Saya ✨',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.grey900,
                        ),
                      ),
                      Text(
                        'Rencana liburan terkurasi dari Cloud Firestore',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: AppColors.grey600,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.emeraldLight,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.add_rounded, color: AppColors.emerald, size: 24),
                      onPressed: () {
                        context.push('${AppRoutes.itineraryPreference}?hotelId=htl-1');
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // List Itinerary Tersimpan dari Firestore
            Expanded(
              child: BlocBuilder<ItineraryCubit, ItineraryState>(
                builder: (context, state) {
                  if (state is ItineraryGenerating) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.emerald),
                    );
                  }

                  List<TripItinerary> items = [];
                  if (state is SavedItinerariesLoaded) {
                    items = state.itineraries;
                  }

                  if (items.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.map_outlined, size: 56, color: AppColors.grey400),
                          const SizedBox(height: 12),
                          const Text(
                            'Belum ada itinerary tersimpan di Cloud',
                            style: TextStyle(fontFamily: 'Poppins', color: AppColors.grey600, fontSize: 13),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              context.push('${AppRoutes.itineraryPreference}?hotelId=htl-1');
                            },
                            icon: const Icon(Icons.auto_awesome, size: 16),
                            label: const Text('Buat Itinerary Pertama'),
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 110),
                    itemCount: items.length,
                    itemBuilder: (context, i) {
                      final itin = items[i];
                      return _ItineraryCard(
                        title: itin.title,
                        hotelName: itin.hotelName,
                        hotelArea: itin.hotelArea,
                        daysCount: itin.totalDays,
                        spotsCount: itin.totalDays * 3,
                        pace: itin.pace == 'padat' ? 'Padat ⚡' : 'Santai ☕',
                        estimatedCost: itin.totalDays * 65000,
                        onTap: () {
                          context.push(
                            '${AppRoutes.itineraryList}/result?hotelId=htl-1&days=${itin.totalDays}&pace=${itin.pace}',
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ItineraryCard extends StatelessWidget {
  final String title;
  final String hotelName;
  final String hotelArea;
  final int daysCount;
  final int spotsCount;
  final String pace;
  final int estimatedCost;
  final VoidCallback onTap;

  const _ItineraryCard({
    required this.title,
    required this.hotelName,
    required this.hotelArea,
    required this.daysCount,
    required this.spotsCount,
    required this.pace,
    required this.estimatedCost,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.emeraldLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$daysCount Hari • $pace',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.emerald,
                    ),
                  ),
                ),
                const Spacer(),
                const Icon(Icons.auto_awesome, size: 16, color: AppColors.star),
                const SizedBox(width: 4),
                const Text(
                  'Cloud Synced',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.grey900,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.hotel_rounded, size: 14, color: AppColors.grey600),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Basis: $hotelName',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: AppColors.grey600,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.place_outlined, size: 14, color: AppColors.grey800),
                    const SizedBox(width: 4),
                    Text(
                      '$spotsCount Destinasi',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.grey800,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Icon(Icons.confirmation_number_outlined, size: 14, color: AppColors.grey800),
                    const SizedBox(width: 4),
                    Text(
                      'Rp ${_formatPrice(estimatedCost)}',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.emerald,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Buka Rute',
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
          ],
        ),
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
