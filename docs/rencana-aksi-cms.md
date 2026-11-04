# 📋 Rencana Aksi: Aplikasi CMS & Pertanyaan Masyarakat

> Aplikasi Laravel 13 + Filament v5.11 sebagai backend (Admin Panel + REST API) untuk mengelola konten profil instansi dan menerima pertanyaan dari masyarakat. Frontend publik akan dibangun terpisah menggunakan **Flutter**.

---

## 🗂️ Entity Relationship Diagram (ERD)

```mermaid
erDiagram
    users {
        bigint id PK
        string name
        string email UK
        string password
        string avatar
        enum role "admin, editor, viewer"
        timestamp email_verified_at
        timestamps created_at
        timestamps updated_at
    }

    categories {
        bigint id PK
        string name
        string slug UK
        text description
        string icon
        int sort_order
        boolean is_active
        timestamps created_at
        timestamps updated_at
    }

    posts {
        bigint id PK
        bigint user_id FK
        bigint category_id FK
        string title
        string slug UK
        text summary
        longtext content
        string image
        enum status "draft, published, archived"
        timestamp published_at
        int view_count
        boolean is_featured
        timestamps created_at
        timestamps updated_at
    }

    pages {
        bigint id PK
        bigint user_id FK
        string title
        string slug UK
        longtext content
        string image
        enum status "draft, published"
        int sort_order
        boolean show_in_menu
        timestamps created_at
        timestamps updated_at
    }

    media {
        bigint id PK
        bigint user_id FK
        string file_name
        string file_path
        string mime_type
        bigint file_size
        string alt_text
        string disk
        timestamps created_at
        timestamps updated_at
    }

    menus {
        bigint id PK
        string name
        string location "header, footer, sidebar"
        boolean is_active
        timestamps created_at
        timestamps updated_at
    }

    menu_items {
        bigint id PK
        bigint menu_id FK
        bigint parent_id FK "nullable, self-reference"
        string label
        string url
        string type "page, post, category, custom"
        bigint linkable_id "nullable"
        string linkable_type "nullable"
        int sort_order
        boolean is_active
        timestamps created_at
        timestamps updated_at
    }

    slides {
        bigint id PK
        string title
        text description
        string image
        string link_url
        int sort_order
        boolean is_active
        date start_date
        date end_date
        timestamps created_at
        timestamps updated_at
    }

    settings {
        bigint id PK
        string group
        string key UK
        text value
        string type "text, textarea, image, boolean, json"
        timestamps created_at
        timestamps updated_at
    }

    questions {
        bigint id PK
        bigint topic_id FK
        string name
        string email
        string phone
        string subject
        longtext body
        enum status "pending, answered, rejected"
        string ip_address
        timestamps created_at
        timestamps updated_at
    }

    question_answers {
        bigint id PK
        bigint question_id FK
        bigint user_id FK
        longtext body
        enum status "draft, published, rejected"
        boolean is_published
        timestamp answered_at
        timestamps created_at
        timestamps updated_at
    }

    question_topics {
        bigint id PK
        string name
        string slug UK
        text description
        string icon
        int sort_order
        boolean is_active
        timestamps created_at
        timestamps updated_at
    }

    faqs {
        bigint id PK
        bigint topic_id FK
        string question
        longtext answer
        int sort_order
        boolean is_active
        timestamps created_at
        timestamps updated_at
    }

    users ||--o{ posts : "menulis"
    users ||--o{ pages : "menulis"
    users ||--o{ media : "mengunggah"
    users ||--o{ question_answers : "menjawab"

    categories ||--o{ posts : "memiliki"

    menus ||--o{ menu_items : "memiliki"
    menu_items ||--o{ menu_items : "parent-child"

    question_topics ||--o{ questions : "topik"
    question_topics ||--o{ faqs : "topik"

    questions ||--o{ question_answers : "dijawab"
```

---

## 🏛️ Arsitektur Sistem (API-First)

```mermaid
flowchart LR
    subgraph Flutter["Flutter App (Mobile & Web)"]
        FA["📱 Flutter Frontend"]
    end

    subgraph Laravel["Laravel Backend"]
        API["🔌 REST API\n/api/v1/*"]
        FP["🛠️ Filament Admin Panel\n/admin"]
        Models["📦 Models & Business Logic"]
        DB[("🗄️ Database\nMySQL/PostgreSQL")]
    end

    FA -->|"HTTP Requests\n(JSON)"| API
    API --> Models
    FP --> Models
    Models --> DB
    API -->|"JSON Responses"| FA
```

---

## 🏗️ Arsitektur Modul

### Modul 1: CMS (Content Management System)

| Fitur | Deskripsi | Status |
|-------|-----------|--------|
| **Manajemen Post/Artikel** | CRUD artikel dengan kategori, gambar sampul, status draft/publish/archived, rich text editor | ✅ Selesai |
| **Manajemen Halaman Statis** | Halaman seperti "Tentang Kami", "Visi Misi", "Struktur Organisasi" | ✅ Selesai |
| **Manajemen Kategori** | Pengelompokan artikel berdasarkan kategori dengan slug otomatis | ✅ Selesai |
| **Manajemen Media** | Upload & kelola gambar dan berkas lampiran | ✅ Selesai |
| **Manajemen Menu** | Menu navigasi dinamis untuk header, footer, sidebar (Repeater item) | ✅ Selesai |
| **Manajemen Slide** | Slide banner promosi dengan jadwal tanggal tayang | ✅ Selesai |
| **Pengaturan Situs** | Konfigurasi profil instansi, kontak, medsos, dan API | ✅ Selesai |

