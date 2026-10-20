import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:stayjogja_flutter/core/theme/app_theme.dart';
import 'package:stayjogja_flutter/core/constants/app_constants.dart';
import 'package:stayjogja_flutter/core/constants/mock_data.dart';
import 'package:stayjogja_flutter/features/itinerary/domain/entities/itinerary.dart';

class ItineraryResultPage extends StatefulWidget {
  final String hotelId;
  final int days;
  final String pace;
  final String? itineraryIdOverride;
  final String? titleOverride;
  final String? hotelNameOverride;

  const ItineraryResultPage({
    super.key,
    required this.hotelId,
    required this.days,
    required this.pace,
    this.itineraryIdOverride,
    this.titleOverride,
    this.hotelNameOverride,
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
    final generated = MockData.generateMockItinerary(
      hotel: hotel,
      daysCount: widget.days,
      pace: widget.pace,
      preferences: ['Budaya', 'Kuliner'],
    );

    _itinerary = TripItinerary(
      id: widget.itineraryIdOverride ?? generated.id,
      title: widget.titleOverride ?? generated.title,
      hotelName: widget.hotelNameOverride ?? generated.hotelName,
      hotelArea: generated.hotelArea,
      totalDays: widget.days,
      pace: widget.pace,
      interests: generated.interests,
      days: generated.days,
      createdAt: generated.createdAt,
    );
  }

  void _shareItinerary() {
    final buffer = StringBuffer();
    buffer.writeln('🗺️ *Rencana Liburan Jogja bersama Stay Jogja* 🗺️');
    buffer.writeln('Basis Hotel: ${_itinerary.hotelName}');
    buffer.writeln('Durasi: ${_itinerary.totalDays} Hari (${_itinerary.pace})');
    buffer.writeln('');

    for (final day in _itinerary.days) {
      buffer.writeln('📅 *${day.date}*');
      for (final itm in day.items) {
        buffer.writeln('• ${itm.startTime} - ${itm.attraction.name} (${itm.attraction.category.label})');
      }
      buffer.writeln('');
    }
    buffer.writeln('Dibuat otomatis oleh AI Trip Planner Stay Jogja');

    Clipboard.setData(ClipboardData(text: buffer.toString()));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Rencana perjalanan lengkap berhasil disalin ke clipboard! Siap dibagikan 📲'),
        backgroundColor: AppColors.emerald,
      ),
    );
  }

  void _removeItem(ItineraryItem item) {
    setState(() {
      final currentItems = List<ItineraryItem>.from(_itinerary.days[_selectedDayIndex].items);
      currentItems.removeWhere((i) => i.id == item.id);

      final newTotalTravel = currentItems.fold(0, (sum, i) => sum + i.travelTimeFromPreviousMinutes);
      final newTotalCost = currentItems.fold(0, (sum, i) => sum + i.attraction.ticketPrice);

      final updatedDays = List<DayPlan>.from(_itinerary.days);
      updatedDays[_selectedDayIndex] = DayPlan(
        dayNumber: _itinerary.days[_selectedDayIndex].dayNumber,
        date: _itinerary.days[_selectedDayIndex].date,
        items: currentItems,
        totalTravelMinutes: newTotalTravel,
        estimatedDailyCost: newTotalCost,
      );

      _itinerary = TripItinerary(
        id: _itinerary.id,
        title: _itinerary.title,
        hotelName: _itinerary.hotelName,
        hotelArea: _itinerary.hotelArea,
        totalDays: _itinerary.totalDays,
        pace: _itinerary.pace,
        interests: _itinerary.interests,
        days: updatedDays,
        createdAt: _itinerary.createdAt,
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${item.attraction.name} dihapus dari rencana.'), backgroundColor: AppColors.primary),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentDay = _itinerary.days.isNotEmpty ? _itinerary.days[_selectedDayIndex] : null;

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
            tooltip: 'Bagikan Itinerary',
            onPressed: _shareItinerary,
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_added_rounded, color: AppColors.accent),
            tooltip: 'Simpan',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Itinerary tersimpan ke Cloud Firestore!'), backgroundColor: AppColors.emerald),
              );
            },
          ),
        ],
      ),
      body: currentDay == null
          ? const Center(child: Text('Tidak ada jadwal'))
          : Column(
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

                // ─── Daily Summary Bar ─────────────────────────────────────
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

                // ─── Timeline Activities with Remove Action ────────────────
                Expanded(
                  child: currentDay.items.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.event_note_outlined, size: 54, color: AppColors.grey400),
                              SizedBox(height: 10),
                              Text('Belum ada destinasi untuk hari ini', style: TextStyle(color: AppColors.grey600)),
                            ],
                          ),
                        )
                      : ListView.builder(
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
                                              IconButton(
                                                icon: const Icon(Icons.close_rounded, size: 16, color: AppColors.grey400),
                                                padding: EdgeInsets.zero,
                                                constraints: const BoxConstraints(),
                                                tooltip: 'Hapus destinasi ini',
                                                onPressed: () => _removeItem(item),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAIChatRevisionSheet(context),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
        label: const Text(
          'Revisi dengan AI ✨',
          style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _showAIChatRevisionSheet(BuildContext context) {
    final chatCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + MediaQuery.of(ctx).padding.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.grey400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: const [
                  Icon(Icons.auto_awesome, color: AppColors.emerald, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Chat Revisi AI Itinerary',
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Minta AI mengubah ritme, tempat, atau anggaran',
                style: TextStyle(fontSize: 12, color: AppColors.grey600),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  'Buat hari ke-2 lebih santai',
                  'Tambah rekomendasi kuliner malam',
                  'Ganti candi ke spot foto alam',
                  'Kurangi budget tiket masuk',
                ].map((s) {
                  return GestureDetector(
                    onTap: () {
                      chatCtrl.text = s;
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.grey100,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.grey200),
                      ),
                      child: Text(s, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: chatCtrl,
                      decoration: InputDecoration(
                        hintText: 'Ketik permintaan revisi...',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                    ),
                    icon: const Icon(Icons.arrow_upward_rounded, size: 20),
                    onPressed: () {
                      final req = chatCtrl.text.trim();
                      Navigator.pop(ctx);
                      if (req.isNotEmpty) {
                        setState(() {
                          final currentItems = List<ItineraryItem>.from(_itinerary.days[_selectedDayIndex].items);
                          if (currentItems.length > 2) {
                            currentItems.removeLast();
                          }
                          final updatedDays = List<DayPlan>.from(_itinerary.days);
                          updatedDays[_selectedDayIndex] = DayPlan(
                            dayNumber: _itinerary.days[_selectedDayIndex].dayNumber,
                            date: _itinerary.days[_selectedDayIndex].date,
                            items: currentItems,
                            totalTravelMinutes: currentItems.fold(0, (s, i) => s + i.travelTimeFromPreviousMinutes),
                            estimatedDailyCost: currentItems.fold(0, (s, i) => s + i.attraction.ticketPrice),
                          );
                          _itinerary = TripItinerary(
                            id: _itinerary.id,
                            title: 'Eksplorasi Santai Jogja (Revisi AI)',
                            hotelName: _itinerary.hotelName,
                            hotelArea: _itinerary.hotelArea,
                            totalDays: _itinerary.totalDays,
                            pace: 'santai',
                            interests: _itinerary.interests,
                            days: updatedDays,
                            createdAt: DateTime.now(),
                          );
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('AI berhasil merevisi itinerary sesuai: "$req" ✨'),
                            backgroundColor: AppColors.emerald,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
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
