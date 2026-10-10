import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stayjogja_flutter/core/theme/app_theme.dart';
import 'package:stayjogja_flutter/core/constants/app_constants.dart';
import 'package:stayjogja_flutter/core/constants/mock_data.dart';

class CheckoutPage extends StatefulWidget {
  final String hotelId;
  final String roomId;

  const CheckoutPage({super.key, required this.hotelId, required this.roomId});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String _selectedPayment = 'qris';
  bool _isLoading = false;

  final _nameCtrl = TextEditingController(text: 'Raynor Muhammad');
  final _emailCtrl = TextEditingController(text: 'raynormuhammad19@gmail.com');
  final _phoneCtrl = TextEditingController(text: '081234567890');

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _processPayment() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      // Navigate to success voucher page
      context.pushReplacement(
        '${AppRoutes.checkout}/success?hotelId=${widget.hotelId}&roomId=${widget.roomId}',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final hotel = MockData.hotels.firstWhere(
      (h) => h.id == widget.hotelId,
      orElse: () => MockData.hotels.first,
    );
    final room = hotel.rooms.firstWhere(
      (r) => r.id == widget.roomId,
      orElse: () => hotel.rooms.first,
    );

    const nights = 2;
    final totalPrice = room.pricePerNight * nights;
    const tax = 25000;
    final grandTotal = totalPrice + tax;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Checkout Pemesanan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Ringkasan Hotel ──────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.grey200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hotel.name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${room.name} • $nights Malam',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.grey600),
                  ),
                  const Divider(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 14, color: AppColors.accent),
                      const SizedBox(width: 6),
                      Text('12 Okt 2026 - 14 Okt 2026', style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ─── Data Tamu ────────────────────────────────────────────
            Text('Data Tamu Utama', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.grey200),
              ),
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _emailCtrl,
                    decoration: const InputDecoration(labelText: 'Email (untuk E-voucher)'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _phoneCtrl,
                    decoration: const InputDecoration(labelText: 'Nomor WhatsApp'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ─── Pilihan Metode Pembayaran ─────────────────────────────
            Text('Metode Pembayaran', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.grey200),
              ),
              child: Column(
                children: [
                  _paymentTile('qris', 'QRIS (Semua E-Wallet & Mobile Banking)', '📱'),
                  const Divider(height: 1),
                  _paymentTile('bca_va', 'BCA Virtual Account', '🏦'),
                  const Divider(height: 1),
                  _paymentTile('mandiri_va', 'Mandiri Virtual Account', '🏛️'),
                  const Divider(height: 1),
                  _paymentTile('gopay', 'GoPay / GoPay Later', '🟢'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ─── Rincian Biaya ─────────────────────────────────────────
            Text('Rincian Harga', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.grey200),
              ),
              child: Column(
                children: [
                  _priceRow('Kamar ($nights malam)', 'Rp ${_formatPrice(totalPrice)}'),
                  const SizedBox(height: 8),
                  _priceRow('Biaya Layanan & Pajak', 'Rp ${_formatPrice(tax)}'),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Pembayaran',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        'Rp ${_formatPrice(grandTotal)}',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Bayar Button
            ElevatedButton(
              onPressed: _isLoading ? null : _processPayment,
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 2),
                    )
                  : Text('Bayar Sekarang • Rp ${_formatPrice(grandTotal)}'),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _paymentTile(String id, String title, String icon) {
    return RadioListTile<String>(
      value: id,
      groupValue: _selectedPayment,
      onChanged: (val) => setState(() => _selectedPayment = val!),
      activeColor: AppColors.accent,
      title: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  Widget _priceRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.grey600)),
        Text(value, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
      ],
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
