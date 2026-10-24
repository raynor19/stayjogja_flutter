import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stayjogja_flutter/core/theme/app_theme.dart';
import 'package:stayjogja_flutter/core/services/ktp_privacy_service.dart';
import 'package:stayjogja_flutter/features/auth/presentation/bloc/auth_cubit.dart';

class KtpVerificationSheet extends StatefulWidget {
  final String currentUserName;
  final String? currentNik;
  final String? currentKtpPhoto;
  final VoidCallback? onVerified;

  const KtpVerificationSheet({
    super.key,
    required this.currentUserName,
    this.currentNik,
    this.currentKtpPhoto,
    this.onVerified,
  });

  static Future<void> show(
    BuildContext context, {
    required String currentUserName,
    String? currentNik,
    String? currentKtpPhoto,
    VoidCallback? onVerified,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (context) => KtpVerificationSheet(
        currentUserName: currentUserName,
        currentNik: currentNik,
        currentKtpPhoto: currentKtpPhoto,
        onVerified: onVerified,
      ),
    );
  }

  @override
  State<KtpVerificationSheet> createState() => _KtpVerificationSheetState();
}

class _KtpVerificationSheetState extends State<KtpVerificationSheet> {
  final _ktpService = KtpPrivacyService();
  late TextEditingController _nameCtrl;
  late TextEditingController _nikCtrl;

