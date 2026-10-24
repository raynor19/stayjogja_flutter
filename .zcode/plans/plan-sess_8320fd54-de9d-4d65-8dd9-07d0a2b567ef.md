# Rencana Implementasi: Pengiriman Otomatis E-Voucher & Invoice ke Email Tamu Setelah Pembayaran

## 1. Analisis Kebutuhan & "Possible Ga?"
**Jawaban: SANGAT POSSIBLE, dan fondasi backend-nya (`nodemailer` & template HTML invoice mewah ber-QR code) sudah ada di web backend (`src/utils/mailer.js`)!**

- **Alur Bisnis yang Diinginkan**:
  1. Tamu menyelesaikan checkout dan bayar (bypass) di aplikasi mobile (`stayjogja_flutter`).
  2. Saat booking disimpan ke Firestore `bookings`, sistem backend secara otomatis memicu pengiriman email resmi StayJogja (`sendInvoiceEmail`).
  3. Tamu menerima email resmi di inbox Gmail/email mereka berisi:
     - Header invoice resmi StayJogja.
     - Kode Booking (`SJ-XXXXXX`).
     - Rincian hotel, kamar, tanggal menginap, dan total harga lunas.
     - **QR Code Fast Pass Check-In** yang tersemat rapi di dalam email.
     - Tautan petunjuk arah Google Maps ke hotel.
  4. Di aplikasi mobile, begitu pembayaran sukses, muncul notifikasi:  
     *"E-Voucher dan instruksi check-in telah dikirimkan ke email Anda (email@user.com)"*.

---

## 2. Arsitektur Solusi (Dual-Trigger Resilience)

Agar pengiriman email berhasil baik saat backend web berjalan lokal maupun saat aplikasi mobile berkomunikasi langsung:
1. **Trigger via Backend Endpoint (`POST /api/reservations/notify-booking`)**:
   - Di web backend `Stayjogja`, buat endpoint ringan `POST /api/reservations/notify-booking`:
     Menerima payload reservasi yang baru dibuat oleh mobile app ➔ memanggil `sendInvoiceEmail(reservation)`.
2. **Koneksi dari Mobile App (`booking_remote_datasource.dart`)**:
   - Setelah `createBooking` berhasil menyimpan dokumen ke Cloud Firestore `bookings`, aplikasi mobile secara asinkron (*fire-and-forget* tanpa menghambat navigasi user) memanggil endpoint notifikasi email ke backend StayJogja (`/api/reservations/notify-booking`).
3. **Konfigurasi SMTP & Simulated Fallback**:
   - Jika kredensial SMTP (`SMTP_USER` dan `SMTP_PASS`) diisi di `.env`, email fisik terkirim langsung ke inbox Gmail tamu.
   - Jika environment belum memiliki password aplikasi Gmail, `mailer.js` tetap menjalankan *graceful simulation log* di terminal server sehingga sistem tidak pernah melempar error / freeze.
4. **Indikator Sukses di UI Mobile (`payment_success_page.dart`)**:
   - Tambahkan banner konfirmasi hijau di bawah ucapan selamat:  
     *`"E-Voucher resmi telah dikirim ke [email_tamu]. Silakan cek kotak masuk atau folder spam Anda."`*

---

## 3. Rincian Perubahan File

### A. Web Backend (`Stayjogja`)
1. **`src/routes/reservationRoutes.js`**:
   - Tambahkan route `POST /api/reservations/notify-booking`:
     ```javascript
     router.post('/notify-booking', async (req, res) => {
       try {
         const bookingData = req.body;
         const mailResult = await mailer.sendInvoiceEmail(bookingData);
         res.json({ success: true, message: 'Email invoice diproses', result: mailResult });
       } catch (err) {
         res.status(500).json({ success: false, message: err.message });
       }
     });
     ```

### B. Mobile App (`stayjogja_flutter`)
2. **`lib/features/booking/data/datasources/booking_remote_datasource.dart`**:
   - Di method `createBooking`:
     - Setelah sukses `setDoc` di Firestore, kirim HTTP POST ke backend `/api/reservations/notify-booking` menggunakan `Dio` (mencoba host `http://localhost:3000`, `http://10.0.2.2:3000`, atau `http://127.0.0.1:3000`).
3. **`lib/features/booking/presentation/pages/payment_success_page.dart`**:
   - Tambahkan info box email:
     *"E-Voucher & QR Code telah dikirim ke $guestEmail"*.

---

## 4. Rencana Pengujian
1. Jalankan `node -c` pada file route web untuk memastikan syntax valid.
2. Jalankan `flutter analyze` pada mobile app untuk memastikan 0 error.
3. Uji simulasi checkout di mobile app:
   - Pastikan reservasi tersimpan di Firestore.
   - Periksa terminal server web untuk memastikan log pengiriman email (`[Mailer] Mengirim invoice ke...`).
   - Periksa tampilan konfirmasi email di `PaymentSuccessPage`.
4. Commit dan push ke Git `raynor19/Stayjogja` dan `raynor19/stayjogja_flutter`.
