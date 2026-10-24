# Rencana Implementasi: Form Pendaftaran Lengkap (Tanggal Lahir, Jenis Kelamin, No. HP, Nama Lengkap) via Email & Google

## 1. Analisis Kebutuhan
Pengguna meminta:
- Saat pendaftaran akun (baik via Email maupun via Google Sign-In atau cara lainnya), lengkapi seluruh field profil yang diperlukan untuk reservasi hotel dan verifikasi tamu:
  1. **Nama Lengkap** Sesuai Identitas
  2. **Email Aktif**
  3. **Nomor WhatsApp / Telepon** (krusial untuk pengiriman e-voucher & konfirmasi front desk)
  4. **Tanggal Lahir** (Date Picker interaktif, penting untuk ketentuan usia & perhotelan)
  5. **Jenis Kelamin** (Laki-laki / Perempuan)
  6. **Kata Sandi & Konfirmasi** (untuk pendaftaran email)
- Data ini tersimpan utuh di Cloud Firestore (`users/{userId}`) dan terbawa otomatis saat booking hotel.

---

## 2. Arsitektur Perubahan (Clean Architecture)

### A. Domain & Data Layer (`stayjogja_flutter`)

1. **`lib/features/auth/domain/entities/user.dart`**:
   - Tambahkan properti:
     - `final String? birthDate;` (e.g. "19-03-2000" atau "2000-03-19")
     - `final String? gender;` ("Laki-laki" / "Perempuan")
   - Perbarui constructor dan `props`.

2. **`lib/features/auth/domain/usecases/auth_usecases.dart`**:
   - Perbarui `RegisterParams` agar menerima `phone`, `birthDate`, dan `gender`.

3. **`lib/features/auth/data/repositories/auth_repository_impl.dart`**:
   - Update `register(...)`:
     - Simpan data lengkap ke Cloud Firestore `users/{userId}`:
       `'name'`, `'email'`, `'password'`, `'phone'`, `'birth_date'`, `'gender'`, `'role': 'user'`, `'status': 'active'`, `'created_at'`.
     - Simpan sesi lokal di `SharedPreferences` (`logged_user_birth_date`, `logged_user_gender`, `logged_user_phone`).
   - Update `login(...)`:
     - Membaca field `birth_date` dan `gender` dari dokumen Firestore `users`.
   - Update `loginWithGoogle()` / `registerWithGoogle()`:
     - Mengambil info akun Google (`GoogleSignIn`), jika pengguna baru atau field belum lengkap, simpan data profil lengkap ke Firestore.

4. **`lib/features/auth/presentation/bloc/auth_cubit.dart`**:
   - Perbarui method `register(...)` dan `loginWithGoogle(...)` agar menyertakan parameter `phone`, `birthDate`, `gender`.

---

### B. Presentation Layer (UI/UX)

1. **`lib/features/auth/presentation/pages/register_page.dart`**:
   - Perbarui UI form menjadi lengkap dan rapi:
     - **Nama Lengkap**: `TextFormField` (Kapitalisasi kata).
     - **Email**: `TextFormField` (Keyboard email).
     - **Nomor Telepon / WhatsApp**: `TextFormField` (Keyboard phone, prefix `+62`).
     - **Tanggal Lahir**: Interaktif via `showDatePicker` (dengan pembatasan usia maksimal hari ini dan batasan 100 tahun ke belakang) + ikon kalender.
     - **Jenis Kelamin**: Selector pill modern (*Laki-laki* / *Perempuan*).
     - **Password & Konfirmasi Password**: Toggle visibility icon.
     - **Tombol "Daftar Akun Sekarang"**: Validasi semua field wajib diisi sebelum submit.
     - **Tombol "Daftar dengan Google"**: Membuka pendaftaran instan Google dengan auto-fill nama dan email, lalu pengguna mengonfirmasi tanggal lahir & no telepon.

2. **`lib/features/auth/presentation/pages/login_page.dart`**:
   - Pada tombol *"Lanjutkan dengan Google"*:
     - Jika akun sudah terdaftar lengkap di Firestore, langsung masuk ke Home.
     - Jika akun Google baru pertama kali masuk, buka modal/bottom sheet ramah *"Lengkapi Profil Anda"* untuk memilih tanggal lahir dan nomor WhatsApp, lalu simpan ke Firestore.

---

## 3. Rencana Pengujian & Verifikasi
1. Jalankan `flutter analyze` untuk memastikan tidak ada kesalahan kompilasi.
2. Buka halaman Pendaftaran (`RegisterPage`):
   - Isi form lengkap (Nama, Email, No. HP, Tanggal Lahir via DatePicker, Jenis Kelamin, Password).
   - Tekan "Daftar Sekarang".
3. Periksa Cloud Firestore `users`: Pastikan dokumen user baru tersimpan dengan field `name`, `email`, `phone`, `birth_date`, dan `gender`.
4. Buka halaman Checkout Hotel: Pastikan data nama, email, dan nomor telepon terisi otomatis dari profil user yang baru didaftarkan.
5. Commit dan push perubahan ke GitHub `raynor19/stayjogja_flutter`.
