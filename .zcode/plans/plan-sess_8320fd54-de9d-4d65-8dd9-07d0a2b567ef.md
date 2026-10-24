# Rencana Implementasi: Peta Interaktif Nyata DIY Yogyakarta Menggunakan Leaflet (`flutter_map` & OpenStreetMap)

## 1. Analisis Kebutuhan & Keunggulan Leaflet
- **Kondisi Sebelumnya**:
  Menggunakan SDK Google Maps native iOS (`google_maps_flutter`) memicu crash fatal (`GMSServices checkServicePreconditions`) karena memerlukan inisialisasi API key native berbayar di `AppDelegate.swift` yang sering bermasalah di iOS Simulator.
- **Solusi Leaflet (`flutter_map` + `latlong2`)**:
  - **100% Pure Dart**: Berjalan langsung di atas Flutter Canvas tanpa native Objective-C/Swift bridge, **dijamin 100% bebas crash (*zero crash* / zero lost connection) di iOS Simulator maupun Android**.
  - **Peta Nyata Asli (*Real Map*)**: Menggunakan tile server OpenStreetMap resmi dengan peta nyata Yogyakarta lengkap (Jalan Malioboro, Tugu, Keraton, Stasiun, Kaliurang, sungai, dll).
  - **Bebas Biaya & Tanpa API Key**: Tidak membutuhkan Google Cloud Console, kartu kredit, atau API key.
  - **Pin Hotel Interaktif**: Menampilkan seluruh hotel dari Firestore dengan pin pill harga (`Rp 350k`, `Rp 1.2jt`), interaksi sentuh, dan sinkronisasi kartu preview melayang di bawah layar.

---

## 2. Rincian Perubahan File

### A. Dependensi Proyek (`pubspec.yaml`)
- Tambahkan library resmi Flutter Leaflet di `dependencies`:
  ```yaml
  flutter_map: ^7.0.2
  latlong2: ^0.9.1
  ```

### B. Halaman Peta Leaflet: `HotelMapSearchPage` (`lib/features/hotel/presentation/pages/hotel_map_search_page.dart`)
1. **Komponen `FlutterMap`**:
   - `MapController`: Mengontrol kamera peta (geser dan zoom halus saat pin hotel diklik).
   - `MapOptions`:
     - `initialCenter: LatLng(-7.7956, 110.3695)` (Pusat Yogyakarta / Tugu Jogja).
     - `initialZoom: 13.0` (optimal menampilkan kawasan Malioboro hingga Ringroad).
     - `minZoom: 9.0`, `maxZoom: 18.0`.
   - `TileLayer`:
     - `urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'`
     - `userAgentPackageName: 'com.stayjogja.stayjogjaFlutter'`
   - `MarkerLayer`:
     - Men-generate kumpulan `Marker` dari daftar hotel aktif Firestore:
       - Posisi `LatLng(hotel.latitude, hotel.longitude)`.
       - Tampilan pin: Pill badge harga emerald elegan (`Rp 350k`).
       - Event tap: Memilih hotel aktif, memicu animasi fokus `_mapController.move(point, 15.0)`, dan menampilkan kartu preview hotel melayang di bawah layar.
2. **Floating Hotel Card & Filter Kawasan**:
   - Tetap mempertahankan baris filter kawasan (*Malioboro, Kraton, Prawirotaman, dll*).
   - Kartu preview hotel di bawah layar lengkap dengan foto, bintang, harga per malam, tombol *"Arah Peta"*, dan tombol *"Lihat Kamar & Pesan"*.
   - Tombol *"Pusatkan ke Malioboro"* memanggil `_mapController.move(const LatLng(-7.7956, 110.3695), 13.0)`.

---

## 3. Rencana Pengujian & Validasi
1. Jalankan `flutter pub get` untuk mengunduh package `flutter_map` dan `latlong2`.
2. Jalankan `flutter analyze` untuk memastikan tidak ada konflik tipe atau kompilasi.
3. Buka halaman pencarian hotel di aplikasi ➔ tekan ikon peta di pojok kanan atas:
   - Pastikan peta OpenStreetMap kota Yogyakarta termuat dengan jelas dan jernih.
   - Pastikan tidak ada force close atau lost connection sama sekali.
   - Ketuk pin hotel mana saja ➔ pastikan peta bergerak mulus dan kartu preview hotel muncul di bawah layar.
   - Coba tombol *"Pusatkan ke Malioboro"*, filter kawasan, dan tombol *"Lihat Kamar & Pesan"*.
4. Commit dan push perubahan ke GitHub `raynor19/stayjogja_flutter`.
