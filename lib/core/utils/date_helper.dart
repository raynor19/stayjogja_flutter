import 'package:intl/intl.dart';

class DateHelper {
  DateHelper._();

  static final DateFormat _idFormat = DateFormat('dd MMM yyyy');
  static final DateFormat _idShortFormat = DateFormat('dd MMM');

  /// Tanggal check-in default: Hari ini
  static DateTime get defaultCheckIn => DateTime.now();

  /// Tanggal check-out default: 2 hari ke depan
  static DateTime get defaultCheckOut => DateTime.now().add(const Duration(days: 2));

  /// Format ke teks tampilan: e.g. "25 Okt 2026"
  static String formatDate(DateTime date) {
    return _idFormat.format(date);
  }

  /// Format ke rentang teks pendek: e.g. "25 - 27 Okt"
  static String formatDateRange(DateTime checkIn, DateTime checkOut) {
    if (checkIn.month == checkOut.month && checkIn.year == checkOut.year) {
      return '${checkIn.day} - ${checkOut.day} ${_idFormat.format(checkOut).split(' ')[1]} ${checkOut.year}';
    }
    return '${_idShortFormat.format(checkIn)} - ${_idFormat.format(checkOut)}';
  }

  /// Hitung jumlah malam secara dinamis
  static int calculateNights(DateTime checkIn, DateTime checkOut) {
    final diff = checkOut.difference(checkIn).inDays;
    return diff > 0 ? diff : 1;
  }

  /// Parse dari string atau fallback ke default
  static DateTime parseOrDefault(String? dateStr, DateTime fallback) {
    if (dateStr == null || dateStr.isEmpty) return fallback;
    try {
      return _idFormat.parse(dateStr);
    } catch (_) {
      try {
        return DateTime.parse(dateStr);
      } catch (_) {
        return fallback;
      }
    }
  }
}
