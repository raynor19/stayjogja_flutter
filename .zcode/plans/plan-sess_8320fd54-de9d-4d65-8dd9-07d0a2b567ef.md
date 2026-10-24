# Rencana Implementasi: Fitur Wishlist Real-time Firestore, Download E-Voucher PDF Resmi, & Notifikasi Center

## 1. Ringkasan Fitur yang Akan Diimplementasikan

1. **Wishlist Real-time Cloud Firestore (`WishlistCubit`)**:
   - Simpan ID hotel favorit tamu ke dokumen Firestore `users/{userId}` (array `wishlist`) dan cache lokal `SharedPreferences`.
   - Tambahkan tombol **Heart Icon (Favorit)** interaktif di:
     - `HotelDetailPage`: Pojok kanan atas banner foto (bersebelahan dengan tombol back).
     - `_HotelSearchCard` di `HotelSearchPage`: Tombol love di atas gambar hotel.
   - Sinkronisasi sheet **"Wishlist Hotel Saya"** di `profile_page.dart` agar menampilkan hotel yang benar-benar difavoritkan oleh user secara dinamis (lengkap dengan empty state jika belum ada dan tombol hapus/buka hotel).

2. **Download & Share E-Voucher PDF Resmi (`PdfVoucherService`)**:
   - Memanfaatkan library `pdf: ^3.11.1` dan `printing: ^5.13.2` yang sudah ada di `pubspec.yaml`.
   - Membuat generator PDF E-Voucher berdesain elegan khas StayJogja:
     - Logo & Header Resmi StayJogja.
     - Badge Status Hijau *"LUNAS & TERKONFIRMASI"*.
     - Rincian Booking (Kode SJ-XXXXXX, Jadwal Menginap, Durasi Malam, Tipe Kamar, Total Biaya).
     - Data Tamu (Nama Lengkap, No. WhatsApp, Email, Status KTP).
     - **Barcode / QR Code Digital Asli** yang dapat dipindai oleh resepsionis langsung dari kertas/file PDF.
     - Stempel Digital *"TERVERIFIKASI RESMI STAYJOGJA — PAPERLESS FRONT DESK"*.
   - Menyediakan tombol aksi di `PaymentSuccessPage`:
     - Tombol *"Unduh PDF E-Voucher"* (membuka preview cetak/simpan PDF).
     - Tombol *"Bagikan Tiket"* (share file PDF ke WhatsApp/kontak via `Printing.sharePdf`).

3. **Notification Center di Beranda (`home_page.dart`)**:
   - Mengaktifkan tombol lonceng notifikasi di pojok kanan atas beranda (saat ini `onPressed: () {}`).
   - Menampilkan titik merah (*notification dot*) jika ada pemberitahuan baru.
   - Membuka modal sheet pemberitahuan dinamis:
     - Status Verifikasi KTP (Aktif/Terlindungi UU PDP).
     - Pengingat Jadwal Check-in Hotel aktif.
     - Kupon Promo Spesial (`STAYJOGJA10`).

---

## 2. Rincian Perubahan File

### A. State Management & Data Layer
1. **`lib/features/hotel/presentation/bloc/wishlist_cubit.dart`**:
   - Mengelola state `List<String> wishlistHotelIds`.
   - Method `toggleWishlist(String hotelId)`: toggle ID, simpan ke Firestore `users/{userId}` (`FieldValue.arrayUnion` / `arrayRemove`) dan SharedPreferences.
   - Method `loadWishlist()`: ambil daftar wishlist user saat inisialisasi.
2. **`lib/main.dart`**:
   - Daftarkan `WishlistCubit` ke root `MultiBlocProvider`.

### B. Service PDF
3. **`lib/core/services/pdf_voucher_service.dart`**:
   - Fungsi `generateAndPrintVoucherPdf(...)`: membuat dokumen PDF berbasis `pw.Document()` lengkap dengan styling StayJogja, QR barcode, dan metadata reservasi, lalu memanggil `Printing.layoutPdf()`.
   - Fungsi `shareVoucherPdf(...)`: membagikan PDF ke media lain via `Printing.sharePdf()`.

### C. Presentation / UI Layer
4. **`lib/features/hotel/presentation/pages/hotel_detail_page.dart`**:
   - Tambahkan tombol bookmark/love di header image (pojok kanan atas).
   - Warna love otomatis merah jika hotel ada di `WishlistCubit`, atau putih jika belum.
5. **`lib/features/hotel/presentation/pages/hotel_search_page.dart`**:
   - Tambahkan tombol bookmark/love di tiap kartu hotel.
6. **`lib/features/profile/presentation/pages/profile_page.dart`**:
   - Perbarui `_showWishlistSheet`: baca hotel secara dinamis dari `WishlistCubit.state` dan tampilkan kartu hotel favorit nyata.
7. **`lib/features/booking/presentation/pages/payment_success_page.dart`**:
   - Tambahkan baris tombol aksi: *"Cetak / Simpan PDF"* dan *"Bagikan Tiket"* di bawah tiket E-Voucher.
8. **`lib/features/home/presentation/pages/home_page.dart`**:
   - Hubungkan tombol lonceng notifikasi ke `_showNotificationSheet(context)` yang interaktif.

---

## 3. Rencana Pengujian & Validasi
1. Cek kompilasi dan linting menggunakan `flutter analyze`.
2. Uji toggle Wishlist di kartu hotel search dan detail hotel ➔ verifikasi ikon berubah merah dan muncul di sheet Wishlist profil.
3. Uji tombol "Unduh PDF E-Voucher" di halaman voucher ➔ verifikasi dokumen PDF ter-render rapi lengkap dengan QR code.
4. Uji tombol lonceng di beranda ➔ verifikasi muncul modal notifikasi.
5. Commit dan push ke GitHub `raynor19/stayjogja_flutter`.
