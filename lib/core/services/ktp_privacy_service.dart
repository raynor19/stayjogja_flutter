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

  /// Ambil foto KTP dari Kamera atau Galeri
  Future<String?> pickKtpImage(ImageSource source) async {
    try {
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
      return null;
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
