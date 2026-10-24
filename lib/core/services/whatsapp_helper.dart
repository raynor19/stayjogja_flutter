import 'package:url_launcher/url_launcher.dart';

class WhatsAppHelper {
  WhatsAppHelper._();

  /// Bersihkan dan ubah nomor HP lokal (08...) ke format internasional (628...)
  static String formatPhone(String rawPhone) {
    if (rawPhone.isEmpty) return '6281234567890';
    String digits = rawPhone.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('0')) {
      digits = '62${digits.substring(1)}';
    } else if (!digits.startsWith('62')) {
      digits = '62$digits';
    }
    return digits;
  }

  /// Kirim ringkasan reservasi resmi ke WhatsApp tamu
  static Future<bool> sendBookingVoucher({
    required String targetPhone,
    required String guestName,
    required String bookingCode,
    required String hotelName,
    required String roomName,
    required String checkIn,
    required String checkOut,
    required int nights,
    required int totalPrice,
  }) async {
    final cleanPhone = formatPhone(targetPhone);
    final formattedPrice = totalPrice.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );

    final message = '''
*RESERVASI STAYJOGJA BERHASIL* ✨
Halo *$guestName*, terima kasih telah melakukan pemesanan akomodasi melalui aplikasi StayJogja!

🏨 *Hotel*: $hotelName
🛏️ *Kamar*: $roomName
📅 *Jadwal*: $checkIn s/d $checkOut ($nights Malam)
🏷️ *Kode Booking*: *$bookingCode*
💰 *Total Tagihan*: Rp $formattedPrice *(LUNAS & TERKONFIRMASI)*

⚡ *Petunjuk Fast Check-in*:
Tunjukkan QR Code E-Voucher Anda di meja resepsionis untuk check-in instan tanpa perlu fotokopi KTP fisik lagi (Sesuai UU Perlindungan Data Pribadi).

_Official StayJogja Hospitality Concierge_ 🌿
''';

    return await openWhatsApp(phone: cleanPhone, message: message.trim());
  }

  /// Chat langsung dengan Front Desk / Concierge Hotel
  static Future<bool> chatHotelConcierge({
    required String hotelName,
    String? phone,
    String? guestName,
  }) async {
    final targetPhone = formatPhone(phone ?? '081234567890');
    final message = 'Halo Resepsionis *$hotelName*, saya ${guestName ?? 'tamu StayJogja'} ingin menanyakan informasi mengenai akomodasi & check-in.';
    return await openWhatsApp(phone: targetPhone, message: message);
  }

  /// Membuka aplikasi WhatsApp via Universal Link wa.me
  static Future<bool> openWhatsApp({
    required String phone,
    required String message,
  }) async {
    final encodedMsg = Uri.encodeComponent(message);
    final urlString = 'https://wa.me/$phone?text=$encodedMsg';
    final uri = Uri.parse(urlString);

    try {
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        // Fallback coba intent langsung
        final fallbackUri = Uri.parse('whatsapp://send?phone=$phone&text=$encodedMsg');
        if (await canLaunchUrl(fallbackUri)) {
          return await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
        }
      }
    } catch (_) {}

    return false;
  }
}
