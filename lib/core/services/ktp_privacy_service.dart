import 'dart:convert';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

class KtpPrivacyResult {
  final String base64Original;
  final String base64Masked;
  final String? extractedNik;
  final String? extractedName;

  const KtpPrivacyResult({
    required this.base64Original,
    required this.base64Masked,
    this.extractedNik,
    this.extractedName,
  });
}

class KtpPrivacyService {
  final ImagePicker _picker = ImagePicker();

  /// Cek apakah kamera didukung pada device / runtime saat ini
  bool isCameraSupported() {
    try {
      return _picker.supportsImageSource(ImageSource.camera);
    } catch (_) {
      return false;
    }
  }

  /// Ambil foto KTP dari Kamera atau Galeri secara aman
  Future<String?> pickKtpImage(ImageSource source) async {
    try {
      // Jika kamera dipanggil di iOS Simulator (kamera fisik tidak ada), fallback ke Galeri
      if (source == ImageSource.camera) {
        final supported = isCameraSupported();
        if (!supported) {
          return await pickKtpImage(ImageSource.gallery);
        }
      }

      final XFile? photo = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 82,
      );

      if (photo == null) return null;

      final Uint8List bytes = await photo.readAsBytes();
      return 'data:image/jpeg;base64,${base64Encode(bytes)}';
    } catch (_) {
      // Jika terjadi platform exception pada kamera simulator, coba galeri
      try {
        final XFile? photo = await _picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 1024,
          maxHeight: 1024,
          imageQuality: 82,
        );
        if (photo == null) return null;
        final Uint8List bytes = await photo.readAsBytes();
        return 'data:image/jpeg;base64,${base64Encode(bytes)}';
      } catch (_) {
        return null;
      }
    }
  }

  /// Validasi NIK Indonesia (16 digit angka)
  static bool isValidNik(String nik) {
    final clean = nik.replaceAll(RegExp(r'\s+'), '');
    return RegExp(r'^\d{16}$').hasMatch(clean);
  }

  /// Samarkan NIK untuk perlindungan privasi (misal: 327508******0004)
  static String maskNik(String nik) {
    final clean = nik.replaceAll(RegExp(r'\s+'), '');
    if (clean.length != 16) return clean;
    return '${clean.substring(0, 6)}******${clean.substring(12)}';
  }
}
