import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stayjogja_flutter/core/theme/app_theme.dart';
import 'package:stayjogja_flutter/core/constants/app_constants.dart';
import 'package:stayjogja_flutter/core/constants/mock_data.dart';

class PaymentSuccessPage extends StatelessWidget {
  final String hotelId;
  final String roomId;

  const PaymentSuccessPage({super.key, required this.hotelId, required this.roomId});

  @override
  Widget build(BuildContext context) {
    final hotel = MockData.hotels.firstWhere(
      (h) => h.id == hotelId,
      orElse: () => MockData.hotels.first,
    );
    final room = hotel.rooms.firstWhere(
      (r) => r.id == roomId,
      orElse: () => hotel.rooms.first,
    );

    final bookingCode = 'SJ-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

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
              'E-Voucher telah dikirim ke email kamu',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.grey600),
            ),
            const SizedBox(height: 24),

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
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.success.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'LUNAS',
                                style: TextStyle(
                                  color: AppColors.success,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
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
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
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
                          room.name,
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
                                  const Text('12 Okt 2026', style: TextStyle(fontWeight: FontWeight.w600)),
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
                                  const Text('14 Okt 2026', style: TextStyle(fontWeight: FontWeight.w600)),
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
                        // Barcode mockup
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.grey100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                32,
                                (i) => Container(
                                  width: (i % 3 == 0) ? 3 : (i % 2 == 0) ? 2 : 1,
                                  height: 36,
                                  margin: const EdgeInsets.symmetric(horizontal: 1.5),
                                  color: AppColors.grey900,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tunjukkan kode ini saat tiba di resepsionis hotel',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

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
                      context.push(
                        '${AppRoutes.itineraryPreference}?hotelId=${hotel.id}',
                      );
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
