import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:stayjogja_flutter/core/theme/app_theme.dart';
import 'package:stayjogja_flutter/core/constants/app_constants.dart';
import 'package:stayjogja_flutter/core/constants/mock_data.dart';
import 'package:stayjogja_flutter/core/utils/date_helper.dart';
import 'package:stayjogja_flutter/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:stayjogja_flutter/features/hotel/domain/entities/hotel.dart';
import 'package:stayjogja_flutter/features/hotel/presentation/bloc/hotel_cubit.dart';

class BookingReviewPage extends StatefulWidget {
  final String hotelId;
  final String roomId;
  final String? initialCheckIn;
  final String? initialCheckOut;

  const BookingReviewPage({
    super.key,
    required this.hotelId,
    required this.roomId,
    this.initialCheckIn,
    this.initialCheckOut,
  });

  @override
  State<BookingReviewPage> createState() => _BookingReviewPageState();
}

class _BookingReviewPageState extends State<BookingReviewPage> {
  late DateTime _checkIn;
  late DateTime _checkOut;

  // Data Kontak & Tamu
  late final TextEditingController _bookerNameCtrl;
  late final TextEditingController _bookerEmailCtrl;
  late final TextEditingController _bookerPhoneCtrl;
  late final TextEditingController _guestNameCtrl;
  late final TextEditingController _specialReqCtrl;

  bool _isBookingForOther = false;
  bool _addBreakfast = false;
  bool _addInsurance = false;
  String _bedPreference = '1 Ranjang Besar (Double)';
  String _smokingPreference = 'Bebas Rokok (Non-Smoking)';
  String _arrivalTime = '14.00 - 15.00 WIB';

  final List<String> _selectedQuickRequests = [];

  final List<String> _quickRequestOptions = [
    'Lantai Tinggi (High Floor)',
    'Kamar Tenang (Quiet Room)',
    'Bebas Asap Rokok',
    'Dekat Lift',
    'Kamar Bersebelahan',
  ];