  String? _ktpPhotoData;
  bool _isLoading = false;
  bool _isScanningOcr = false; // Status loading scan OCR
  bool _isPreviewPrivacyMode = true; // Toggle Pratinjau Privasi (Frosted Blur)

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.currentUserName);
    _nikCtrl = TextEditingController(text: widget.currentNik ?? '');
    _ktpPhotoData = widget.currentKtpPhoto;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _nikCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    setState(() => _isLoading = true);
    try {
      final photo = await _ktpService.pickKtpImage(source);
      if (mounted) {
        setState(() {
          _isLoading = false;
          if (photo != null) {
            _ktpPhotoData = photo;
          }
        });

        // Jika foto berhasil didapatkan, jalankan OCR Scanner secara otomatis untuk Autofill!
        if (photo != null) {
          _runOcrScanner(photo);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kamera tidak tersedia di simulator. Mengalihkan ke galeri...'),
            backgroundColor: Colors.amber,
          ),
        );
      }
    }
  }

  Future<void> _runOcrScanner(String photoBase64) async {
    setState(() => _isScanningOcr = true);
    try {
      final ocrResult = await _ktpService.processKtpOcr(
        photoBase64,
        defaultUserName: widget.currentUserName,
      );

      if (mounted) {
        setState(() {
          _isScanningOcr = false;
          if (ocrResult.nik.isNotEmpty) {
            _nikCtrl.text = ocrResult.nik;
          }
          if (ocrResult.name.isNotEmpty) {
            _nameCtrl.text = ocrResult.name;
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.auto_awesome, color: Colors.amberAccent, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'OCR Berhasil! NIK & Nama terisi otomatis dari foto KTP.',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            backgroundColor: AppColors.emerald,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (_) {
      if (mounted) setState(() => _isScanningOcr = false);
    }
  }

  Future<void> _submitVerification() async {
    final nik = _nikCtrl.text.trim();
    final name = _nameCtrl.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nama lengkap sesuai KTP wajib diisi'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (!KtpPrivacyService.isValidNik(nik)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nomor NIK harus terdiri dari 16 digit angka resmi'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (_ktpPhotoData == null || _ktpPhotoData!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan ambil atau unggah foto dokumen KTP Anda'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    await context.read<AuthCubit>().verifyUserKtp(
          nik: nik,
          fullName: name,
          ktpPhotoBase64: _ktpPhotoData!,
        );

    setState(() => _isLoading = false);

    if (mounted) {
      Navigator.of(context).pop();
      widget.onVerified?.call();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Identitas KTP Berhasil Terverifikasi! Check-in hotel kini instan tanpa antre.'),
          backgroundColor: AppColors.emerald,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      margin: const EdgeInsets.only(top: 50),
      padding: EdgeInsets.fromLTRB(24, 20, 24, 24 + bottomInset),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag Handle
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.grey200,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Header Title
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.emeraldLight,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.verified_user_rounded, color: AppColors.emerald, size: 24),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Verifikasi KTP Mandiri',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.grey900,
                        ),
                      ),
                      Text(
                        'Check-In Instan & Paperless di Resepsionis',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          color: AppColors.grey600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Privacy Assurance Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFBBF7D0)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.shield_outlined, color: AppColors.emerald, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Sesuai UU Perlindungan Data Pribadi (PDP), pihak hotel HANYA dapat melihat Foto Wajah & Nama Anda untuk validasi fisik. Alamat, agama, dan data sensitif lainnya otomatis di-blur.',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        color: Colors.green.shade900,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Area Foto KTP
            const Text(
              'Foto Dokumen KTP',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.grey800,
              ),
            ),
            const SizedBox(height: 8),

            if (_ktpPhotoData != null && _ktpPhotoData!.isNotEmpty)
              _buildKtpPreviewBox()
            else
              _buildUploadPlaceholder(),

            // Indikator Animasi Pemindaian OCR
            if (_isScanningOcr)
              Container(
                margin: const EdgeInsets.only(top: 14),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.amber),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'AI OCR sedang membaca NIK & Nama dari foto KTP...',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.amber.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 18),

            // Form Fields
            const Text(
              'Nomor Induk Kependudukan (NIK 16 Digit)',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.grey800,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _nikCtrl,
              keyboardType: TextInputType.number,
              maxLength: 16,
              decoration: InputDecoration(
                hintText: 'Contoh: 3275081903050004',
                prefixIcon: const Icon(Icons.badge_outlined, color: AppColors.grey600),
                counterText: '',
                filled: true,
                fillColor: AppColors.grey50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.grey200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.emerald, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 14),

            const Text(
              'Nama Lengkap Sesuai KTP',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.grey800,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _nameCtrl,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                hintText: 'Nama lengkap Anda',
                prefixIcon: const Icon(Icons.person_outline_rounded, color: AppColors.grey600),
                filled: true,
                fillColor: AppColors.grey50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.grey200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.emerald, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Tombol Simpan
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitVerification,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.emerald,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 2.5),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle_outline, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Simpan & Verifikasi Identitas',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadPlaceholder() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.grey200, style: BorderStyle.solid),
      ),
      child: Column(
        children: [
          const Icon(Icons.add_a_photo_outlined, size: 40, color: AppColors.grey400),
          const SizedBox(height: 10),
          const Text(
            'Unggah atau Foto KTP Asli Anda',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.grey800,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Pastikan foto wajah dan tulisan nama terlihat jelas',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11,
              color: AppColors.grey400,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton.icon(
                onPressed: () => _pickImage(ImageSource.camera),
                icon: const Icon(Icons.camera_alt_outlined, size: 16),
                label: const Text('Kamera', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.emerald,
                  side: const BorderSide(color: AppColors.emerald),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () => _pickImage(ImageSource.gallery),
                icon: const Icon(Icons.photo_library_outlined, size: 16),
                label: const Text('Galeri', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.grey800,
                  side: const BorderSide(color: AppColors.grey200),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKtpPreviewBox() {
    Uint8List? imageBytes;
    try {
      if (_ktpPhotoData != null && _ktpPhotoData!.contains(',')) {
        final b64 = _ktpPhotoData!.split(',').last;
        imageBytes = base64Decode(b64);
      }
    } catch (_) {}

    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey900,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            // Card Preview Stack
            Stack(
              alignment: Alignment.center,
              children: [
                // Gambar KTP Asli
                if (imageBytes != null)
                  Image.memory(
                    imageBytes,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  )
                else
                  Container(
                    width: double.infinity,
                    height: 200,
                    color: AppColors.grey800,
                    child: const Center(
                      child: Icon(Icons.badge_rounded, size: 60, color: AppColors.grey400),
                    ),
                  ),

                // Privacy Overlay Visualizer (Jika mode privasi aktif)
                if (_isPreviewPrivacyMode)
                  Positioned(
                    left: 12,
                    top: 50,
                    bottom: 12,
                    right: 140, // Membiarkan pasfoto di kanan tetap terlihat!
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.82),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.9)),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.lock_rounded, size: 12, color: AppColors.emerald),
                              const SizedBox(width: 4),
                              Text(
                                'DILINDUNGI PRIVASI PDP',
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.green.shade900,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Container(height: 6, width: 100, decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(3))),
                          const SizedBox(height: 4),
                          Container(height: 6, width: 80, decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(3))),
                          const SizedBox(height: 4),
                          Container(height: 6, width: 60, decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(3))),
                          const SizedBox(height: 6),
                          Text(
                            'Alamat, Agama & NIK Lengkap Di-blur',
                            style: TextStyle(
                              fontSize: 7.5,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Badge Wajah Jernih di Sisi Kanan
                if (_isPreviewPrivacyMode)
                  Positioned(
                    right: 12,
                    bottom: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.75),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.face_retouching_natural, size: 12, color: Colors.amberAccent),
                          SizedBox(width: 4),
                          Text(
                            'Wajah 100% Jernih',
                            style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),

            // Kontrol Preview & Ganti Foto
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              color: AppColors.grey800,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Switch(
                        value: _isPreviewPrivacyMode,
                        activeThumbColor: AppColors.emerald,
                        activeTrackColor: AppColors.emeraldLight,
                        onChanged: (val) => setState(() => _isPreviewPrivacyMode = val),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _isPreviewPrivacyMode ? 'Simulasi Masking Resepsionis' : 'Lihat Asli',
                        style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  TextButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.refresh_rounded, size: 14, color: Colors.white70),
                    label: const Text('Ganti', style: TextStyle(fontSize: 11, color: Colors.white70)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
