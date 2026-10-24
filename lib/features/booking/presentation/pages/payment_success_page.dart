import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:stayjogja_flutter/core/theme/app_theme.dart';
import 'package:stayjogja_flutter/core/constants/app_constants.dart';
import 'package:stayjogja_flutter/core/constants/mock_data.dart';
import 'package:stayjogja_flutter/core/utils/date_helper.dart';
import 'package:stayjogja_flutter/core/services/pdf_voucher_service.dart';
import 'package:stayjogja_flutter/features/hotel/domain/entities/hotel.dart';
import 'package:stayjogja_flutter/features/hotel/presentation/bloc/hotel_cubit.dart';

class PaymentSuccessPage extends StatelessWidget {
  final String hotelId;
  final String roomId;
  final String? bookingCodeOverride;
  final int? totalPriceOverride;
  final String? guestNameOverride;
  final String? checkInOverride;
  final String? checkOutOverride;

  const PaymentSuccessPage({
    super.key,
    required this.hotelId,
    required this.roomId,
    this.bookingCodeOverride,
    this.totalPriceOverride,
    this.guestNameOverride,
    this.checkInOverride,
    this.checkOutOverride,
  });

  @override
  Widget build(BuildContext context) {
    Hotel hotel = MockData.hotels.first;
    final hotelState = context.read<HotelCubit>().state;
    if (hotelState is HotelLoaded) {
      hotel = hotelState.hotels.firstWhere(
        (h) => h.id == hotelId,
        orElse: () => hotelState.hotels.first,
      );
    } else {
      hotel = MockData.hotels.firstWhere(
        (h) => h.id == hotelId,
        orElse: () => MockData.hotels.first,
      );
    }

    final room = hotel.rooms.firstWhere(
      (r) => r.id == roomId,
      orElse: () => hotel.rooms.isNotEmpty ? hotel.rooms.first : MockData.hotels.first.rooms.first,
    );

    final bookingCode = bookingCodeOverride ?? 'SJ-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    final guestName = guestNameOverride ?? 'Tamu StayJogja';
    final checkInStr = checkInOverride ?? DateHelper.formatDate(DateHelper.defaultCheckIn);
    final checkOutStr = checkOutOverride ?? DateHelper.formatDate(DateHelper.defaultCheckOut);
    final parsedCin = DateHelper.parseOrDefault(checkInOverride, DateHelper.defaultCheckIn);
    final parsedCout = DateHelper.parseOrDefault(checkOutOverride, DateHelper.defaultCheckOut);
    final nights = DateHelper.calculateNights(parsedCin, parsedCout);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('E-Voucher Pemesanan'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.go(AppRoutes.home),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Status Icon
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: AppColors.white, size: 36),
            ),
            const SizedBox(height: 16),
            Text(
              'Pembayaran Berhasil!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Reservasi langsung tersinkron ke Front Desk Hotel & Cloud Firestore',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.grey600),
            ),
            const SizedBox(height: 12),

            // ─── Status Pengiriman Email Box ──────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFBBF7D0)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.mark_email_read_rounded, color: AppColors.emerald, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'E-Voucher & QR Code resmi telah dikirim ke email Anda. Silakan periksa inbox / spam.',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // ─── Voucher Ticket Card ──────────────────────────────────
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cardShadow,
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'KODE BOOKING',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: AppColors.grey600,
                                letterSpacing: 1.2,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.success.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'LUNAS & TERKONFIRMASI',
                                style: TextStyle(
                                  color: AppColors.success,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          bookingCode,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2,
                            color: AppColors.primary,
                          ),
                        ),
                        const Divider(height: 28),
                        Text(
                          hotel.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${room.name} • Tamu: $guestName',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.grey600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Check-In',
                                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: AppColors.grey600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(checkInStr, style: const TextStyle(fontWeight: FontWeight.w600)),
                                  const Text('14:00 WIB', style: TextStyle(fontSize: 11, color: AppColors.grey600)),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Check-Out',
                                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: AppColors.grey600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(checkOutStr, style: const TextStyle(fontWeight: FontWeight.w600)),
                                  const Text('12:00 WIB', style: TextStyle(fontSize: 11, color: AppColors.grey600)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Tear line decoration
                  Row(
                    children: [
                      Container(
                        width: 16,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.horizontal(right: Radius.circular(16)),
                        ),
                      ),
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return Flex(
                              direction: Axis.horizontal,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(
                                (constraints.constrainWidth() / 10).floor(),
                                (_) => const SizedBox(
                                  width: 5,
                                  height: 1,
                                  child: DecoratedBox(decoration: BoxDecoration(color: AppColors.grey400)),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        width: 16,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.horizontal(left: Radius.circular(16)),
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // QR Code Asli Scannable (Kompatibel 100% Kamera Web Resepsionis)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.grey200),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              QrImageView(
                                data: [
                                  '=== RESERVASI STAYJOGJA ===',
                                  'INVOICE : $bookingCode',
                                  'STATUS  : LUNAS & TERKONFIRMASI',
                                  '---------------------------',
                                  'NAMA    : $guestName',
                                  'HOTEL   : ${hotel.name}',
                                  'KAMAR   : ${room.name}',
                                  'TANGGAL : $checkInStr s/d $checkOutStr',
                                  'TOTAL   : Rp ${totalPriceOverride ?? 1000000}',
                                  '===========================',
                                  'TERVERIFIKASI RESMI STAYJOGJA'
                                ].join('\n'),
                                version: QrVersions.auto,
                                size: 180.0,
                                eyeStyle: const QrEyeStyle(
                                  eyeShape: QrEyeShape.square,
                                  color: Color(0xFF16181B),
                                ),
                                dataModuleStyle: const QrDataModuleStyle(
                                  dataModuleShape: QrDataModuleShape.square,
                                  color: Color(0xFF16181B),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.grey100,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  bookingCode,
                                  style: const TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 2,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.qr_code_scanner_rounded, size: 16, color: AppColors.emerald),
                            SizedBox(width: 6),
                            Text(
                              'Arahkan QR Code ini ke kamera resepsionis untuk Fast Check-In',
                              style: TextStyle(fontSize: 11, color: AppColors.grey600, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(height: 1),
                        const SizedBox(height: 14),

                        // ─── Tombol Unduh PDF & Bagikan Tiket ───
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  PdfVoucherService.printOrSaveVoucher(
                                    bookingCode: bookingCode,
                                    guestName: guestName,
                                    hotelName: hotel.name,
                                    roomName: room.name,
                                    checkIn: checkInStr,
                                    checkOut: checkOutStr,
                                    nights: nights,
                                    totalPrice: totalPriceOverride ?? 1000000,
                                  );
                                },
                                icon: const Icon(Icons.picture_as_pdf_rounded, size: 16),
                                label: const Text('Cetak / PDF', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.grey900,
                                  side: const BorderSide(color: AppColors.grey200),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                  padding: const EdgeInsets.symmetric(vertical: 11),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  PdfVoucherService.shareVoucher(
                                    bookingCode: bookingCode,
                                    guestName: guestName,
                                    hotelName: hotel.name,
                                    roomName: room.name,
                                    checkIn: checkInStr,
                                    checkOut: checkOutStr,
                                    nights: nights,
                                    totalPrice: totalPriceOverride ?? 1000000,
                                  );
                                },
                                icon: const Icon(Icons.share_rounded, size: 16),
                                label: const Text('Bagikan Tiket', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.emerald,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                  padding: const EdgeInsets.symmetric(vertical: 11),
                                ),
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
            const SizedBox(height: 24),

            // ─── CTA: Buat Itinerary AI Langsung ──────────────────────
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    children: const [
                      Icon(Icons.auto_awesome, color: AppColors.highlight, size: 24),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Hotel sudah dipesan! Rencanakan liburanmu dengan AI',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: AppColors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton(
                    onPressed: () {
                      context.push('${AppRoutes.itineraryPreference}?hotelId=${hotel.id}');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                    ),
                    child: const Text('Buat Jadwal AI Sekarang ✨'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            OutlinedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Kembali ke Beranda'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
