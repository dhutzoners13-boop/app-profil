# Portal Layanan Publik - Flutter Frontend

Aplikasi Flutter portal halaman depan (frontend) resmi untuk instansi/layanan publik yang terhubung langsung dengan backend **Laravel REST API v1** (`routes/api.php`), menggunakan **[`go_router`](https://pub.dev/packages/go_router)** dan dukungan **Multibahasa (Bahasa Indonesia & English)** secara dinamis.

---

## 🚀 Fitur Utama

1. **Routing Modern dengan `go_router`**:
   - `StatefulShellRoute.indexedStack` untuk bottom navigation bar yang mempertahankan state antar tab:
     - `/` - **Beranda (Home)**: Banner hero slider, menu layanan cepat, kategori berita, berita utama pilihan, sorotan FAQ, & kartu kontak instansi.
     - `/posts` - **Berita & Informasi**: Pencarian judul/isi, filter kategori, dan kartu artikel.
     - `/posts/:slug` - **Detail Berita**: Gambar utama, kategori, tanggal publikasi, jumlah dilihat, kutipan summary, dan konten lengkap.
     - `/questions` - **Aspirasi & Pertanyaan Masyarakat**: Daftar pertanyaan yang sudah dijawab/ditinjau, filter topik layanan, dan status verifikasi.
     - `/questions/create` - **Formulir Pengajuan Pertanyaan**: Terhubung langsung ke API `POST /api/v1/questions` dengan validasi lengkap.
     - `/questions/:id` - **Detail Pertanyaan & Tanggapan Resmi**: Menampilkan pertanyaan dan jawaban resmi dari humas/petugas teknis instansi.
     - `/faqs` - **Tanya Jawab (FAQ)**: Accordion list tanya jawab populer dengan filter topik.
     - `/pages/:slug` - **Profil Instansi**: Halaman statis (contoh: `/pages/tentang-kami`, visi misi, dsb).
     - `/settings` - **Pengaturan**: Toggle multibahasa dan konfigurasi dinamis alamat server API.

2. **Dukungan Multibahasa Dinamis (ID & EN)**:
   - Mendukung **Bahasa Indonesia 🇮🇩 (`id`)** dan **English 🇬🇧 (`en`)**.
   - Dilengkapi `LocaleProvider` berbasis `ChangeNotifier` & `SharedPreferences` (pilihan bahasa tersimpan otomatis saat aplikasi dibuka kembali).
   - Tombol toggle bahasa instan (`LanguageSelectorButton`) di AppBar maupun menu pengaturan.
   - Header HTTP `Accept-Language` dan query parameter dikirim otomatis pada setiap request API ke backend Laravel Spatie Translatable.

3. **Backend Integration (`routes/api.php`)**:
   - `GET /api/v1/settings`
   - `GET /api/v1/slides`
   - `GET /api/v1/categories` & `/categories/{slug}`
   - `GET /api/v1/posts` & `/posts/{slug}`
   - `GET /api/v1/pages` & `/pages/{slug}`
   - `GET /api/v1/question-topics`
   - `GET /api/v1/questions`, `/questions/{id}`, & `POST /questions`
   - `GET /api/v1/faqs`

---

## 📂 Struktur Direktori

```text
portal_frontend/
├── lib/
│   ├── main.dart                                   # Entrypoint aplikasi & konfigurasi tema/lokalisasi
│   ├── core/
│   │   ├── constants/
│   │   │   └── api_constants.dart                  # Konfigurasi URL API & switch platform
│   │   ├── localization/
│   │   │   ├── app_localizations.dart              # Kamus kamus multibahasa ID & EN
│   │   │   └── locale_provider.dart                # State manager untuk locale & storage
│   │   ├── router/
│   │   │   └── app_router.dart                     # Konfigurasi go_router & navigasi tab/shell
│   │   └── services/
│   │       └── api_service.dart                    # HTTP client terpusat (otomatis Accept-Language)
│   ├── data/
│   │   └── models/                                 # Data models (Setting, Slide, Post, Faq, dll)
│   └── presentation/
│       ├── screens/
│       │   ├── shell_screen.dart                   # Shell layout (AppBar, Nav Bar, Language Switcher)
│       │   ├── home/home_screen.dart               # Halaman Beranda portal
│       │   ├── posts/posts_screen.dart             # Halaman Berita & filter kategori
│       │   ├── posts/post_detail_screen.dart       # Halaman Detail Berita
│       │   ├── pages/page_detail_screen.dart       # Halaman Statis Profil / Tentang Kami
│       │   ├── faq/faq_screen.dart                 # Halaman FAQ interaktif
│       │   ├── questions/questions_screen.dart     # Halaman Aspirasi masyarakat
│       │   ├── questions/question_detail_screen.dart # Detail pertanyaan & tanggapan resmi
│       │   ├── questions/create_question_screen.dart # Form submit pertanyaan ke API
│       │   └── settings/settings_screen.dart       # Pengaturan bahasa & base URL API
│       └── widgets/                                # Shared widgets (HtmlText, LanguageSelector, ErrorView, LoadingView)
└── test/
    └── widget_test.dart                            # Smoke testing widget
```

---

## 🛠️ Cara Menjalankan Aplikasi

1. **Jalankan Backend Laravel Terlebih Dahulu**:
   ```bash
   php artisan serve --port=8000
   ```

2. **Jalankan Aplikasi Flutter**:
   ```bash
   cd portal_frontend
   flutter run
   ```

3. **Catatan Koneksi URL API**:
   - **Android Emulator**: `http://10.0.2.2:8000/api/v1` (sudah diset otomatis sebagai default di Android).
   - **Windows Desktop / Web**: `http://127.0.0.1:8000/api/v1`.
   - **Perangkat Fisik HP (WiFi)**: Buka tab **Pengaturan (Settings)** di dalam aplikasi, masukkan IP laptop Anda (misal `http://192.168.1.10:8000/api/v1`), lalu tekan **Simpan**.
