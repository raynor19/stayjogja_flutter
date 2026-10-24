# Rencana Perbaikan Menyeluruh: Web Management Platform & Mobile Flutter App

Berdasarkan hasil audit komprehensif, berikut adalah rencana aksi terperinci untuk memperbaiki seluruh temuan pada kedua proyek (**Web Stayjogja** dan **Mobile stayjogja_flutter**).

---

## 📋 Bagian 1: Perbaikan Web Management Platform (`Stayjogja`)

### 1. Fix Critical Bug: Implementasi `db.addNotification()` di Database Class
- **File**: `src/config/database.js`
- **Masalah**: `src/routes/adminRoutes.js` (lines 55, 82, 109, 139, 296) memanggil `db.addNotification(...)` saat Admin menyetujui properti, menolak properti, menghapus properti, atau mencairkan dana. Namun, method ini belum ada di class `Database`, sehingga memicu crash runtime `TypeError: db.addNotification is not a function` (HTTP 500).
- **Solusi**:
  - Tambahkan method `async addNotification(notif)` pada class `Database` di `src/config/database.js`:
    ```javascript
    async addNotification(notif) {
      if (!this.notifications) this.notifications = [];
      const newNotif = {
        id: notif.id || `notif-${Date.now()}`,
        created_at: new Date().toISOString(),
        read: false,
        ...notif
      };
      this.notifications.unshift(newNotif);
      await firestore.setDocument('notifications', newNotif.id, newNotif);
      return newNotif;
    }
    ```

### 2. Lengkapi Missing CRUD Handlers di `src/routes/propertyRoutes.js`
- **File**: `src/routes/propertyRoutes.js`
- **Masalah**: Frontend (`owner.js`, `api.js`, `tera.js`) memanggil route CRUD yang saat ini belum ada di backend (hanya ada `GET /` dan `GET /:id`), menyebabkan error HTTP 404 saat edit properti, kelola kamar, dan pendaftaran hotel baru.
- **Solusi**:
  - `POST /api/properties`: Pendaftaran hotel baru oleh owner/TERA, menyusun struktur kamar (`rooms`), dan menyimpannya langsung ke Firestore `hotels`.
  - `PUT /api/properties/:id`: Edit informasi nama hotel, kawasan, alamat, fasilitas, dan bintang, lalu sync ke Firestore `hotels`.
  - `POST /api/properties/:id/request-delete`: Menandai status penghapusan properti `status_deletion: 'pending_deletion'` dan memicu `db.addNotification` ke Admin.
  - `PUT /api/properties/units/:unitId`: Update tarif, stok, dan fasilitas kamar tertentu pada properti.
  - `DELETE /api/properties/units/:unitId`: Menghapus unit kamar dari properti.

### 3. Kunci Isolasi Data Multi-Tenant (Owner Data Isolation)
- **Files**: `src/routes/propertyRoutes.js`, `src/routes/reservationRoutes.js`, `src/routes/ownerStaffRoutes.js`, `public/js/owner.js`
- **Masalah**: Query properti dan reservasi saat ini membocorkan properti/reservasi yang tidak memiliki `owner_id` ke semua akun owner.
- **Solusi**:
  - Di `src/routes/propertyRoutes.js`: Jika query `owner_id` diberikan, saring secara ketat:
    `results = results.filter(p => p.owner_id === req.query.owner_id);`.
  - Di `public/js/owner.js`: Pastikan `API.getProperties` selalu mengirimkan `{ owner_id: currentUser.id, status: 'all' }`.
  - Di `src/routes/reservationRoutes.js` (`GET /api/reservations/owner`): Ambil seluruh ID hotel milik owner yang sedang login, lalu saring reservasi yang terjadi pada hotel-hotel tersebut saja.
  - Di `src/routes/ownerStaffRoutes.js`: Saring staf resepsionis hanya yang memiliki `created_by_owner_id === ownerId`.

