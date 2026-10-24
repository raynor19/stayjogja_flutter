# Rencana Implementasi: Halaman & Modal Detail Pemesanan Lengkap (Booking Detail) di Riwayat Booking

## 1. Analisis Kebutuhan
- **Kondisi Saat Ini**:
  Di halaman riwayat pemesanan (`bookings_page.dart`), kartu booking hanya memiliki 2 tombol: tombol *"AI Trip"* dan tombol *"E-Voucher"* (yang langsung membuka tiket QR).
- **Kebutuhan Pengguna**:
  Pengguna ingin bisa **melihat detail lengkap pemesanan hotel & detail trip yang sudah dibeli**:
  1. **Informasi Hotel & Kamar Lengkap**: Foto, nama hotel, bintang, tipe kamar, fasilitas kamar.
  2. **Detail Jadwal Menginap & Ketentuan**: Tanggal check-in (mulai 14.00 WIB), tanggal check-out (sebelum 12.00 WIB), jumlah malam.
  3. **Detail Tamu & Identitas**: Nama pemesan, nama tamu menginap, nomor WhatsApp, email, status verifikasi KTP (terlindung UU PDP).
  4. **Preferensi & Add-ons yang Dibeli**: Sarapan buffet hotel (Breakfast Included / Add-on), preferensi ranjang (*Double/Twin*), preferensi bebas rokok, dan permintaan khusus (*Special Requests*).
  5. **Rincian Pembayaran Transparan**: Harga kamar per malam x malam, biaya add-on sarapan, biaya layanan & pajak, diskon promo, total lunas, dan metode bayar.
  6. **Akses Cepat**:
     - Tombol *"Lihat E-Voucher & QR Code"*.
     - Tombol *"Rute Wisata AI di Sekitar Hotel Ini"*.
     - Tombol *"Unduh PDF E-Voucher"*.

---

## 2. Arsitektur Perubahan

### A. Halaman / Sheet Baru: `BookingDetailPage` (`lib/features/booking/presentation/pages/booking_detail_page.dart`)
Membuat halaman detail reservasi berdesain *Clean Luxury Mint* yang menampilkan seluruh rincian trip/akomodasi yang sudah dibeli:
- **Status Header Banner**:
  - Hijau emerald untuk `Lunas & Menunggu Check-in`.
  - Abu-abu netral untuk `Selesai Menginap` (menampilkan nomor kamar yang diberikan resepsionis, e.g. `Kamar 204`).
- **Section 1: Rincian Hotel & Kamar**:
  - Foto thumbnail, nama hotel, bintang, alamat kawasan, dan tipe kamar.
  - Tipe ranjang terpilih (`1 Double Bed (Besar)` / `2 Ranjang Terpisah`).
  - Preferensi kamar (`Bebas Asap Rokok`).
- **Section 2: Jadwal & Operasional Menginap**:
  - Tanggal Check-in: [Tanggal] Mulai 14.00 WIB.
  - Tanggal Check-out: [Tanggal] Sebelum 12.00 WIB.
  - Total Durasi: [N] Malam.
- **Section 3: Add-on & Permintaan Khusus**:
  - Sarapan: *"Termasuk Sarapan Buffet Hotel (2 Orang)"* atau *"Kamar Saja (Room Only)"*.
  - Permintaan khusus yang diteruskan ke resepsionis (e.g., *Lantai Tinggi, Kamar Tenang*).
- **Section 4: Data Tamu & Verifikasi**:
  - Nama Tamu, No. WhatsApp, Email.
  - Status KTP: *Terverifikasi Digital (UU PDP)*.
- **Section 5: Rincian Pembayaran & Invoice**:
  - Kode Booking: `SJ-XXXXXX`.
  - Metode Pembayaran: (QRIS, BCA VA, dll).
  - Breakdown harga lengkap (Kamar, Add-on, Pajak, Diskon).
- **Section 6: Action Buttons**:
  - Tombol *"Buka E-Voucher & QR"* ➔ Membuka QR Check-in.
  - Tombol *"Jelajahi Rute Wisata AI"* ➔ Membuka itinerary generator/viewer berdasarkan hotel ini.
  - Tombol *"Unduh PDF"* ➔ Mengunduh langsung file PDF voucher.

### B. Pembaruan Navigasi & Integrasi
1. **`lib/routes/app_router.dart`**:
   - Daftarkan route `AppRoutes.bookingDetail` (`/bookings/:id`) yang menerima objek `BookingEntity` (atau query parameters).
2. **`lib/features/booking/presentation/pages/bookings_page.dart`**:
   - Ketika kartu reservasi di-tap di area mana saja (selain tombol langsung), aplikasi membuka `BookingDetailPage` agar tamu dapat melihat detail lengkap trip/hotel yang sudah dibeli.
   - Tambahkan tombol kecil *"Detail Pesanan"* di samping tombol *"E-Voucher"*.

---

## 3. Rencana Pengujian & Validasi
1. Cek analisis kode dengan `flutter analyze` untuk memastikan tidak ada kesalahan kompilasi.
2. Buka tab Riwayat Pemesanan (`BookingsPage`):
   - Ketuk salah satu kartu reservasi yang sudah dibeli.
   - Pastikan halaman `BookingDetailPage` terbuka dengan seluruh rincian: nama hotel, kamar, tanggal, add-on sarapan, preferensi ranjang, data tamu, dan breakdown harga.
   - Coba tombol aksi di dalam detail: Buka E-Voucher QR, Rute AI, dan Unduh PDF.
3. Commit dan push perubahan ke GitHub `raynor19/stayjogja_flutter`.
