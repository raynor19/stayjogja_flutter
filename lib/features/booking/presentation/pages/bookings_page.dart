import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:stayjogja_flutter/core/theme/app_theme.dart';
import 'package:stayjogja_flutter/core/constants/app_constants.dart';
import 'package:stayjogja_flutter/core/constants/mock_data.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  int _selectedFilter = 0; // 0: Aktif, 1: Selesai, 2: Dibatalkan

  final _filters = ['Aktif', 'Selesai', 'Dibatalkan'];

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
                  const Text(
                    'Riwayat Booking',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.grey900,
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.help_outline_rounded, size: 20, color: AppColors.grey800),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Tab Filter Pills
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppColors.grey200),
                ),
                child: Row(
                  children: List.generate(_filters.length, (index) {
                    final isSelected = _selectedFilter == index;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedFilter = index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary : Colors.transparent,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Center(
                            child: Text(
                              _filters[index],
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                color: isSelected ? AppColors.white : AppColors.grey600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Booking Cards List
            Expanded(
              child: _selectedFilter == 0
                  ? _buildActiveBookings(context)
                  : _selectedFilter == 1
                      ? _buildCompletedBookings(context)
                      : _buildCancelledBookings(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveBookings(BuildContext context) {
    final hotel = MockData.hotels.first;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 110),
      children: [
        _BookingCard(
          hotel: hotel,
          bookingCode: 'SJ-928104',
          roomName: 'Deluxe Heritage King',
          dates: '12 Okt - 14 Okt 2026',
          status: 'Menunggu Check-in',
          statusColor: AppColors.emerald,
          totalPrice: 1040000,
          onViewVoucher: () {
            context.push('${AppRoutes.checkout}/success?hotelId=${hotel.id}&roomId=rm-101');
          },
          onMakeItinerary: () {
            context.push('${AppRoutes.itineraryPreference}?hotelId=${hotel.id}');
          },
        ),
      ],
    );
  }

  Widget _buildCompletedBookings(BuildContext context) {
    final hotel = MockData.hotels[1];
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 110),
      children: [
        _BookingCard(
          hotel: hotel,
          bookingCode: 'SJ-719302',
          roomName: 'Bohemian Garden Room',
          dates: '01 Sep - 03 Sep 2026',
          status: 'Selesai Menginap',
          statusColor: AppColors.grey600,
          totalPrice: 840000,
          isCompleted: true,
          onViewVoucher: () {
            context.push('${AppRoutes.checkout}/success?hotelId=${hotel.id}&roomId=rm-201');
          },
        ),
      ],
    );
  }

  Widget _buildCancelledBookings(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.event_busy_rounded, size: 60, color: AppColors.grey400),
          SizedBox(height: 12),
          Text(
            'Tidak ada pesanan yang dibatalkan',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: AppColors.grey600,
            ),
          ),
        ],
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final dynamic hotel;
  final String bookingCode;
  final String roomName;
  final String dates;
  final String status;
  final Color statusColor;
  final int totalPrice;
  final bool isCompleted;
  final VoidCallback onViewVoucher;
  final VoidCallback? onMakeItinerary;

  const _BookingCard({
    required this.hotel,
    required this.bookingCode,
    required this.roomName,
    required this.dates,
    required this.status,
    required this.statusColor,
    required this.totalPrice,
    this.isCompleted = false,
    required this.onViewVoucher,
    this.onMakeItinerary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          // Header status
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  bookingCode,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    letterSpacing: 1,
                    color: AppColors.grey900,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Hotel Info Row
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedNetworkImage(
                    imageUrl: hotel.images.first,
                    width: 76,
                    height: 76,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hotel.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.grey900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        roomName,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: AppColors.grey600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_rounded, size: 12, color: AppColors.emerald),
                          const SizedBox(width: 6),
                          Text(
                            dates,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: AppColors.grey800,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Total & Actions
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Dibayar',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        color: AppColors.grey600,
                      ),
                    ),
                    Text(
                      'Rp ${_formatPrice(totalPrice)}',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.grey900,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    if (onMakeItinerary != null) ...[
                      OutlinedButton(
                        onPressed: onMakeItinerary,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.emerald,
                          side: const BorderSide(color: AppColors.emerald),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          minimumSize: const Size(0, 36),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.auto_awesome, size: 13),
                            SizedBox(width: 4),
                            Text('AI Trip', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    ElevatedButton(
                      onPressed: onViewVoucher,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        minimumSize: const Size(0, 36),
                      ),
                      child: Text(
                        isCompleted ? 'Beri Ulasan' : 'E-Voucher',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                      ),
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
