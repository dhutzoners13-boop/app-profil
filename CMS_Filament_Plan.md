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

## 📦 Status Implementasi

### Fase 1: Fondasi & Konfigurasi ⏱️
- [x] Install Laravel 13 + Filament v5
- [x] Konfigurasi database MySQL (`.env`)
- [x] Setup Filament Admin Panel (tema Emerald, branding "Portal Profil & Layanan")
- [x] Konfigurasi role, permission & avatar pada model User
- [x] Buat migration tabel `settings` & `SettingResource`

### Fase 2: Modul CMS ⏱️
- [x] **Kategori**: Model, Migration, Factory, Seeder, `CategoryResource`
- [x] **Post/Artikel**: Model, Migration, Factory, Seeder, `PostResource` (RichEditor, upload gambar, auto slug)
- [x] **Halaman Statis**: Model, Migration, `PageResource`
- [x] **Media Library**: Model, Migration, `MediaResource` (direct storage upload)
- [x] **Menu & Menu Items**: Model, Migration, `MenuResource` (Repeater nested items)
- [x] **Slide**: Model, Migration, `SlideResource` (jadwal tayang)

### Fase 3: Modul Pertanyaan Masyarakat ⏱️
- [x] **Topik Pertanyaan**: Model, Migration, `QuestionTopicResource`
- [x] **Pertanyaan**: Model, Migration, `QuestionResource`
- [x] **Jawaban Pertanyaan**: Model, Migration, `AnswersRelationManager` di `QuestionResource` (auto-update status `answered`)
- [x] **FAQ**: Model, Migration, `FaqResource`

### Fase 4: REST API untuk Flutter ⏱️
- [x] Install & konfigurasi Laravel Sanctum
- [x] Endpoints REST API v1 lengkap (`/api/v1/*`)
- [x] API Resource formatters (`PostResource`, `MenuResource`, `QuestionResource`, dll)
- [x] Rate limiting throttle pada pengiriman pertanyaan masyarakat
- [x] Storage public symlink (`php artisan storage:link`)
- [x] Automated Test Suite PHPUnit (11 passing tests)
- [x] Code style formatting with Laravel Pint
