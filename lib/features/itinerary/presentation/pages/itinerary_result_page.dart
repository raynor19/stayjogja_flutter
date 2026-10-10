import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stayjogja_flutter/core/theme/app_theme.dart';
import 'package:stayjogja_flutter/core/constants/app_constants.dart';
import 'package:stayjogja_flutter/core/constants/mock_data.dart';
import 'package:stayjogja_flutter/features/itinerary/domain/entities/itinerary.dart';

class ItineraryResultPage extends StatefulWidget {
  final String hotelId;
  final int days;
  final String pace;

  const ItineraryResultPage({
    super.key,
    required this.hotelId,
    required this.days,
    required this.pace,
  });

  @override
  State<ItineraryResultPage> createState() => _ItineraryResultPageState();
}

class _ItineraryResultPageState extends State<ItineraryResultPage> {
  int _selectedDayIndex = 0;
  late TripItinerary _itinerary;

  @override
  void initState() {
    super.initState();
    final hotel = MockData.hotels.firstWhere(
      (h) => h.id == widget.hotelId,
      orElse: () => MockData.hotels.first,
    );
    _itinerary = MockData.generateMockItinerary(
      hotel: hotel,
      daysCount: widget.days,
      pace: widget.pace,
      preferences: ['Budaya', 'Kuliner'],
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentDay = _itinerary.days[_selectedDayIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Rencana Perjalanan AI'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => context.go(AppRoutes.home),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tautan itinerary berhasil disalin!')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_added_rounded, color: AppColors.accent),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Itinerary tersimpan ke akun!')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // ─── Header Info Card ──────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${_itinerary.totalDays} Hari • ${_itinerary.pace.toUpperCase()}',
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.auto_awesome, size: 14, color: AppColors.accent),
                    const SizedBox(width: 4),
                    const Text(
                      'AI Optimized',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.accent),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Menginap di ${_itinerary.hotelName}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),

                // Day Selector Tabs
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(_itinerary.days.length, (i) {
                      final isSelected = _selectedDayIndex == i;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedDayIndex = i),
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.accent : AppColors.grey100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Hari ${i + 1}',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                              color: isSelected ? AppColors.white : AppColors.grey800,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),

          // ─── Daily Summary Bar (Travel Time & Tickets) ─────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            color: AppColors.grey50,
            child: Row(
              children: [
                const Icon(Icons.directions_car_outlined, size: 16, color: AppColors.grey600),
                const SizedBox(width: 6),
                Text(
                  'Estimasi rute: ${currentDay.totalTravelMinutes} mnt',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const Spacer(),
                const Icon(Icons.confirmation_number_outlined, size: 16, color: AppColors.grey600),
                const SizedBox(width: 6),
                Text(
                  'Tiket: Rp ${_formatPrice(currentDay.estimatedDailyCost)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
          ),

          // ─── Timeline Activities ───────────────────────────────────
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: currentDay.items.length,
              itemBuilder: (context, index) {
                final item = currentDay.items[index];
                final isLast = index == currentDay.items.length - 1;

                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Timeline indicator
                      SizedBox(
                        width: 50,
                        child: Column(
                          children: [
                            Text(
                              item.startTime,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                color: AppColors.accent,
                                shape: BoxShape.circle,
                              ),
                            ),
                            if (!isLast)
                              Expanded(
                                child: Container(
                                  width: 2,
                                  color: AppColors.grey200,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Card Content
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.grey200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    item.attraction.category.icon,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      item.attraction.name,
                                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.grey100,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      '${item.travelTimeFromPreviousMinutes} mnt dari hotel',
                                      style: const TextStyle(fontSize: 9, color: AppColors.grey600),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                item.attraction.description,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.grey600,
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.access_time, size: 12, color: AppColors.grey600),
                                  const SizedBox(width: 4),
                                  Text(
                                    item.attraction.openingHours,
                                    style: const TextStyle(fontSize: 11, color: AppColors.grey600),
                                  ),
                                  const Spacer(),
                                  Text(
                                    item.attraction.ticketPrice == 0
                                        ? 'Gratis'
                                        : 'Rp ${_formatPrice(item.attraction.ticketPrice)}',
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.accent,
                                    ),
                                  ),
                                ],
                              ),
                              if (item.notes.isNotEmpty) ...[
                                const Divider(height: 16),
                                Row(
                                  children: [
                                    const Icon(Icons.lightbulb_outline, size: 14, color: AppColors.highlight),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        item.notes,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontStyle: FontStyle.italic,
                                          color: AppColors.grey800,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
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
