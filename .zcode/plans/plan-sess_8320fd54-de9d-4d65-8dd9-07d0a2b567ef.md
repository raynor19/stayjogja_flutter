# Rencana Implementasi: Pagination (Infinite Scroll & Chunk Loading) di Halaman Pencarian Hotel

## 1. Analisis Masalah & Kebutuhan
- **Masalah Saat Ini**:
  Saat ini, daftar hotel (50–70+ hotel di Firestore dengan gambar resolusi tinggi) di-render sekaligus ke dalam `ListView.separated`. Ketika pengguna mengetik di search bar atau menggulir layar (*scrolling*), render puluhan gambar kartu hotel sekaligus dapat menyebabkan *jank* (penurunan frame rate / lag pada ponsel dengan spesifikasi menengah/rendah).
- **Kebutuhan Pengguna**:
  Pengguna menginginkan sistem **Pagination / Infinite Scroll (Lazy Loading)**:
  - Memuat data per halaman (misal: **10 hotel pertama**).
  - Saat pengguna menggulir mendekati dasar layar (*scroll reaches bottom*), sistem memuat 10 hotel berikutnya secara mulus (*smooth infinite scroll*) disertai indikator loading kecil di bagian bawah.
  - Saat pencarian kata kunci atau filter bintang diubah, pagination di-reset kembali ke halaman 1 secara instan tanpa lag.

---

## 2. Arsitektur Solusi Teknis

### A. Komponen Pagination di `_HotelSearchPageState` (`hotel_search_page.dart`):
1. **ScrollController Listener**:
   - Menambahkan `final ScrollController _scrollCtrl = ScrollController();`.
   - Menambahkan listener `_scrollCtrl.addListener(_onScroll)`:
     ```dart
     void _onScroll() {
       if (_scrollCtrl.position.pixels >= _scrollCtrl.position.maxScrollExtent - 200) {
         _loadMoreHotels();
       }
     }
     ```
2. **State Pagination**:
   - `int _displayedCount = 10;` (ukuran halaman / page size = 10 hotel).
   - `bool _isLoadingMore = false;`.
3. **Logika Load More**:
   - Membatasi item yang ditampilkan:  
     `final visibleHotels = hotels.take(_displayedCount).toList();`
   - Saat trigger `_loadMoreHotels()`:
     Jika `_displayedCount < hotels.length`:
     - Tampilkan spinner kecil di footer ListView.
     - Tambahkan `_displayedCount += 10;` dengan `setState()`.
4. **Reset Saat Search / Filter**:
   - Saat `_onSearchChanged()`, `_clearSearch()`, atau `filterHotels()` dipanggil, otomatis reset `_displayedCount = 10;`.
   - Mengembalikan posisi scroll ke paling atas (`_scrollCtrl.jumpTo(0)`).

---

## 3. Rincian Perubahan File

### `lib/features/hotel/presentation/pages/hotel_search_page.dart`:
- Tambahkan `ScrollController _scrollCtrl`.
- Tambahkan state `_displayedCount = 10` dan `_pageSize = 10`.
- Update `itemCount`: `visibleHotels.length + (hasMore ? 1 : 0)`.
- Jika `index == visibleHotels.length`: Render widget `_buildLoadingIndicator()` (Shimmer/Spinner elegan khas StayJogja).
- Bersihkan controller pada `dispose()`.

---

## 4. Rencana Pengujian & Validasi
1. Jalankan `flutter analyze` untuk memastikan tidak ada kesalahan kompilasi.
2. Buka halaman pencarian hotel di aplikasi:
   - Pastikan awal pembukaan hanya me-render 10 hotel pertama (sangat ringan dan cepat, 0 lag).
   - Scroll ke bawah sampai hotel ke-10 ➔ pastikan hotel ke-11 s/d 20 otomatis termuat secara mulus (*infinite loading*).
   - Ketikkan pencarian (misal: *"tentrem"* atau *"malioboro"*) ➔ pastikan list langsung reset ke hasil pencarian awal tanpa lag.
3. Commit dan push ke Git `raynor19/stayjogja_flutter`.