  @override
  void initState() {
    super.initState();
    _checkIn = DateHelper.parseOrDefault(widget.initialCheckIn, DateHelper.defaultCheckIn);
    _checkOut = DateHelper.parseOrDefault(widget.initialCheckOut, DateHelper.defaultCheckOut);

    String name = 'Raynor Muhammad';
    String email = 'raynormuhammad19@gmail.com';
    String phone = '+62 812-3456-7890';

    final authState = context.read<AuthCubit>().state;
    if (authState is Authenticated) {
      name = authState.user.name;
      email = authState.user.email;
      if (authState.user.phoneNumber.isNotEmpty) phone = authState.user.phoneNumber;
    }

    _bookerNameCtrl = TextEditingController(text: name);
    _bookerEmailCtrl = TextEditingController(text: email);
    _bookerPhoneCtrl = TextEditingController(text: phone);
    _guestNameCtrl = TextEditingController();
    _specialReqCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _bookerNameCtrl.dispose();
    _bookerEmailCtrl.dispose();
    _bookerPhoneCtrl.dispose();
    _guestNameCtrl.dispose();
    _specialReqCtrl.dispose();
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

  void _proceedToPayment(Hotel hotel, RoomType room, int grandTotal, int nights) {
    final cinStr = DateHelper.formatDate(_checkIn);
    final coutStr = DateHelper.formatDate(_checkOut);
    final finalGuestName = _isBookingForOther && _guestNameCtrl.text.trim().isNotEmpty
        ? _guestNameCtrl.text.trim()
        : _bookerNameCtrl.text.trim();

    final allSpecialReqs = [
      ..._selectedQuickRequests,
      if (_specialReqCtrl.text.trim().isNotEmpty) _specialReqCtrl.text.trim(),
    ].join(', ');

    // Teruskan ke halaman checkout pembayaran dengan parameter komprehensif
    context.push(
      '${AppRoutes.checkout}?hotelId=${hotel.id}&roomId=${room.id}&cin=${Uri.encodeComponent(cinStr)}&cout=${Uri.encodeComponent(coutStr)}&guest=${Uri.encodeComponent(finalGuestName)}&email=${Uri.encodeComponent(_bookerEmailCtrl.text.trim())}&phone=${Uri.encodeComponent(_bookerPhoneCtrl.text.trim())}&breakfast=$_addBreakfast&bed=${Uri.encodeComponent(_bedPreference)}&smoking=${Uri.encodeComponent(_smokingPreference)}&requests=${Uri.encodeComponent(allSpecialReqs)}&extraPrice=${(_addBreakfast ? 75000 * nights : 0) + (_addInsurance ? 15000 : 0)}',
    );
  }

  @override
  Widget build(BuildContext context) {
    Hotel hotel = MockData.hotels.first;
    final hotelState = context.read<HotelCubit>().state;
    if (hotelState is HotelLoaded) {
      hotel = hotelState.hotels.firstWhere((h) => h.id == widget.hotelId, orElse: () => hotelState.hotels.first);
    } else {
      hotel = MockData.hotels.firstWhere((h) => h.id == widget.hotelId, orElse: () => MockData.hotels.first);
    }

    final room = hotel.rooms.firstWhere(
      (r) => r.id == widget.roomId,
      orElse: () => hotel.rooms.isNotEmpty ? hotel.rooms.first : MockData.hotels.first.rooms.first,
    );

    final nights = DateHelper.calculateNights(_checkIn, _checkOut);
    final roomSubtotal = room.pricePerNight * nights;
    final breakfastTotal = _addBreakfast ? (75000 * nights) : 0;
    final insuranceTotal = _addInsurance ? 15000 : 0;
    const serviceFee = 25000;
    final grandTotal = roomSubtotal + breakfastTotal + insuranceTotal + serviceFee;

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
        title: const Text('Review Detail Pesanan', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700, fontSize: 16)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 110),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── 1. Card Ringkasan Hotel & Kamar ─────────────────────
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: CachedNetworkImage(
                          imageUrl: room.images.isNotEmpty ? room.images.first : hotel.images.first,
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
                              hotel.name,
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, fontFamily: 'Poppins'),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              hotel.area,
                              style: const TextStyle(fontSize: 11, color: AppColors.grey600),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(color: AppColors.emeraldLight, borderRadius: BorderRadius.circular(6)),
                              child: Text(
                                room.name,
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.emerald),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Divider(height: 1),
                  const SizedBox(height: 12),

                  // Kebijakan Pembatalan & Fast Pass
                  Row(
                    children: const [
                      Icon(Icons.check_circle_outline_rounded, size: 16, color: AppColors.emerald),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Bebas Pembatalan s/d 24 jam sebelum check-in',
                          style: TextStyle(fontSize: 11, color: AppColors.emerald, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: const [
                      Icon(Icons.qr_code_rounded, size: 16, color: AppColors.grey800),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Mendukung Fast Check-In QR Paperless (UU PDP)',
                          style: TextStyle(fontSize: 11, color: AppColors.grey800, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ─── 2. Jadwal Check-In & Check-Out ──────────────────────
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Jadwal Menginap', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                      TextButton(
                        onPressed: _pickDateRange,
                        style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                        child: const Text('Ubah Tanggal', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
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
                              Text(DateHelper.formatDate(_checkIn), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                              const Text('Mulai 14.00 WIB', style: TextStyle(fontSize: 10, color: AppColors.emerald, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: AppColors.grey200, borderRadius: BorderRadius.circular(8)),
                        child: Text('$nights Malam', style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700)),
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
                              Text(DateHelper.formatDate(_checkOut), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
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

            // ─── 3. Data Pemesan & Tamu Menginap ─────────────────────
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Data Pemesan (Kontak Utama)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                  const SizedBox(height: 4),
                  const Text('E-Voucher dan notifikasi check-in akan dikirimkan ke kontak ini.', style: TextStyle(fontSize: 10.5, color: AppColors.grey600)),
                  const SizedBox(height: 12),

                  _textField(_bookerNameCtrl, 'Nama Lengkap Pemesan', Icons.person_outline),
                  const SizedBox(height: 10),
                  _textField(_bookerEmailCtrl, 'Alamat Email', Icons.email_outlined, keyboard: TextInputType.emailAddress),
                  const SizedBox(height: 10),
                  _textField(_bookerPhoneCtrl, 'Nomor WhatsApp', Icons.phone_android_rounded, keyboard: TextInputType.phone),

                  const SizedBox(height: 14),
                  const Divider(height: 1),
                  const SizedBox(height: 8),

                  // Toggle Pesan untuk Orang Lain
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _isBookingForOther,
                    activeThumbColor: AppColors.emerald,
                    activeTrackColor: AppColors.emeraldLight,
                    title: const Text('Saya memesan untuk orang lain', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    subtitle: const Text('Nama tamu menginap berbeda dari pemesan', style: TextStyle(fontSize: 10.5, color: AppColors.grey600)),
                    onChanged: (val) => setState(() => _isBookingForOther = val),
                  ),

                  if (_isBookingForOther) ...[
                    const SizedBox(height: 8),
                    _textField(_guestNameCtrl, 'Nama Lengkap Tamu yang Menginap', Icons.badge_outlined),
                    const SizedBox(height: 4),
                    const Text('Wajib sesuai KTP/Paspor untuk verifikasi di resepsionis.', style: TextStyle(fontSize: 10, color: Colors.amber, fontWeight: FontWeight.w600)),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ─── 4. Pilihan Add-ons & Fasilitas Ekstra ───────────────
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Add-on & Preferensi Kamar', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                  const SizedBox(height: 12),

                  // Breakfast Add-on
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _addBreakfast ? const Color(0xFFF0FDF4) : AppColors.grey50,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: _addBreakfast ? const Color(0xFFBBF7D0) : AppColors.grey200),
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          value: _addBreakfast,
                          activeColor: AppColors.emerald,
                          onChanged: (val) => setState(() => _addBreakfast = val ?? false),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Tambah Sarapan Buffet Hotel', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                              Text('Sarapan lezat untuk 2 orang setiap pagi', style: TextStyle(fontSize: 10.5, color: Colors.grey.shade700)),
                            ],
                          ),
                        ),
                        Text(
                          '+Rp ${75 * nights}k',
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: AppColors.emerald),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Tipe Ranjang
                  const Text('Pilihan Ranjang:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.grey800)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    children: [
                      '1 Ranjang Besar (Double)',
                      '2 Ranjang Terpisah (Twin)',
                    ].map((b) {
                      final isSel = _bedPreference == b;
                      return ChoiceChip(
                        label: Text(b, style: TextStyle(fontSize: 11, fontWeight: isSel ? FontWeight.w700 : FontWeight.w500, color: isSel ? Colors.white : AppColors.grey800)),
                        selected: isSel,
                        selectedColor: AppColors.primary,
                        backgroundColor: AppColors.grey100,
                        onSelected: (val) => setState(() => _bedPreference = b),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),

                  // Preferensi Asap Rokok
                  const Text('Preferensi Rokok:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.grey800)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    children: [
                      'Bebas Rokok (Non-Smoking)',
                      'Boleh Merokok (Smoking)',
                    ].map((s) {
                      final isSel = _smokingPreference == s;
                      return ChoiceChip(
                        label: Text(s, style: TextStyle(fontSize: 11, fontWeight: isSel ? FontWeight.w700 : FontWeight.w500, color: isSel ? Colors.white : AppColors.grey800)),
                        selected: isSel,
                        selectedColor: AppColors.primary,
                        backgroundColor: AppColors.grey100,
                        onSelected: (val) => setState(() => _smokingPreference = s),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),

                  // Estimasi Waktu Tiba
                  const Text('Estimasi Waktu Tiba di Lobi:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.grey800)),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    initialValue: _arrivalTime,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.grey50,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.grey200)),
                    ),
                    items: [
                      '14.00 - 15.00 WIB',
                      '15.00 - 18.00 WIB',
                      '18.00 - 21.00 WIB',
                      'Tiba Larut Malam (Late Check-in)',
                    ].map((t) => DropdownMenuItem(value: t, child: Text(t, style: const TextStyle(fontSize: 12)))).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _arrivalTime = val);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ─── 5. Permintaan Khusus (Special Requests) ─────────────
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Permintaan Khusus (Opsional)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                  const SizedBox(height: 4),
                  const Text('Pihak hotel akan berusaha memenuhi permintaan Anda sesuai ketersediaan.', style: TextStyle(fontSize: 10.5, color: AppColors.grey600)),
                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: _quickRequestOptions.map((opt) {
                      final isSel = _selectedQuickRequests.contains(opt);
                      return FilterChip(
                        label: Text(opt, style: TextStyle(fontSize: 10.5, fontWeight: isSel ? FontWeight.w700 : FontWeight.w500, color: isSel ? AppColors.emerald : AppColors.grey800)),
                        selected: isSel,
                        selectedColor: AppColors.emeraldLight,
                        backgroundColor: AppColors.grey50,
                        checkmarkColor: AppColors.emerald,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        onSelected: (val) {
                          setState(() {
                            if (val) {
                              _selectedQuickRequests.add(opt);
                            } else {
                              _selectedQuickRequests.remove(opt);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _specialReqCtrl,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: 'Tuliskan catatan khusus tambahan (misal: dekorasi ulang tahun, dll)...',
                      hintStyle: const TextStyle(fontSize: 11, color: AppColors.grey400),
                      filled: true,
                      fillColor: AppColors.grey50,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.grey200)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ─── 6. Perlindungan Menginap (Stay Protection) ──────────
            _card(
              child: Row(
                children: [
                  Checkbox(
                    value: _addInsurance,
                    activeColor: AppColors.emerald,
                    onChanged: (val) => setState(() => _addInsurance = val ?? false),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Perlindungan Menginap (Stay Protection)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                        Text('Jaminan 100% refund jika sakit/rawat inap mendadak & ganti rugi barang tertinggal.', style: TextStyle(fontSize: 10, color: AppColors.grey600)),
                      ],
                    ),
                  ),
                  const Text('+Rp 15k', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11.5, color: AppColors.emerald)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ─── 7. Rincian Biaya Transparan ────────────────────────
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Rincian Pembayaran', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                  const SizedBox(height: 10),
                  _priceRow('${room.name} ($nights malam)', 'Rp ${_formatPrice(roomSubtotal)}'),
                  if (_addBreakfast) _priceRow('Add-on Sarapan Buffet ($nights malam)', 'Rp ${_formatPrice(breakfastTotal)}'),
                  if (_addInsurance) _priceRow('Asuransi Perlindungan Menginap', 'Rp 15.000'),
                  _priceRow('Pajak & Biaya Pelayanan', 'Rp 25.000'),
                  const Divider(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Pembayaran', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                      Text(
                        'Rp ${_formatPrice(grandTotal)}',
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17, color: AppColors.emerald),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // ─── Sticky Bottom Bar ─────────────────────────────────────────
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Pembayaran', style: TextStyle(fontSize: 10.5, color: AppColors.grey600)),
                  Text(
                    'Rp ${_formatPrice(grandTotal)}',
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: AppColors.emerald, fontFamily: 'Poppins'),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () => _proceedToPayment(hotel, room, grandTotal, nights),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  elevation: 0,
                ),
                child: const Row(
                  children: [
                    Text('Lanjut Pembayaran', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                    SizedBox(width: 6),
                    Icon(Icons.arrow_forward_rounded, size: 16),
                  ],
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

  Widget _textField(TextEditingController ctrl, String hint, IconData icon, {TextInputType? keyboard}) {
    return TextField(
      controller: ctrl,
      keyboardType: keyboard,
      style: const TextStyle(fontSize: 12.5),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 12, color: AppColors.grey400),
        prefixIcon: Icon(icon, size: 18, color: AppColors.grey600),
        filled: true,
        fillColor: AppColors.grey50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.grey200)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.grey200)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.emerald, width: 1.5)),
      ),
    );
  }

  Widget _priceRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.grey600)),
          Text(value, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.grey900)),
        ],
      ),
    );
  }

  static String _formatPrice(int price) {
    return price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
  }
}
