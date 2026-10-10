# Stay Jogja — Mobile Design & Taste Guide

Dokumen ini menjadi acuan estetika, craft, dan standar kualitas (*Taste*) untuk pengembangan aplikasi mobile **Stay Jogja** Flutter.

---

## 🎨 1. Core Visual Taste & Palette

### Background & Surface
- **Canvas / Background**: Mint Pastel Lembut (`#EBF4EE`) — memberikan nuansa segar, tenang, dan mewah dibandingkan background putih polos.
- **Card Surface**: Putih Bersih (`#FFFFFF`) dengan sudut membulat organik (`BorderRadius.circular(20)` s/d `24`).
- **Shadow**: Ultra-halus dan berlapis (`Color(0x0C000000)` blur `12px` - `24px`), tanpa drop shadow hitam kaku.

### Accent & Jewel Tones
- **Primary CTA**: Black Obsidian Pill (`#16181B`) dengan teks putih bersih (`BorderRadius.circular(30)`).
- **Price Badge**: Emerald Mint Green (`#00B67A`) dengan teks putih bold di pojok kanan atas foto.
- **Offer Badges**:
  - `Member Exclusive`: Pill biru muda (`#DDF0FD`) + teks biru navy (`#1E78C2`).
  - `Best Value`: Pill lavender pastel (`#EFE5FC`) + teks ungu deep (`#7A45C4`).

---

## 🧊 2. Floating Liquid Glass Navigation Bar

Sesuai standar **HIG Apple** & **Glassmorphism**:
- **Bentuk**: Floating pill dengan margin samping `20px` dan padding bottom aman (`SafeArea`).
- **Material Kaca**:
  - `BackdropFilter(sigmaX: 24, sigmaY: 24)` untuk blur konten di belakangnya.
  - Gradasi kaca basah (liquid gradient) dengan specular highlight putih pada tepi (`Border.all(color: Colors.white.withValues(alpha: 0.9), width: 1.5)`).
  - Ambient drop shadow melayang memberi kesan depth 3D.
  - Active indicator berupa pill transparan emerald halus yang membesar dinamis.

---

## 📱 3. Human Interface Guidelines (HIG Apple)

1. **Touch Targets**: Minimal **44 x 44 pt** untuk semua area tombol, chip, dan ikon interaktif.
2. **Thumb Zone**: CTA penting (`View Rooms`, `Book Room`, `Generate AI Itinerary`) diletakkan di area yang mudah dijangkau satu tangan.
3. **Safe Area & Extend Body**: Konten meluncur di bawah translucent bars secara alami.
4. **Tipografi Hirarki**:
   - Title: Poppins Bold 20–24pt
   - Headline / Subtitle: Poppins SemiBold 15–17pt
   - Body & Keterangan: Poppins Regular 12–14pt
   - Badge / Micro-copy: Poppins Medium/SemiBold 10–11pt

---

## 📳 4. Micro-Interactions & Haptics (Ponytail Standard)

- **Tab Switch**: `HapticFeedback.selectionClick()`
- **Button Press**: `HapticFeedback.lightImpact()`
- **Success (Booking / AI Itinerary Created)**: `HapticFeedback.mediumImpact()`
- **Spring Animations**: Transisi skala halus saat tombol ditekan (`0.96` scale on press).

---

## 🛡️ 5. Anti-Slop Policy (Zero AI-Fluff)

1. **Konten Otentik**: Selalu gunakan data nyata khas Yogyakarta (Malioboro, Prawirotaman, Kaliurang, Keraton, Gudeg Yu Djum, Kopi Klotok). Dilarang keras memakai "Lorem Ipsum" atau "Test Hotel 1".
2. **Mata Uang**: Selalu dalam format Rupiah (`Rp 520.000` atau `Rp 520k/night`).
3. **Komponen Modular**: Hindari class monolitik; pecah menjadi micro-widgets (`_OfferCard`, `_FeatureRow`, `_LiquidGlassNavBar`).
4. **Error & Skeleton**: Semua network image dan async action wajib memiliki placeholder shimmer dan graceful error fallback.
