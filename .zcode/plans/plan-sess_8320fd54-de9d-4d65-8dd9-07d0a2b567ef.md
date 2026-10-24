# Rencana Implementasi: Relasi Constraint Hotel-Owner & Hotel-Resepsionis

## 1. Analisis Kebutuhan & Proses Bisnis (Probis)
- **Owner ➔ Hotel (1-to-Many)**: Seorang Owner dapat memiliki banyak hotel. Tiap hotel di Firestore WAJIB memiliki `owner_id`. Dashboard Owner hanya menampilkan hotel-hotel miliknya.
- **Resepsionis ➔ Hotel (Many-to-1 / Terikat 1 Hotel)**: Seorang Resepsionis hanya bertugas di 1 hotel tertentu (`assigned_hotel_id`).
- **Owner Mengelola Staf**: Owner mendaftarkan langsung akun resepsionis dari Dashboard Owner (Nama, Email, Password, dan pilih salah satu hotel milik Owner).
- **Portal Resepsionis Terkunci**: Saat resepsionis login, sistem langsung mengunci portal pada hotel tugasnya. Dropdown "Semua Hotel" dihapus, dan hanya menampilkan data reservasi & kamar hotel penugasannya.
- **Register Web**: Registrasi mandiri di web dikhususkan untuk **Pemilik Akomodasi (Owner)**.

---

## 2. Rincian Perubahan Kode & File

### A. Backend (`src/routes/` & `src/config/`)
1. **`src/routes/ownerRoutes.js` (atau route baru `/api/owner`)**:
   - `GET /api/owner/staff`: Ambil daftar resepsionis yang terdaftar di bawah `created_by_owner_id`.
   - `POST /api/owner/staff`: Tambah akun resepsionis baru ke Firestore `users`, dengan constraint:
     - `role: 'resepsionis'`
     - `assigned_hotel_id`: ID hotel yang dipilih owner (diverifikasi bahwa hotel tersebut memang milik owner ini).
     - `assigned_hotel_name`: Nama hotel tugas.
     - `created_by_owner_id`: ID owner.
   - `DELETE /api/owner/staff/:id`: Hapus/nonaktifkan akun resepsionis.
2. **`src/routes/propertyRoutes.js`**:
   - Update `GET /api/properties`: Dukung filter `owner_id` agar dashboard owner hanya menampilkan properti miliknya.
3. **`src/routes/authRoutes.js`**:
   - Update respons login untuk resepsionis agar menyertakan `assigned_hotel_id` dan `assigned_hotel_name`.
   - Form register publik mengunci role ke `'owner'`.
4. **`src/routes/reservationRoutes.js`**:
   - Resepsionis hanya bisa melihat dan memvalidasi check-in reservasi untuk hotel tugasnya.

### B. Frontend Dashboard Owner (`public/owner.html` & `public/js/owner.js`)
1. **Tab Baru "Staf Resepsionis"**:
   - Ditambahkan tab di navigasi owner: `Staf Resepsionis`.
   - Menampilkan tabel/kartu: Nama Staf, Email, Hotel Penugasan, Status, dan Tombol Hapus.
2. **Modal Form "Tambah Resepsionis Baru"**:
   - Dropdown memilih hotel (hanya hotel-hotel yang dimiliki oleh owner yang sedang login).
   - Input: Nama Lengkap Resepsionis, Email Login, Password Awal, No. WhatsApp.
   - Tombol Simpan ➔ Mengirim ke `POST /api/owner/staff` ➔ tersimpan ke Firestore `users`.

### C. Frontend Portal Resepsionis (`public/resepsionis.html` & `public/js/resepsionis.js`)
1. **Kunci Penugasan Hotel**:
   - Tampilkan banner nama hotel tugas di header: e.g. `Portal Resepsionis • Hotel Tentrem Yogyakarta`.
   - Hapus dropdown pilihan "Semua Hotel".
   - Otomatis filter reservasi & check-in hanya untuk `assigned_hotel_id`.

---

## 3. Verifikasi & Pengujian
1. Login sebagai Owner (`owner@stayjogja.id`) ➔ Buka Tab Staf Resepsionis ➔ Tambah akun resepsionis baru untuk salah satu hotel.
2. Logout ➔ Login dengan akun resepsionis yang baru dibuat ➔ Pastikan otomatis masuk ke portal hotel tersebut saja dan tidak bisa melihat hotel lain.
3. Cek Firestore collection `users` untuk memastikan relasi `assigned_hotel_id` dan `created_by_owner_id` tersimpan rapi.
4. Push commit ke GitHub `raynor19/Stayjogja`.
