import 'dart:math';

class LocationHelper {
  LocationHelper._();

  // Koordinat Titik Pusat Kota / Tugu Yogyakarta / Titik Nol Km
  static const double centerJogjaLat = -7.7956;
  static const double centerJogjaLng = 110.3695;

  /// Menghitung jarak garis lurus (km) antara dua koordinat menggunakan Haversine Formula
  static double calculateDistanceKm({
    required double lat1,
    required double lon1,
    double lat2 = centerJogjaLat,
    double lon2 = centerJogjaLng,
  }) {
    const double p = 0.017453292519943295; // Math.PI / 180
    final double a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    final double distanceKm = 12742 * asin(sqrt(a)); // 2 * R * asin... (R = 6371 km)
    return double.parse(distanceKm.toStringAsFixed(1));
  }

  /// Menghasilkan teks pinpoint landmark yang informatif dan kontekstual
  static String getPinpointText({
    required String area,
    required double lat,
    required double lng,
  }) {
    final double distToCenter = calculateDistanceKm(lat1: lat, lon1: lng);

    switch (area.toLowerCase()) {
      case 'malioboro':
        if (distToCenter < 1.0) {
          return '${(distToCenter * 1000).toInt()} m dari Malioboro Walk';
        }
        return '$distToCenter km dari Pusat Malioboro';
      case 'kraton':
        return '$distToCenter km dari Titik 0 KM & Kraton';
      case 'prawirotaman':
        return '$distToCenter km dari Pusat Kota • 300 m dari Kafe Seni';
      case 'kotagede':
        return '$distToCenter km dari Pusat Kota • Sentra Perak';
      case 'kaliurang':
        return '$distToCenter km dari Pusat Kota • Lereng Merapi';
      case 'sleman':
        return '$distToCenter km dari Pusat Kota Jogja';
      case 'bantul':
        if (distToCenter > 20.0) {
          return '$distToCenter km dari Pusat Kota • Dekat Pantai Parangtritis';
        }
        return '$distToCenter km dari Pusat Kota • Sentra Gerabah Kasongan';
      case 'gunungkidul':
        return '$distToCenter km dari Pusat Kota • Kawasan Pantai Pasir Putih';
      case 'kulon progo':
        return '$distToCenter km dari Pusat Kota • Dekat Bandara YIA';
      default:
        return '$distToCenter km dari Pusat Kota Jogja';
    }
  }

  /// Membuka URL Google Maps untuk navigasi langsung ke koordinat hotel
  static String getGoogleMapsUrl({
    required double lat,
    required double lng,
    required String placeName,
  }) {
    final query = Uri.encodeComponent('$placeName, Yogyakarta');
    return 'https://www.google.com/maps/search/?api=1&query=$lat,$lng&query_place_id=$query';
  }
}
