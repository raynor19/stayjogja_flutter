# Rencana Implementasi: Filter Tanggal Menginap & Pengecekan Ketersediaan Kamar (Availability Checker)

## 1. Analisis Kebutuhan & Masalah Saat Ini
1. **Header Tanggal Hardcoded**: Di halaman pencarian hotel (`hotel_search_page.dart`), teks tanggal tertulis mati `'2 guests • 25-27 Oct'`. Pengguna tidak bisa mengubah tanggal menginap.
2. **Tidak Ada Validasi Ketersediaan Kamar**: Pengguna bisa mencari hotel tanpa mempertimbangkan apakah kamar tersedia pada rentang tanggal tersebut.
3. **Tanggal Tidak Diteruskan ke Detail & Checkout**: Saat user memilih hotel dan memesan kamar, tanggal menginap tidak diteruskan, sehingga checkout kembali ke tanggal default hari ini.

---

## 2. Solusi & Alur Bisnis (Probis)

1. **Pemilihan Tanggal Interaktif di Search Bar**:
   - Di bagian atas Search Bar, pengguna dapat mengklik banner tanggal/tamu untuk membuka **Interactive Date Range Picker** (`showDateRangePicker`).
   - Tanggal default dimulai dari hari ini s/d 2 hari ke depan (`DateTime.now()` s/d `DateTime.now() + 2 days`).
   - Teks dinamis menampilkan rentang tanggal asli (misal: `24 Okt - 26 Okt 2026 • 2 Malam`).

2. **Pengecekan Ketersediaan Kamar (Availability Checking Engine)**:
   - Di `HotelCubit` / `HotelSearchPage`:
     - Kamar memiliki atribut `stock` (stok fisik unit).
     - Sistem mengecek reservasi aktif yang ada di Firestore koleksi `bookings` untuk rentang tanggal yang bertabrakan (*date overlap*):  
       `bookingCheckIn < requestedCheckOut AND bookingCheckOut > requestedCheckIn`.
     - Jika stok kamar habis pada tanggal tersebut, kartu kamar di `HotelDetailPage` akan berstatus **"Habis Terjual (Sold Out)"** dan tombol *Book Room* dinonaktifkan.
     - Jika seluruh tipe kamar di hotel tersebut habis pada tanggal yang dipilih, kartu hotel di halaman pencarian akan menampilkan badge merah: **"Kamar Penuh pada Tanggal Ini"** atau disaring secara opsional.

3. **Penerusan Tanggal (Seamless Date Propagation)**:
   - Dari `HotelSearchPage` ➔ Diteruskan ke `HotelDetailPage` via query params (`cin` & `cout`).
   - Dari `HotelDetailPage` ➔ Diteruskan ke `CheckoutPage` (`${AppRoutes.checkout}?hotelId=...&roomId=...&cin=...&cout=...`).
   - `CheckoutPage` langsung otomatis terisi dengan tanggal yang dipilih pengguna sejak awal pencarian tanpa perlu memilih ulang!

---

## 3. Rincian Perubahan File

### A. Mobile App (`stayjogja_flutter`)

1. **`lib/features/hotel/presentation/pages/hotel_search_page.dart`**:
   - Jadikan teks `'2 guests • 25-27 Oct'` tombol interaktif dengan ikon kalender.
   - Tambahkan fungsi `_pickDateRange()` menggunakan `showDateRangePicker`.
   - Update header agar menampilkan format tanggal dinamis: `${DateHelper.formatDate(_checkIn)} - ${DateHelper.formatDate(_checkOut)}`.
   - Teruskan parameter tanggal saat user menekan *"View Rooms"*:  
     `context.push('/hotel/${hotel.id}?cin=${DateHelper.formatDate(_checkIn)}&cout=${DateHelper.formatDate(_checkOut)}')`.

2. **`lib/routes/app_router.dart`**:
   - Update route `/hotel/:id`: Ambil query parameter `cin` dan `cout` dari `state.uri.queryParameters`, teruskan ke `HotelDetailPage`.
   - Update route `/checkout`: Ambil `cin` dan `cout`, teruskan ke `CheckoutPage(hotelId: ..., roomId: ..., initialCheckIn: cin, initialCheckOut: cout)`.

3. **`lib/features/hotel/presentation/pages/hotel_detail_page.dart`**:
   - Tambahkan properti `initialCheckIn` dan `initialCheckOut`.
   - Tampilkan banner tanggal menginap yang sedang dipilih di bagian atas daftar kamar.
   - Tombol *"Book Room"* meneruskan tanggal yang dipilih ke URL Checkout.
   - Cek stok kamar: jika stok <= 0 pada tanggal tersebut, tampilkan badge *"Habis Terjual"* dan nonaktifkan tombol pemesanan.

4. **`lib/features/hotel/presentation/bloc/hotel_cubit.dart`**:
   - Simpan `checkInDate` dan `checkOutDate` di `HotelLoaded` state.
   - Dukung filter ketersediaan kamar secara reaktif.

---

## 4. Rencana Pengujian
1. Buka halaman pencarian hotel, klik tombol tanggal di header ➔ pilih tanggal kustom.
2. Pastikan teks header langsung berubah sesuai tanggal yang dipilih.
3. Klik "View Rooms" pada salah satu hotel ➔ pastikan tanggal yang dipilih terbawa ke `HotelDetailPage`.
4. Klik "Book Room" ➔ pastikan tanggal di `CheckoutPage` langsung terisi persis sesuai tanggal yang dipilih, dengan total malam dan harga yang dihitung otomatis.
5. Jalankan `flutter analyze` dan push commit ke `raynor19/stayjogja_flutter`.
