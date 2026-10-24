# Rencana Implementasi: Local Scheduled Notification Pengingat Check-Out 1 Jam Sebelumnya

## 1. Analisis Kebutuhan & Probis
- **Tujuan**: Mengingatkan tamu tepat **1 jam sebelum waktu batas check-out hotel** agar tamu dapat mempersiapkan barang bawaan tanpa terburu-buru dan terhindar dari denda *late check-out*.
- **Waktu Standar**:
  - Jam batas check-out umum hotel di Yogyakarta: **12:00 WIB**.
  - Waktu notifikasi berdering: **Pukul 11:00 WIB** pada tanggal check-out yang tertera pada reservasi.
- **Mekanisme**:
  - Menggunakan `flutter_local_notifications` (yang sudah terdaftar di `pubspec.yaml`).
  - Berjalan 100% lokal di smartphone (iOS Notification Center / Android AlarmManager) tanpa bergantung pada server, hemat baterai, dan tetap berbunyi meskipun offline atau aplikasi tertutup.
  - Ditambahkan method simulasi instan: *"Tes Notifikasi Sekarang (5 Detik)"* agar saat review / presentasi pengujian, notifikasi langsung muncul di banner HP tanpa harus menunggu tanggal check-out tiba.

---

## 2. Rincian Perubahan File

### A. Core Service (`lib/core/services/notification_service.dart`)
1. **`NotificationService` Class**:
   - Inisialisasi plugin `FlutterLocalNotificationsPlugin`:
     - Android: setting icon `@mipmap/ic_launcher` & notification channel `stayjogja_checkout_channel` (Importance high, Priority high, sound enabled).
     - iOS: DarwinInitializationSettings (request alert, badge, sound).
   - **Method `scheduleCheckoutReminder(...)`**:
     - Menerima `checkOutDate` (DateTime atau String `dd MMM yyyy`), nama tamu, nama hotel, dan tipe kamar.
     - Menghitung waktu target: Jam 11:00 WIB pada hari `checkOutDate`.
     - Jika waktu target masih di masa depan, jadwalkan notifikasi menggunakan timezone lokal perangkat.
   - **Method `showInstantReminderNotification(...)`**:
     - Menampilkan notifikasi pengingat seketika (untuk konfirmasi atau simulasi demo 5 detik).
   - **Method `cancelReminder(int id)`**:
     - Membatalkan notifikasi jika reservasi dibatalkan.

### B. Inisialisasi di `main.dart`
2. **`lib/main.dart`**:
   - Panggil `await NotificationService.init()` pada `main()` setelah `WidgetsFlutterBinding.ensureInitialized()`.

### C. Trigger Otomatis di Alur Pemesanan
3. **`lib/features/booking/presentation/pages/checkout_page.dart`**:
   - Saat pembayaran berhasil diproses (`_processPayment`), sistem otomatis menjadwalkan notifikasi:
     ```dart
     await NotificationService.scheduleCheckoutReminder(
       bookingCode: bookingCode,
       hotelName: hotel.name,
       roomName: room.name,
       guestName: newBooking.guestName,
       checkOut: _checkOut,
     );
     ```
4. **`lib/features/booking/presentation/pages/payment_success_page.dart`**:
   - Tambahkan chip informasi jadwal pengingat di bawah tiket:
     > 🛎️ *"Pengingat Check-Out Aktif: Anda akan menerima notifikasi otomatis pada [Tanggal] pukul 11:00 WIB (1 jam sebelum batas check-out)."*
   - Tambahkan tombol kecil: *"Uji Suara Notifikasi Sekarang"* untuk demo langsung.

---

## 3. Rencana Pengujian
1. Jalankan `flutter analyze` untuk memastikan tidak ada kesalahan kompilasi atau missing types.
2. Uji checkout kamar hotel di aplikasi:
   - Pastikan booking berhasil dibuat.
   - Periksa log terminal: `[NotificationService] ✅ Pengingat check-out berhasil dijadwalkan...`.
   - Coba tombol *"Uji Suara Notifikasi Sekarang"* di `PaymentSuccessPage` dan pastikan banner notifikasi muncul di bagian atas layar HP.
3. Commit dan push perubahan ke GitHub `raynor19/stayjogja_flutter`.
