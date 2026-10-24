# Rencana Implementasi: Download Otomatis File PDF E-Voucher Langsung ke Penyimpanan Perangkat (Auto-Download PDF)

## 1. Analisis Kebutuhan
- **Kondisi Sebelumnya**:
  Saat ini method `PdfVoucherService.printOrSaveVoucher` memanggil `Printing.layoutPdf()`, yang membuka dialog sistem cetak (AirPrint di iOS / Print Spooler di Android). Pengguna harus memilih printer atau menekan tombol simpan secara manual.
- **Kebutuhan Pengguna**:
  Pengguna menginginkan file PDF **langsung otomatis terunduh (*auto-download*)** dan tersimpan ke penyimpanan lokal perangkat (folder *Downloads* / *Documents* perangkat), memunculkan notifikasi atau SnackBar sukses:  
  *`"E-Voucher berhasil diunduh ke folder Dokumen/Download: Voucher-StayJogja-SJ-XXXXXX.pdf"`*, serta tombol opsional untuk langsung membuka file PDF tersebut.

---

## 2. Arsitektur Solusi Teknis

Memanfaatkan package yang sudah terpasang:
- `path_provider: ^2.1.5`
- `pdf: ^3.11.1`
- `dart:io` (`File`)
- `open_file` / `url_launcher`

### Alur Kerja Auto-Download PDF:
1. `PdfVoucherService.downloadVoucherPdf(...)`:
   - Men-generate byte dokumen PDF A4 resmi (`Uint8List`).
   - Mengambil direktori unduhan perangkat:
     - Di **Android**: Mencoba `getDownloadsDirectory()` atau `getExternalStorageDirectory()`, fallback ke `getApplicationDocumentsDirectory()`.
     - Di **iOS**: Menggunakan `getApplicationDocumentsDirectory()` yang langsung tersinkron ke aplikasi *Files (Berkas)* di iPhone.
   - Menulis file bytes ke disk:
     `final file = File('${directory.path}/Voucher-StayJogja-$bookingCode.pdf');`
     `await file.writeAsBytes(pdfBytes, flush: true);`
   - Mengembalikan path file yang berhasil disimpan (`file.path`).
2. Di UI (`payment_success_page.dart`):
   - Ubah label tombol dari *"Cetak / PDF"* menjadi **"Unduh PDF E-Voucher"** (`Icons.download_rounded`).
   - Saat tombol ditekan:
     - Tampilkan loading singkat.
     - Eksekusi `PdfVoucherService.downloadVoucherPdf(...)`.
     - Tampilkan SnackBar sukses berwarna hijau:
       `"E-Voucher berhasil diunduh: Voucher-StayJogja-$bookingCode.pdf"` dengan action tombol *"Buka File"*.

---

## 3. Rincian Perubahan File

### A. Core Service (`lib/core/services/pdf_voucher_service.dart`)
- Tambahkan method `downloadVoucherPdf(...)`:
  - Mengambil direktori simpan via `path_provider` (`getApplicationDocumentsDirectory` / `getDownloadsDirectory`).
  - Menulis byte PDF ke file fisik.
  - Mengembalikan `String filePath`.

### B. UI Presentation (`lib/features/booking/presentation/pages/payment_success_page.dart`)
- Update tombol aksi menjadi:
  - **"Unduh PDF"** (`Icons.file_download_outlined`): langsung mengunduh dan menyimpan file `.pdf` ke HP secara otomatis tanpa dialog printer.
  - **"Bagikan Tiket"** (`Icons.share_rounded`): membagikan file PDF ke WhatsApp / kontak.

---

## 4. Rencana Pengujian
1. Jalankan `flutter analyze` untuk memastikan tidak ada kesalahan kompilasi.
2. Uji tombol "Unduh PDF" pada halaman sukses:
   - Verifikasi file PDF langsung tersimpan di storage perangkat.
   - Verifikasi SnackBar notifikasi sukses muncul dengan nama file yang benar.
3. Commit dan push perubahan ke GitHub `raynor19/stayjogja_flutter`.
