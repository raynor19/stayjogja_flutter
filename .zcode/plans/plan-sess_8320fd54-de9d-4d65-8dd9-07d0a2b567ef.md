# Rencana Implementasi: Halaman Review Detail Pemesanan ala Traveloka/Tiket.com Sebelum Pembayaran

## 1. Jawaban Pertanyaan Pengguna:
### A. "Bentuk Notifikasi HP-nya Gimana?"
Di smartphone tamu (baik Android maupun iOS), notifikasi muncul di **Notification Drawer (Tirai Atas Layar HP)** dan **Lock Screen (Layar Kunci)** persis seperti ini:

```
┌─────────────────────────────────────────────────────────────┐
│ 🛎️ StayJogja • 11:00                                        │
│ Pengingat Check-Out: 1 Jam Lagi                             │
│ Halo Raynor, waktu check-out kamar di Hotel Tentrem adalah  │
│ pukul 12:00 WIB. Pastikan tidak ada barang tertinggal ya! ✨ │
└─────────────────────────────────────────────────────────────┘
```
- **Ikon Notifikasi**: Logo resmi StayJogja (`@mipmap/ic_launcher`).
- **Suara & Getar**: Standar notifikasi sistem prioritas tinggi (*High Priority Notification*).
- **Aksi Klik**: Mengetuk banner notifikasi akan langsung membuka aplikasi StayJogja ke halaman riwayat pemesanan / E-Voucher.

---

### B. "Kurang 1 Halaman Lagi: Detail Pesanan Sebelum Bayar (ala Traveloka)"
Di Traveloka & Tiket.com, alur pemesanan hotel standar terdiri dari:
1. **Detail Hotel & Kamar** ➔ Klik *"Pilih Kamar"*
2. **Halaman Review & Detail Pesanan Lengkap (*Pre-Payment Booking Review*)**:
   - Ringkasan Hotel & Kamar (Foto, Tipe Kamar, Ranjang, Bebas Pembatalan).
   - Jadwal Check-in (Mulai 14:00 WIB) & Check-out (Sebelum 12:00 WIB).
   - Data Pemesan vs Data Tamu Menginap (bisa sama atau pesan untuk orang lain).
   - **Pilihan Add-on & Ekstra**:
     - Tambah Sarapan Buffet (*Breakfast Add-on*).
     - Pilihan Ranjang: 1 Bed Besar (Double/King) atau 2 Bed Terpisah (Twin).
     - Pilihan Kamar Bebas Asap Rokok (*Non-Smoking* vs *Smoking*).
     - Estimasi Waktu Kedatangan (14.00-15.00, 18.00-20.00, Tiba Larut Malam).
   - **Permintaan Khusus (*Special Requests*)**: Lantai Tinggi (*High Floor*), Kamar Tenang, Catatan Tambahan.
   - **Asuransi / Perlindungan Menginap (*Stay Protection*)**: Opsional jaminan pembatalan mendadak.
   - **Rincian Biaya Transparan (*Price Breakdown*)**: Harga kamar x malam, Add-ons, Pajak & Layanan, Diskon Voucher, Total Tagihan.
3. **Sticky Bottom Bar**: Menampilkan Total Bayar + Tombol *"Lanjut ke Pembayaran"*.

---

## 2. Rincian Perubahan & File yang Dibuat

### A. Halaman Baru: `BookingReviewPage` (`lib/features/booking/presentation/pages/booking_review_page.dart`)
1. **Header & Card Ringkasan Hotel**:
   - Foto thumbnail kamar, nama hotel, bintang, alamat/kawasan.
   - Badge *"Bebas Pembatalan s/d 24 Jam"* & *"Fast Check-In QR Ready"*.
2. **Jadwal Check-In & Check-Out**:
   - Check-in: [Tanggal] (Mulai 14:00 WIB).
   - Check-out: [Tanggal] (Sebelum 12:00 WIB).
   - Total malam menginap.
3. **Formulir Data Pemesan & Tamu Menginap**:
   - Autofill dari `AuthCubit`: Nama Pemesan, Email, Nomor WhatsApp.
   - Checkbox switch: *"Saya memesan untuk orang lain"*. Jika dicentang, muncul input Nama Tamu Menginap.
4. **Pilihan Add-ons & Fasilitas Ekstra**:
   - Checkbox: *"Tambah Sarapan Buffet Hotel (Breakfast)"* (+Rp 75.000 / malam).
   - Radio Chips: Tipe Ranjang (*1 Ranjang Besar* vs *2 Ranjang Terpisah*).
   - Radio Chips: Preferensi Rokok (*Bebas Rokok / Non-Smoking* vs *Boleh Merokok*).
   - Dropdown: Estimasi Waktu Tiba di Hotel.
5. **Permintaan Khusus (*Special Requests*)**:
   - Pilihan chips cepat: *Lantai Tinggi*, *Kamar Tenang*, *Dekat Lift*, dll.
   - Text area catatan khusus untuk resepsionis.
6. **Perlindungan Menginap (*Stay Protection*)**:
   - Checkbox proteksi pembatalan darurat (+Rp 15.000).
7. **Rincian Biaya Dinamis (*Live Price Breakdown*)**:
   - Menghitung real-time: `(Harga Kamar x Malam) + (Sarapan jika dicentang) + (Proteksi jika dicentang) + Biaya Layanan - Diskon Promo`.
8. **Sticky Bottom Bar**:
   - Menempel di bawah layar menampilkan Total Bayar dan tombol *"Lanjut ke Pembayaran"*.

### B. Pembaruan Alur Rute & Navigasi
1. **`lib/core/constants/app_constants.dart`**:
   - Tambahkan `static const String bookingReview = '/booking/review';`.
2. **`lib/routes/app_router.dart`**:
   - Daftarkan route `AppRoutes.bookingReview`:
     Menerima `hotelId`, `roomId`, `cin`, `cout`.
   - Dari `HotelDetailPage`: Tombol *"Book Room"* mengarahkan ke `bookingReview`.
   - Dari `BookingReviewPage`: Tombol *"Lanjut ke Pembayaran"* membawa seluruh data rekap lengkap (termasuk add-ons sarapan, request bed, data pemesan/tamu) ke `CheckoutPage` (Halaman Pembayaran & Pemilihan Metode Bayar).

### C. Pembaruan Entity & Persistence Firestore
1. **`lib/features/booking/domain/entities/booking.dart` & `booking_remote_datasource.dart`**:
   - Tambahkan field opsional: `hasBreakfastAddon`, `bedPreference`, `smokingPreference`, `specialRequests`.
   - Data ini ikut tersimpan ke Firestore `bookings` dan langsung terbaca oleh web resepsionis saat check-in!

---

## 3. Rencana Pengujian & Validasi
1. Cek kompilasi kode dengan `flutter analyze`.
2. Uji alur dari `HotelDetailPage`:
   - Klik *"Book Room"* ➔ Masuk ke `BookingReviewPage` (bukan langsung bayar).
   - Centang *"Tambah Sarapan"* ➔ Pastikan total harga bertambah otomatis secara real-time.
   - Pilih jenis ranjang & isi permintaan khusus.
   - Klik *"Lanjut ke Pembayaran"* ➔ Beralih ke halaman pembayaran dengan rincian yang sudah di-update.
3. Selesaikan pembayaran ➔ E-Voucher terbit lengkap dengan rincian sarapan/permintaan khusus.
4. Buka Web Resepsionis ➔ Pastikan data permintaan khusus dan sarapan terbaca di front desk.
5. Commit dan push ke Git `raynor19/stayjogja_flutter`.