### 4. Pembersihan Kode Warisan Supabase
- **Files**: `public/login.html`, `public/js/login.js`, `package.json`
- **Solusi**:
  - Hapus script tag CDN Supabase di `public/login.html:336`.
  - Hapus handler Supabase OAuth lama di `public/js/login.js` yang menembak subdomain Supabase lama.
  - Hapus dependensi `"@supabase/supabase-js"` dari `package.json`.

---

## 📱 Bagian 2: Perbaikan Aplikasi Mobile (`stayjogja_flutter`)

### 1. Perbaiki Parameter Dinamis (Hilangkan Hardcoded ID)
- **`lib/features/itinerary/presentation/pages/saved_itineraries_page.dart`**:
  - Ganti navigasi hardcoded `hotelId=htl-malioboro` (line 124) dengan ID hotel / nama hotel dinamis dari objek `TripItinerary` yang tersimpan.
- **`lib/features/booking/presentation/pages/bookings_page.dart`**:
  - Ganti navigasi hardcoded `roomId=rm-tentrem-deluxe` (line 213) dengan ID kamar yang sesungguhnya dari objek `BookingEntity`.

### 2. Sinkronisasi Data Hotel Baru dari Firestore ke `HotelDetailPage`
- **File**: `lib/features/hotel/presentation/pages/hotel_detail_page.dart`
- **Masalah**: Line 70 hanya mengambil dari `MockData.hotels.firstWhere(...)`. Jika ada hotel baru yang didaftarkan oleh Owner di Web dan disimpan ke Firestore, mobile tidak dapat membukanya.
- **Solusi**:
  - Ambil hotel dari `context.read<HotelCubit>().state` (jika `HotelLoaded`), cari berdasarkan `widget.hotelId`. Jika tidak ada, baru fallback ke `MockData.hotels`.

### 3. Aktifkan Filter Bintang & Rentang Harga pada `HotelSearchPage`
- **Files**: `lib/features/hotel/presentation/bloc/hotel_cubit.dart`, `lib/features/hotel/presentation/pages/hotel_search_page.dart`
- **Masalah**: Bottom sheet filter di search page saat ini hanya mockup/UI-only. Tombol "Terapkan Filter" belum terhubung ke BLoC.
- **Solusi**:
  - Di `HotelCubit`: Tambahkan method `filterHotels({int? star, int? minPrice, int? maxPrice})`.
  - Di `hotel_search_page.dart`: Simpan pilihan bintang dan rentang harga saat user memilih chip, lalu kirim ke `HotelCubit.filterHotels(...)` saat tombol *"Terapkan Filter"* diklik.

### 4. Perbaikan Static Analyzer & Deprecation Cleanup
- **`lib/core/usecase/usecase.dart:5`**: Ganti nama type parameter `Type` menjadi `T` (menghilangkan warning `avoid_types_as_parameter_names`).
- **`lib/core/widgets/skeleton_loading.dart:3`**: Hapus import `app_theme.dart` yang tidak digunakan.
- **`lib/features/auth/presentation/pages/splash_page.dart:1`**: Hapus import `dart:ui` yang redundan.

---

## 🚀 Urutan Eksekusi Bertahap

1. **Tahap 1**: Perbaiki Web Backend (`database.js`, `adminRoutes.js`, `propertyRoutes.js`, `ownerStaffRoutes.js`, dan pembersihan Supabase).
2. **Tahap 2**: Perbaiki Web Frontend (`owner.js`, `login.html`, `login.js`).
3. **Tahap 3**: Perbaiki Mobile App Core & Navigation (`saved_itineraries_page.dart`, `bookings_page.dart`, `hotel_detail_page.dart`).
4. **Tahap 4**: Perbaiki Filter Bintang/Harga di Mobile (`hotel_cubit.dart` & `hotel_search_page.dart`).
5. **Tahap 5**: Bersihkan peringatan analyzer di Mobile (`usecase.dart`, `skeleton_loading.dart`, `splash_page.dart`).
6. **Tahap 6**: Uji validitas dengan `flutter analyze` dan tes endpoint web, lalu push commit Git ke `raynor19/Stayjogja` dan `raynor19/stayjogja_flutter`.
