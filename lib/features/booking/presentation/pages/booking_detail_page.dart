import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:stayjogja_flutter/core/theme/app_theme.dart';
import 'package:stayjogja_flutter/core/constants/app_constants.dart';
import 'package:stayjogja_flutter/core/constants/mock_data.dart';
import 'package:stayjogja_flutter/core/services/pdf_voucher_service.dart';
import 'package:stayjogja_flutter/features/booking/domain/entities/booking.dart';
import 'package:stayjogja_flutter/features/booking/presentation/bloc/booking_cubit.dart';
import 'package:stayjogja_flutter/features/hotel/domain/entities/hotel.dart';
import 'package:stayjogja_flutter/features/hotel/presentation/bloc/hotel_cubit.dart';

class BookingDetailPage extends StatelessWidget {
  final String bookingId;
  final BookingEntity? bookingOverride;

  const BookingDetailPage({
    super.key,
    required this.bookingId,
    this.bookingOverride,
  });

  @override
  Widget build(BuildContext context) {
    // Cari booking dari state atau gunakan override
    BookingEntity? currentBooking = bookingOverride;
    if (currentBooking == null) {
      final bookingState = context.read<BookingCubit>().state;
      if (bookingState is BookingsLoaded) {
        try {
          currentBooking = bookingState.bookings.firstWhere(
            (b) => b.id == bookingId || b.bookingCode == bookingId,
          );
        } catch (_) {}
      }
    }

    if (currentBooking == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: const Text('Detail Pemesanan')),
        body: const Center(child: Text('Data reservasi tidak ditemukan')),
      );
    }

    final booking = currentBooking;
    final isCompleted = booking.status == BookingStatus.completed;
    final statusColor = isCompleted
        ? AppColors.grey600
        : booking.status == BookingStatus.waitingCheckIn
            ? AppColors.emerald
            : AppColors.error;

    // Cari hotel terkait
    Hotel hotel = MockData.hotels.first;
    final hotelState = context.read<HotelCubit>().state;
    if (hotelState is HotelLoaded) {
      hotel = hotelState.hotels.firstWhere((h) => h.id == booking.hotelId, orElse: () => hotelState.hotels.first);
    } else {
      hotel = MockData.hotels.firstWhere((h) => h.id == booking.hotelId, orElse: () => MockData.hotels.first);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: const BoxDecoration(color: AppColors.white, shape: BoxShape.circle),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
            onPressed: () => context.pop(),
          ),
        ),
        title: const Text('Rincian Lengkap Pesanan', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700, fontSize: 16)),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded, color: AppColors.emerald),
            tooltip: 'Unduh PDF',
            onPressed: () async {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Mengunduh dokumen E-Voucher PDF...'), duration: Duration(seconds: 1)),
              );
              final path = await PdfVoucherService.downloadVoucherPdf(
                bookingCode: booking.bookingCode,
                guestName: booking.guestName,
                hotelName: booking.hotelName,
                roomName: booking.roomName,
                checkIn: booking.checkInDate,
                checkOut: booking.checkOutDate,
                nights: booking.totalNights,
                totalPrice: booking.totalPrice,
                guestNik: booking.guestNik,
              );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('✅ Tersimpan: ${path.split('/').last}'), backgroundColor: AppColors.emerald),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Status Banner ─────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: statusColor.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    isCompleted ? Icons.check_circle_rounded : Icons.pending_actions_rounded,
                    color: statusColor,
                    size: 26,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isCompleted ? 'Menginap Selesai' : 'Lunas & Menunggu Check-in',
                          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700, fontSize: 13, color: statusColor),
                        ),
                        Text(
                          isCompleted
                              ? 'Terima kasih telah menginap! Anda dapat meninggalkan ulasan.'
                              : 'Tunjukkan E-Voucher QR Anda di front desk saat kedatangan.',
                          style: TextStyle(fontSize: 11, color: statusColor.withValues(alpha: 0.9)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      booking.bookingCode,
                      style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 1),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ─── Section 1: Informasi Hotel & Kamar ────────────────────
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: CachedNetworkImage(
                          imageUrl: booking.hotelImageUrl.isNotEmpty ? booking.hotelImageUrl : hotel.images.first,
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
                                ...List.generate(hotel.star, (_) => const Icon(Icons.star_rounded, size: 14, color: AppColors.star)),
                                const SizedBox(width: 6),
                                Text('${hotel.star} Bintang', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.grey600)),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              booking.hotelName,
                              style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700, fontSize: 14),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              hotel.address.isNotEmpty ? hotel.address : hotel.area,
                              style: const TextStyle(fontSize: 11, color: AppColors.grey600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(color: AppColors.emeraldLight, borderRadius: BorderRadius.circular(6)),
                              child: Text(
                                booking.roomName,
                                style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.emerald),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Divider(height: 1),
                  const SizedBox(height: 10),

                  // Kebijakan & Fast Pass
                  _bulletPoint(Icons.check_circle_outline_rounded, 'Bebas Pembatalan s/d 24 Jam', AppColors.emerald),
                  const SizedBox(height: 4),
                  _bulletPoint(Icons.qr_code_rounded, 'Fast Check-In Paperless Didukung (UU PDP)', AppColors.grey800),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ─── Section 2: Jadwal Menginap ────────────────────────────
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Jadwal & Waktu Menginap', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: AppColors.grey50, borderRadius: BorderRadius.circular(14)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Check-in', style: TextStyle(fontSize: 10, color: AppColors.grey600)),
                              const SizedBox(height: 2),
                              Text(booking.checkInDate, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                              const Text('Mulai 14.00 WIB', style: TextStyle(fontSize: 10, color: AppColors.emerald, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: AppColors.grey200, borderRadius: BorderRadius.circular(8)),
                        child: Text('${booking.totalNights} Malam', style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: AppColors.grey50, borderRadius: BorderRadius.circular(14)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Check-out', style: TextStyle(fontSize: 10, color: AppColors.grey600)),
                              const SizedBox(height: 2),
                              Text(booking.checkOutDate, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                              const Text('Sebelum 12.00 WIB', style: TextStyle(fontSize: 10, color: Colors.orange, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ─── Section 3: Add-on & Preferensi yang Dibeli ────────────
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Add-on & Fasilitas yang Dipilih', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                  const SizedBox(height: 12),
                  _infoRow(
                    'Paket Sarapan',
                    booking.hasBreakfastAddon ? 'Termasuk Sarapan Buffet Hotel (2 Orang)' : 'Kamar Saja (Room Only)',
                    booking.hasBreakfastAddon ? Icons.restaurant_rounded : Icons.coffee_outlined,
                  ),
                  const Divider(height: 16),
                  _infoRow(
                    'Tipe Ranjang',
                    booking.bedPreference ?? '1 Ranjang Besar (Double)',
                    Icons.bed_rounded,
                  ),
                  const Divider(height: 16),
                  _infoRow(
                    'Preferensi Rokok',
                    booking.smokingPreference ?? 'Bebas Rokok (Non-Smoking)',
                    Icons.smoke_free_rounded,
                  ),
                  if (booking.specialRequests != null && booking.specialRequests!.isNotEmpty) ...[
                    const Divider(height: 16),
                    _infoRow(
                      'Permintaan Khusus',
                      booking.specialRequests!,
                      Icons.comment_outlined,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ─── Section 4: Data Tamu & Identitas ──────────────────────
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Data Tamu Utama', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                  const SizedBox(height: 12),
                  _infoRow('Nama Lengkap', booking.guestName, Icons.person_outline_rounded),
                  const Divider(height: 16),
                  _infoRow('Alamat Email', booking.guestEmail, Icons.email_outlined),
                  const Divider(height: 16),
                  _infoRow('Nomor WhatsApp', '081234567890', Icons.phone_android_rounded),
                  const Divider(height: 16),
                  _infoRow(
                    'Status Identitas KTP',
                    booking.isKtpVerified ? 'Terverifikasi Resmi (Terlindungi UU PDP)' : 'Belum Verifikasi Mandiri',
                    booking.isKtpVerified ? Icons.verified_user_rounded : Icons.shield_outlined,
                    color: booking.isKtpVerified ? AppColors.emerald : Colors.amber.shade800,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ─── Section 5: Rincian Pembayaran ─────────────────────────
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Rincian Pembayaran & Invoice', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                  const SizedBox(height: 12),
                  _priceRow('Metode Pembayaran', booking.paymentMethod),
                  _priceRow('Status Tagihan', 'LUNAS & TERVERIFIKASI', isGreen: true),
                  _priceRow('Kamar (${booking.totalNights} Malam)', 'Rp ${_formatPrice(booking.totalPrice - 25000)}'),
                  _priceRow('Pajak & Layanan Hotel', 'Rp 25.000'),
                  const Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Pembayaran', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                      Text(
                        'Rp ${_formatPrice(booking.totalPrice)}',
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.emerald),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // ─── Sticky Bottom Action Bar ──────────────────────────────────
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    context.push('${AppRoutes.itineraryPreference}?hotelId=${booking.hotelId}');
                  },
                  icon: const Icon(Icons.auto_awesome, size: 16),
                  label: const Text('Rute Wisata AI', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.grey900,
                    side: const BorderSide(color: AppColors.grey200),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.push(
                      '${AppRoutes.checkout}/success?hotelId=${booking.hotelId}&roomId=${Uri.encodeComponent(booking.roomName)}&code=${booking.bookingCode}&price=${booking.totalPrice}&guest=${Uri.encodeComponent(booking.guestName)}&cin=${Uri.encodeComponent(booking.checkInDate)}&cout=${Uri.encodeComponent(booking.checkOutDate)}',
                    );
                  },
                  icon: const Icon(Icons.qr_code_rounded, size: 16, color: Colors.white),
                  label: const Text('Buka E-Voucher', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.emerald,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _bulletPoint(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 15, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value, IconData icon, {Color? color}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: color ?? AppColors.grey600),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 10.5, color: AppColors.grey600)),
              Text(
                value,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: color ?? AppColors.grey900,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _priceRow(String label, String value, {bool isGreen = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.grey600)),
          Text(
            value,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: isGreen ? AppColors.emerald : AppColors.grey900,
            ),
          ),
        ],
      ),
    );
  }

  static String _formatPrice(int price) {
    return price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
  }
}