### Modul 2: Pertanyaan Masyarakat

| Fitur | Deskripsi | Status |
|-------|-----------|--------|
| **Form Pertanyaan Publik** | REST API endpoint untuk masyarakat mengirim pertanyaan (dikonsumsi Flutter) | ✅ Selesai |
| **Topik Pertanyaan** | Kategori topik pertanyaan (pelayanan publik, perizinan, umum) | ✅ Selesai |
| **Manajemen Pertanyaan** | Admin review, jawab, atau tolak pertanyaan masuk | ✅ Selesai |
| **Jawaban Pertanyaan** | Relation Manager jawaban petugas langsung di detail pertanyaan | ✅ Selesai |
| **FAQ** | Kumpulan pertanyaan yang sering diajukan per topik | ✅ Selesai |

---

## 📦 Tahapan Implementasi

### Fase 1: Fondasi & Konfigurasi ⏱️

- [x] Install Laravel 13 + Filament v5
- [x] Konfigurasi database (`.env`)
- [x] Setup Filament Admin Panel (tema Emerald, branding "Portal Profil & Layanan")
- [x] Konfigurasi role, permission & avatar pada model User
- [x] Buat migration untuk tabel `settings`
- [x] Buat `SettingResource` di Filament

### Fase 2: Modul CMS ⏱️

- [x] **Kategori**
  - [x] Buat Model, Migration, Factory, Seeder
  - [x] Buat `CategoryResource` (Filament)
- [x] **Post/Artikel**
  - [x] Buat Model, Migration, Factory, Seeder
  - [x] Buat `PostResource` (Filament) dengan rich text editor & upload gambar
  - [x] Implementasi slug otomatis, featured image, status filter
- [x] **Halaman Statis**
  - [x] Buat Model, Migration, Factory
  - [x] Buat `PageResource` (Filament)
- [x] **Media Library**
  - [x] Buat Model, Migration
  - [x] Buat `MediaResource` dengan direct storage upload
- [x] **Menu & Menu Items**
  - [x] Buat Model, Migration
  - [x] Buat `MenuResource` dengan nested menu items (Repeater)
- [x] **Slide**
  - [x] Buat Model, Migration
  - [x] Buat `SlideResource` (Filament) dengan filter aktif & masa tayang

### Fase 3: Modul Pertanyaan Masyarakat ⏱️

- [x] **Topik Pertanyaan**
  - [x] Buat Model, Migration
  - [x] Buat `QuestionTopicResource` (Filament)
- [x] **Pertanyaan**
  - [x] Buat Model, Migration
  - [x] Buat `QuestionResource` (Filament) dengan filter status
- [x] **Jawaban Pertanyaan**
  - [x] Buat Model, Migration
  - [x] Integrasikan jawaban sebagai Relation Manager (`AnswersRelationManager`) di `QuestionResource`
  - [x] Auto-update status pertanyaan menjadi `answered` saat tanggapan diterbitkan
- [x] **FAQ**
  - [x] Buat Model, Migration
  - [x] Buat `FaqResource` (Filament)

### Fase 4: REST API untuk Flutter ⏱️

- [x] Install & konfigurasi Laravel Sanctum untuk API
- [x] **API Publik (REST API v1)**
  - [x] `GET /api/v1/posts` — Daftar artikel (pagination, filter kategori, search, featured)
  - [x] `GET /api/v1/posts/{slug}` — Detail artikel + otomatis increment view_count
  - [x] `GET /api/v1/pages` & `GET /api/v1/pages/{slug}` — Detail halaman statis
  - [x] `GET /api/v1/categories` & `GET /api/v1/categories/{slug}` — Daftar kategori
  - [x] `GET /api/v1/slides` — Daftar slide banner aktif
  - [x] `GET /api/v1/menus` & `GET /api/v1/menus/{location}` — Menu navigasi (header/footer/sidebar)
  - [x] `GET /api/v1/settings` — Pengaturan situs (profil instansi, kontak, medsos)
  - [x] `GET /api/v1/faqs` — Daftar FAQ publik (filter per topik)
  - [x] `GET /api/v1/question-topics` — Daftar topik pertanyaan
  - [x] `GET /api/v1/questions` & `GET /api/v1/questions/{id}` — Pertanyaan dijawab publik
  - [x] `POST /api/v1/questions` — Kirim pertanyaan baru (validasi + rate limit)
- [x] Buat API Resource classes (`PostResource`, `SlideResource`, `MenuResource`, `QuestionResource`, dll)
- [x] Integrasi storage link (`php artisan storage:link`)
- [x] Unit/Feature Test suite lengkap (11 tests passed, 38 assertions)
