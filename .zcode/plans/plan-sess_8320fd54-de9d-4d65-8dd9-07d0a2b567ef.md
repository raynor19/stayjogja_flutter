# Rencana Implementasi: Fitur OCR KTP Otomatis, Autofill Data, & Dynamic Privacy Masking

## 1. Analisis Kebutuhan Pengguna
Pengguna menginginkan:
1. **Fitur OCR KTP**: Saat user mengambil foto KTP (atau memilih dari galeri), sistem langsung membaca dan mengekstrak semua field teks dokumen KTP (NIK, Nama Lengkap, Tempat/Tgl Lahir, Jenis Kelamin, Alamat, dsb).
2. **Autofill Otomatis**: Hasil bacaan OCR langsung mengisikan field form (Nama & NIK) secara otomatis tanpa perlu diketik manual oleh user.
3. **Dynamic Privacy Masking**: Data sensitif (Alamat, Agama, Status Perkawinan, RT/RW, dsb) otomatis disamarkan (blur / frosted glass) baik di preview aplikasi mobile maupun di modal check-in web resepsionis. Yang tetap jernih dan tajam 100% adalah **Pasfoto Wajah Tamu** dan **Nama Lengkap**.

---

## 2. Pilihan Arsitektur OCR: Hybrid Vision & Intelligent Client Parser

Di web server `Stayjogja` sudah terdapat route `/api/ocr/scan-ktp` yang siap menggunakan Gemini Multimodal Vision API, dan di sisi Flutter kita juga dapat menyediakan **Client-side Intelligent KTP OCR Engine** (RegExp & Pattern Matcher) sehingga:
- Jika terhubung ke server backend atau online: Memanfaatkan AI Multimodal Vision untuk akurasi tertinggi membaca NIK 16-digit, Nama, Tempat Lahir, dsb.
- Jika offline / standalone: Client-side parser mengekstrak pola NIK (`3\d{15}`) dan pola Nama dari KTP secara instan.
- **Autofill Real-time**: Begitu foto selesai dipilih, UI menampilkan status animasi *"Menganalisis Dokumen KTP dengan OCR AI..."* ➔ Form `Nama Lengkap` dan `NIK` otomatis terisi (autofill).
- **Privacy Masking**: Menyimpan data hasil OCR dan men-generate preview kartu KTP di mana area alamat dan data sensitif di-blur frosted glass, sedangkan nama dan pasfoto wajah tetap tajam.

---

## 3. Rincian Perubahan File

### A. Mobile App (`stayjogja_flutter`)

1. **`lib/core/services/ktp_privacy_service.dart`**:
   - Tambahkan method `extractKtpData(String base64Image)`:
     - Melakukan parsing OCR cerdas (mendukung endpoint `/api/ocr/scan-ktp` dan parsing client pattern NIK/Nama).
     - Mengembalikan objek `KtpOcrResult` berisi:
       - `nik`: String 16 digit
       - `nama`: Nama lengkap
       - `tempatTanggalLahir`: TTL
       - `alamat`: Alamat KTP
       - `isSuccess`: bool
2. **`lib/features/profile/presentation/widgets/ktp_verification_sheet.dart`**:
   - Tambahkan state indikator OCR: `_isScanningOcr`.
   - Update `_pickImage()`:
     - Setelah foto berhasil diambil, jalankan OCR:
     - Tampilkan shimmer / banner: *"Membaca teks KTP dengan OCR cerdas..."*.
     - Begitu teks terbaca, panggil `_nikCtrl.text = ocrResult.nik` dan `_nameCtrl.text = ocrResult.nama` (**Autofill Otomatis**).
     - Berikan feedback SnackBar: *"Data NIK & Nama berhasil diekstrak otomatis dari KTP!"*.
   - Pada preview KTP: Tampilkan informasi data yang diekstrak dengan badge privasi hijau (*"Data Sensitif Di-blur Sesuai UU PDP"*).

3. **`lib/features/auth/presentation/bloc/auth_cubit.dart` & `UserEntity`**:
   - Simpan objek detail KTP (nik, nama, alamat, status) agar saat checkout hotel, reservasi langsung membawa data lengkap KTP ter-masking.

### B. Web Receptionist (`Stayjogja`)

1. **`public/js/resepsionis.js`**:
   - Perbarui fungsi `buildPersonalizedKtpSvg(resv)` dan tampilan alokasi kamar:
     - Membaca data hasil OCR (Nama, NIK Masked, Pasfoto).
     - Kolom Alamat, Agama, dan data sensitif lainnya otomatis tertutup efek **Gaussian Blur Frosted Glass** dengan cap watermark resmi *"DILINDUNGI PRIVASI TAMU (UU PDP)"*.
     - Pasfoto tamu di sebelah kanan tampil tajam & jernih 100% untuk validasi pencocokan wajah fisik di meja resepsionis.

---

## 4. Rencana Pengujian
1. Jalankan `flutter analyze` untuk memastikan tidak ada kesalahan kompilasi.
2. Uji alur pemilihan foto KTP di `KtpVerificationSheet`:
   - Pastikan loading OCR berjalan mulus tanpa freeze atau crash.
   - Pastikan field NIK dan Nama Lengkap otomatis terisi (autofill).
   - Pastikan area alamat dan data pribadi tertutup blur di preview.
3. Lakukan reservasi hotel dan buka di web resepsionis untuk memastikan resepsionis melihat foto jernih & nama jelas dengan data sensitif ter-blur.
4. Commit dan push perubahan ke GitHub `raynor19/stayjogja_flutter` dan `raynor19/Stayjogja`.
