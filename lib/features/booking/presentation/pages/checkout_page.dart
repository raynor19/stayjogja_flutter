import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stayjogja_flutter/core/theme/app_theme.dart';
import 'package:stayjogja_flutter/core/constants/app_constants.dart';
import 'package:stayjogja_flutter/core/constants/mock_data.dart';
import 'package:stayjogja_flutter/core/utils/date_helper.dart';
import 'package:stayjogja_flutter/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:stayjogja_flutter/features/booking/domain/entities/booking.dart';
import 'package:stayjogja_flutter/features/booking/presentation/bloc/booking_cubit.dart';
import 'package:stayjogja_flutter/features/hotel/domain/entities/hotel.dart';
import 'package:stayjogja_flutter/features/hotel/presentation/bloc/hotel_cubit.dart';

class CheckoutPage extends StatefulWidget {
  final String hotelId;
  final String roomId;
  final String? initialCheckIn;
  final String? initialCheckOut;

  const CheckoutPage({
    super.key,
    required this.hotelId,
    required this.roomId,
    this.initialCheckIn,
    this.initialCheckOut,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String _selectedPayment = 'qris';
  bool _isLoading = false;
  String _appliedPromoCode = '';
  int _discountAmount = 0;

  late DateTime _checkIn;
  late DateTime _checkOut;

  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  final _promoCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    // 1. Tanggal dinamis dari jam perangkat sekarang
    _checkIn = DateHelper.parseOrDefault(widget.initialCheckIn, DateHelper.defaultCheckIn);
    _checkOut = DateHelper.parseOrDefault(widget.initialCheckOut, DateHelper.defaultCheckOut);

    // 2. Ambil profil user nyata dari AuthCubit (bukan hardcoded)
    String initialName = '';
    String initialEmail = '';
    String initialPhone = '';

    final authState = context.read<AuthCubit>().state;
    if (authState is Authenticated) {
      initialName = authState.user.name;
      initialEmail = authState.user.email;
      initialPhone = authState.user.phoneNumber;
    }

    _nameCtrl = TextEditingController(text: initialName);
    _emailCtrl = TextEditingController(text: initialEmail);
    _phoneCtrl = TextEditingController(text: initialPhone);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _promoCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(start: _checkIn, end: _checkOut),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.white,
              surface: AppColors.white,
              onSurface: AppColors.grey900,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _checkIn = picked.start;
        _checkOut = picked.end;
      });
    }
  }

  String _generateReadableBookingCode() {
    const chars = '23456789ABCDEFGHJKLMNPQRSTUVWXYZ';
    final rand = Random();
    final code = List.generate(6, (_) => chars[rand.nextInt(chars.length)]).join();
    return 'SJ-$code';
  }

  Future<void> _processPayment(Hotel hotel, RoomType room, int grandTotal, int nights) async {
    setState(() => _isLoading = true);

    final bookingCode = _generateReadableBookingCode();
    final formattedCheckIn = DateHelper.formatDate(_checkIn);
    final formattedCheckOut = DateHelper.formatDate(_checkOut);

    // Buat objek booking nyata
    final newBooking = BookingEntity(
      id: 'res-${DateTime.now().millisecondsSinceEpoch}',
      bookingCode: bookingCode,
      hotelId: hotel.id,
      hotelName: hotel.name,
      roomName: room.name,
      hotelImageUrl: hotel.images.isNotEmpty ? hotel.images.first : '',
      guestName: _nameCtrl.text.trim().isNotEmpty ? _nameCtrl.text.trim() : 'Tamu StayJogja',
      guestEmail: _emailCtrl.text.trim().isNotEmpty ? _emailCtrl.text.trim() : 'tamu@stayjogja.id',
      checkInDate: formattedCheckIn,
      checkOutDate: formattedCheckOut,
      totalNights: nights,
      totalPrice: grandTotal,
      paymentMethod: _selectedPayment.toUpperCase(),
      status: BookingStatus.waitingCheckIn, // Pembayaran di-bypass langsung Lunas & siap check-in
      createdAt: DateTime.now(),
    );

    // Kirim & Simpan langsung ke Cloud Firestore stayjogja-9b705
    try {
      await context.read<BookingCubit>().createBooking(newBooking);
    } catch (_) {}

    if (!mounted) return;
    setState(() => _isLoading = false);

    // Arahkan ke halaman E-Voucher dengan parameter dinamis lengkap
    context.pushReplacement(
      '${AppRoutes.checkout}/success?hotelId=${hotel.id}&roomId=${room.id}&code=$bookingCode&price=$grandTotal&guest=${Uri.encodeComponent(newBooking.guestName)}&cin=${Uri.encodeComponent(formattedCheckIn)}&cout=${Uri.encodeComponent(formattedCheckOut)}',
    );
  }

  @override
  Widget build(BuildContext context) {
    // Cari hotel dari state HotelCubit atau fallback ke MockData
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

    final room = hotel.rooms.firstWhere(
      (r) => r.id == widget.roomId,
      orElse: () => hotel.rooms.isNotEmpty ? hotel.rooms.first : MockData.hotels.first.rooms.first,
    );

    // Hitung jumlah malam & tanggal secara dinamis
    final nights = DateHelper.calculateNights(_checkIn, _checkOut);
    final totalPrice = room.pricePerNight * nights;
    const tax = 25000;
    final grandTotal = (totalPrice + tax - _discountAmount).clamp(0, 999999999);

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
            // ─── Ringkasan Hotel & Tanggal Dinamis (Bisa Diubah) ──────
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
                  InkWell(
                    onTap: _pickDateRange,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 14, color: AppColors.accent),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${DateHelper.formatDateRange(_checkIn, _checkOut)} ($nights Malam)',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                          const Text(
                            'Ubah Tanggal',
                            style: TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.emerald),
                          ),
                          const Icon(Icons.chevron_right, size: 14, color: AppColors.emerald),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ─── Data Tamu (Otomatis dari Akun Login) ─────────────────
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
                    decoration: const InputDecoration(labelText: 'Nama Lengkap Tamu'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Email (Pengiriman E-Voucher)'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _phoneCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(labelText: 'Nomor WhatsApp'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ─── Pilihan Metode Pembayaran ─────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Metode Pembayaran', style: Theme.of(context).textTheme.titleMedium),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: AppColors.emeraldLight, borderRadius: BorderRadius.circular(8)),
                  child: const Text('Bypass Aktif (Auto-Lunas)', style: TextStyle(fontSize: 10, color: AppColors.emerald, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.grey200),
              ),
              child: Column(
                children: [
                  _paymentTile('qris', 'QRIS Instan (Gopay, OVO, DANA, ShopeePay)', '📱'),
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

            // ─── Kode Promo / Voucher (PRD BKG-7) ─────────────────────
            Text('Voucher & Kode Promo', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.grey200),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _promoCtrl,
                      textCapitalization: TextCapitalization.characters,
                      decoration: const InputDecoration(
                        hintText: 'Gunakan kode: STAYJOGJA10',
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final code = _promoCtrl.text.trim().toUpperCase();
                      if (code == 'STAYJOGJA10') {
                        setState(() {
                          _appliedPromoCode = code;
                          _discountAmount = (totalPrice * 0.1).toInt();
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Voucher $code berhasil! Hemat Rp ${_formatPrice(_discountAmount)}'), backgroundColor: AppColors.emerald),
                        );
                      } else if (code.isNotEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Kode voucher tidak valid / sudah kedaluwarsa'), backgroundColor: AppColors.error),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      minimumSize: const Size(0, 36),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text('Gunakan', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
            if (_appliedPromoCode.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.check_circle, size: 14, color: AppColors.emerald),
                  const SizedBox(width: 4),
                  Text('Diskon 10% berhasil diterapkan ($_appliedPromoCode)', style: const TextStyle(fontSize: 11, color: AppColors.emerald, fontWeight: FontWeight.w600)),
                ],
              ),
            ],
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
                  if (_discountAmount > 0) ...[
                    const SizedBox(height: 8),
                    _priceRow('Diskon Voucher Promo', '- Rp ${_formatPrice(_discountAmount)}', isDiscount: true),
                  ],
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
              onPressed: _isLoading ? null : () => _processPayment(hotel, room, grandTotal, nights),
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 2),
                    )
                  : Text('Bayar Sekarang (Bypass) • Rp ${_formatPrice(grandTotal)}'),
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

  Widget _priceRow(String label, String value, {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: isDiscount ? AppColors.emerald : AppColors.grey600)),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: isDiscount ? AppColors.emerald : AppColors.grey900,
          ),
        ),
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
