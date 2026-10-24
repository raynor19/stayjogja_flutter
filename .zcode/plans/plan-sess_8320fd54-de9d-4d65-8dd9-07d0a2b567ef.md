# Rencana Implementasi: Pengiriman Notifikasi & E-Voucher ke WhatsApp Tamu

## 1. Analisis Kebutuhan & "Possible Ga?"
**Jawaban: SANGAT POSSIBLE dan ini adalah standar perhotelan modern di Indonesia (seperti Traveloka, Tiket.com, dan Bobobox)!**

Hampir semua wisatawan di Indonesia lebih cepat membaca pesan WhatsApp daripada membuka email. WhatsApp notifikasi akan mengirimkan:
1. Ucapan konfirmasi pemesanan resmi dari StayJogja.
2. Kode Booking unik (`SJ-XXXXXX`).
3. Rincian Hotel, Tipe Kamar, dan Tanggal Menginap.
4. Tautan langsung (*Direct Link*) untuk membuka E-Voucher Digital & QR Code.
5. Nomor kamar & instruksi check-in instan di meja resepsionis.

---

## 2. Arsitektur Solusi (Dual WhatsApp System)

Agar fitur ini dapat berfungsi **secara nyata sekarang juga tanpa ketergantungan biaya API berbayar**, kita akan menerapkan **arsitektur hibrida**:

### A. Client-Side Instant WhatsApp Messenger (Mobile App `stayjogja_flutter`)
- **Mekanisme**:
  - Menggunakan integrasi WhatsApp deep-link (`https://wa.me/` dan `whatsapp://send`) via `url_launcher`.
  - Pada halaman `PaymentSuccessPage`:
    - Menyediakan tombol **"Kirim E-Voucher ke WhatsApp Tamu"** (atau simpan ke nomor sendiri).
    - Begitu ditekan, aplikasi langsung memformat teks resmi reservasi StayJogja yang sangat rapi dan membuka WhatsApp dengan pesan yang sudah terisi otomatis (tinggal kirim).
  - Pada halaman `HotelDetailPage`:
    - Menambahkan tombol **"Chat Resepsionis via WhatsApp"** dengan nomor resmi hotel tugas.

### B. Server-Side Automated WhatsApp Gateway (`Stayjogja` Web Backend)
- **Mekanisme**:
  - Di web backend, dibuat modul `src/utils/whatsappService.js`.
  - Mendukung penyedia WhatsApp API populer Indonesia (**Fonnte** / **Wablas** / **Twilio**):
    - Format nomor otomatis diubah ke standar internasional (misal: `081234567890` ➔ `6281234567890`).
    - Jika API token (`WHATSAPP_API_TOKEN` / `FONNTE_TOKEN`) diisi di `.env`, server langsung mengirim pesan otomatis ke nomor HP tamu di background.
    - Jika belum diisi, sistem mengeksekusi *graceful simulation log* di konsol server tanpa menimbulkan crash.
  - Dipanggil bersamaan dengan pengiriman email pada endpoint `POST /api/reservations/notify-booking`.

---

## 3. Rincian Perubahan File

### A. Mobile App (`stayjogja_flutter`)

1. **`lib/core/services/whatsapp_helper.dart` (Baru)**:
   - Helper untuk normalisasi nomor telepon Indonesia (mengubah `08...` menjadi `628...`).
   - Format pesan WhatsApp resmi StayJogja:
     ```text
     *RESERVASI STAYJOGJA BERHASIL* ✨
     Halo [Nama Tamu], terima kasih telah memesan akomodasi melalui StayJogja!

     🏨 *Hotel*: [Nama Hotel]
     🛏️ *Kamar*: [Tipe Kamar]
     📅 *Jadwal*: [Check-in] s/d [Check-out] ([Nights] Malam)
     🏷️ *Kode Booking*: [SJ-XXXXXX]
     💰 *Total Tagihan*: Rp [Total] (LUNAS)

     📱 *E-Voucher & QR Check-In*: [Link E-Voucher]
     Tunjukkan QR Code ini ke resepsionis untuk Fast Check-In tanpa antre fotokopi KTP fisik.
     ```
   - Fungsi `sendBookingVoucherViaWhatsApp(...)`: membuka WhatsApp dengan pesan terformat.
   - Fungsi `chatHotelConcierge(...)`: membuka obrolan langsung ke front desk hotel.

2. **`lib/features/booking/presentation/pages/payment_success_page.dart`**:
   - Menambahkan tombol aksi WhatsApp berwarna hijau di bawah E-Voucher:  
     **"Kirim Ringkasan ke WhatsApp"** (`Icons.chat_rounded` / logo WA).

3. **`lib/features/hotel/presentation/pages/hotel_detail_page.dart`**:
   - Menambahkan tombol *"Tanya Resepsionis via WhatsApp"* di bagian bawah informasi hotel.

4. **Konfigurasi Android & iOS Intent**:
   - `android/app/src/main/AndroidManifest.xml`: Pastikan `<queries>` mendukung scheme `whatsapp` dan package `com.whatsapp`.
   - `ios/Runner/Info.plist`: Tambahkan `LSApplicationQueriesSchemes` dengan entri `whatsapp`.

### B. Web Backend (`Stayjogja`)

1. **`src/utils/whatsappService.js` (Baru)**:
   - Fungsi `sendWhatsAppNotification(reservation)`:
     - Mengubah nomor telepon `reservation.guest_phone` menjadi format internasional `62...`.
     - Mengirim pesan teks via HTTP POST ke Fonnte/Wablas gateway jika token tersedia.
     - Melakukan logging simulasi jika token belum aktif.
2. **`src/routes/reservationRoutes.js`**:
   - Panggil `whatsappService.sendWhatsAppNotification(bookingData)` di dalam route `POST /api/reservations/notify-booking`.

---

## 4. Rencana Pengujian
1. Jalankan `node -c` pada file baru di web backend untuk memastikan tidak ada error syntax.
2. Jalankan `flutter analyze` untuk memastikan kode Flutter bersih (0 error).
3. Uji coba pembuatan pesanan baru di aplikasi mobile:
   - Pastikan nomor WhatsApp tamu (`guest_phone`) tersimpan di dokumen Firestore `bookings`.
   - Di halaman `PaymentSuccessPage`, tekan tombol *"Kirim Ringkasan ke WhatsApp"*: pastikan WhatsApp terbuka dengan template pesan reservasi rapi.
   - Periksa console server backend untuk memastikan pemicu pengiriman WhatsApp terpanggil.
4. Commit dan push ke Git `raynor19/stayjogja_flutter` dan `raynor19/Stayjogja`.
