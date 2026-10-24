# Rencana Implementasi: Fitur Peta Interaktif Hotel DIY (Interactive Map Search with Markers & Cards)

## 1. Analisis Kebutuhan
- **Latar Belakang**:
  Setiap hotel di StayJogja sudah memiliki koordinat presisi (`latitude` dan `longitude`) yang tersimpan di Cloud Firestore `hotels` dan `MockData.hotels`.
- **Kebutuhan Pengguna**:
  Pengguna ingin tombol peta di halaman pencarian (`Icons.map_outlined`) membuka **Peta Interaktif Hotel Se-Yogyakarta**:
  - Peta terpusat di Kota Yogyakarta (Tugu / Malioboro: `-7.7956, 110.3695`).
  - Menampilkan **Pin/Marker Kustom** untuk setiap hotel lengkap dengan pill harga (`Rp 350k`, `Rp 1.2jt`).
  - Saat sebuah pin/marker diklik, peta otomatis *animate camera* ke koordinat tersebut dan menampilkan **Kartu Preview Hotel Melayang (*Floating Hotel Card*)** di bagian bawah layar.
  - Kartu preview menampilkan foto thumbnail, nama hotel, bintang, harga per malam, dan tombol langsung *"Lihat Kamar"* untuk memesan.
  - Terdapat tombol toggle mode: Beralih mulus antara **Tampilan Daftar (List View)** dan **Tampilan Peta (Map View)** ala Airbnb/Traveloka.

---

## 2. Pilihan Arsitektur Peta: Google Maps vs Flutter OpenStreetMap / Interactive Map

Ada 2 opsi implementasi:
1. **Google Maps SDK (`google_maps_flutter`)**:
   - Membutuhkan Google Maps Platform API Key berbayar yang harus di-whitelist untuk bundle ID iOS & SHA-1 Android di Google Cloud Console. Jika API Key belum disetel atau belum aktif penagihannya, widget GoogleMap akan memunculkan layar abu-abu kosong (*blank grey screen*).
2. **Flutter Interactive Custom Map / Flutter Map Canvas (100% Reliable & Zero Setup)**:
   - Alternatif yang sangat mulus, tanpa memerlukan registrasi kartu kredit di Google Cloud, atau kita sediakan widget `GoogleMap` resmi dengan proteksi fallback tampilan peta interaktif.
   - Menggunakan `google_maps_flutter` resmi yang dikombinasikan dengan Google API Key bawaan Firebase (`AIzaSyAlF5oLMaAzFpEajWdrFbESbIOL30YNANc` yang sudah ada di `GoogleService-Info.plist` dan `google-services.json`).

---

## 3. Rincian Perubahan & File yang Dibuat

### A. Konfigurasi Native Google Maps API Key
1. **Android (`android/app/src/main/AndroidManifest.xml`)**:
   - Tambahkan meta-data API Key Google Maps di dalam `<application>`:
     ```xml
     <meta-data
         android:name="com.google.android.geo.API_KEY"
         android:value="AIzaSyAlF5oLMaAzFpEajWdrFbESbIOL30YNANc" />
     ```
2. **iOS (`ios/Runner/AppDelegate.swift`)**:
   - Daftarkan `GMSServices.provideAPIKey("AIzaSyAlF5oLMaAzFpEajWdrFbESbIOL30YNANc")` di `didFinishLaunchingWithOptions`.

### B. Halaman / Modal Peta Baru: `HotelMapSearchPage` (`lib/features/hotel/presentation/pages/hotel_map_search_page.dart`)
1. **Peta Interaktif Berbasis Koordinat Real**:
   - Titik awal kamera: `-7.7956, 110.3695` (Pusat Yogyakarta) dengan zoom `13.0`.
   - Mengambil seluruh daftar hotel aktif dari `HotelCubit`.
   - Menghasilkan kumpulan `Marker`:
     - Posisi `LatLng(hotel.latitude, hotel.longitude)`.
     - `infoWindow` menampilkan nama hotel dan harga.
     - `onTap` mengaktifkan state `_selectedHotel = hotel` dan menggerakkan kamera ke lokasi hotel tersebut.
2. **Floating Hotel Card di Bagian Bawah**:
   - Ketika pin hotel disentuh (atau di-scroll horizontal), kartu hotel muncul melayang di atas peta.
   - Menampilkan: Foto, rating bintang, jarak dari Tugu/Malioboro, harga per malam.
   - Tombol *"Lihat Kamar"*: langsung mengarahkan ke `HotelDetailPage` membawa parameter tanggal yang sedang aktif (`cin` dan `cout`).
3. **Pencarian Cepat di Atas Peta**:
   - Search pill di bagian atas peta untuk memfilter hotel berdasarkan kawasan (Malioboro, Prawirotaman, Sleman, dll) secara instan.
4. **Tombol Toggle List View**:
   - Tombol bulat melayang di pojok kanan bawah: *"Tutup Peta / Tampilkan Daftar"*.

### C. Pembaruan Navigasi di `hotel_search_page.dart`
- Ubah tombol `Icons.map_outlined` (yang sebelumnya SnackBar):
  - Saat diklik, langsung membuka `HotelMapSearchPage` (atau toggle map view) secara halus dengan transisi animasi.

---

## 4. Rencana Pengujian & Validasi
1. Cek analisis kode dengan `flutter analyze` untuk memastikan tidak ada kesalahan kompilasi.
2. Buka halaman pencarian hotel di aplikasi:
   - Ketuk ikon peta di pojok kanan atas ➔ pastikan peta interaktif terbuka.
   - Ketuk salah satu pin/marker hotel di peta ➔ pastikan kartu preview hotel muncul melayang di bawah dengan data harga dan bintang yang benar.
   - Ketuk *"Lihat Kamar"* pada kartu preview ➔ pastikan halaman detail hotel terbuka dengan lancar.
3. Commit dan push perubahan ke GitHub `raynor19/stayjogja_flutter`.
