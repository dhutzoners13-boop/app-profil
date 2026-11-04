<?php

namespace Database\Seeders;

use App\Models\Category;
use App\Models\Faq;
use App\Models\Menu;
use App\Models\MenuItem;
use App\Models\Page;
use App\Models\Post;
use App\Models\QuestionTopic;
use App\Models\Setting;
use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // 1. Admin User
        $admin = User::firstOrCreate(
            ['email' => 'admin@example.com'],
            [
                'name' => 'Administrator',
                'password' => Hash::make('password'),
                'role' => 'admin',
                'email_verified_at' => now(),
            ]
        );

        // 2. Settings
        $defaultSettings = [
            ['group' => 'general', 'key' => 'site_name', 'value' => 'Dinas Komunikasi & Informatika', 'type' => 'text'],
            ['group' => 'general', 'key' => 'site_tagline', 'value' => 'Transparan, Akuntabel, dan Melayani Sepenuh Hati', 'type' => 'text'],
            ['group' => 'general', 'key' => 'site_description', 'value' => 'Portal resmi profil instansi pemerintah dan layanan tanya jawab interaktif masyarakat.', 'type' => 'textarea'],
            ['group' => 'contact', 'key' => 'contact_email', 'value' => 'info@instansi.go.id', 'type' => 'text'],
            ['group' => 'contact', 'key' => 'contact_phone', 'value' => '(021) 12345678', 'type' => 'text'],
            ['group' => 'contact', 'key' => 'contact_address', 'value' => 'Jl. Merdeka No. 45, Kompleks Perkantoran Pemerintah', 'type' => 'textarea'],
            ['group' => 'social', 'key' => 'social_instagram', 'value' => 'https://instagram.com/instansigoid', 'type' => 'text'],
            ['group' => 'social', 'key' => 'social_facebook', 'value' => 'https://facebook.com/instansigoid', 'type' => 'text'],
        ];

        foreach ($defaultSettings as $setting) {
            Setting::updateOrCreate(['key' => $setting['key']], $setting);
        }

        // 3. Categories
        $berita = Category::firstOrCreate(['slug' => 'berita-terkini'], [
            'name' => 'Berita Terkini',
            'description' => 'Kumpulan informasi dan berita terbaru seputar kegiatan instansi.',
            'sort_order' => 1,
            'is_active' => true,
        ]);

        $pengumuman = Category::firstOrCreate(['slug' => 'pengumuman-resmi'], [
            'name' => 'Pengumuman Resmi',
            'description' => 'Pemberitahuan, surat edaran, dan pengumuman resmi.',
            'sort_order' => 2,
            'is_active' => true,
        ]);

        // 4. Sample Post
        Post::firstOrCreate(['slug' => 'peluncuran-portal-layanan-digital'], [
            'user_id' => $admin->id,
            'category_id' => $berita->id,
            'title' => 'Peluncuran Portal Informasi dan Layanan Digital Masyarakat',
            'summary' => 'Instansi meluncurkan portal terpadu untuk mempermudah masyarakat mengakses profil informasi dan menyampaikan pertanyaan langsung.',
            'content' => '<p>Dalam rangka meningkatkan mutu pelayanan publik dan keterbukaan informasi, kami secara resmi meluncurkan portal terpadu ini.</p><p>Masyarakat kini dapat memantau berita terbaru, membaca FAQ, serta mengirimkan pertanyaan atau pengaduan secara daring melalui aplikasi mobile yang terhubung.</p>',
            'status' => 'published',
            'published_at' => now(),
            'view_count' => 12,
            'is_featured' => true,
        ]);

        // 5. Sample Page
        Page::firstOrCreate(['slug' => 'tentang-kami'], [
            'user_id' => $admin->id,
            'title' => 'Tentang Kami',
            'content' => '<h2>Visi & Misi</h2><p>Mewujudkan tata kelola instansi yang prima, adaptif teknologi, dan ramah masyarakat.</p>',
            'status' => 'published',
            'sort_order' => 1,
            'show_in_menu' => true,
        ]);

        // 6. Question Topics
        $topicPelayanan = QuestionTopic::firstOrCreate(['slug' => 'pelayanan-publik'], [
            'name' => 'Pelayanan Publik & Perizinan',
            'description' => 'Pertanyaan seputar prosedur, syarat, dan jadwal pelayanan publik.',
            'sort_order' => 1,
            'is_active' => true,
        ]);

        $topicUmum = QuestionTopic::firstOrCreate(['slug' => 'informasi-umum'], [
            'name' => 'Informasi Umum & Regulasi',
            'description' => 'Pertanyaan mengenai aturan, struktur instansi, dan informasi umum.',
            'sort_order' => 2,
            'is_active' => true,
        ]);

        // 7. FAQs
        Faq::firstOrCreate(['question' => 'Berapa lama proses tanggapan pertanyaan masyarakat?'], [
            'topic_id' => $topicPelayanan->id,
            'answer' => '<p>Pertanyaan yang masuk akan diverifikasi dan dijawab oleh tim humas/petugas teknis dalam waktu maksimal <strong>1 x 24 jam kerja</strong>.</p>',
            'sort_order' => 1,
            'is_active' => true,
        ]);

        Faq::firstOrCreate(['question' => 'Kapan jam operasional pelayanan tatap muka?'], [
            'topic_id' => $topicPelayanan->id,
            'answer' => '<p>Pelayanan tatap muka dibuka setiap hari Senin - Jumat pukul <strong>08.00 - 15.30 WIB</strong>.</p>',
            'sort_order' => 2,
            'is_active' => true,
        ]);

        // 8. Navigation Menus
        $headerMenu = Menu::firstOrCreate(['location' => 'header'], [
            'name' => 'Menu Utama Header',
            'is_active' => true,
        ]);

        MenuItem::firstOrCreate(['menu_id' => $headerMenu->id, 'label' => 'Beranda'], [
            'url' => '/',
            'type' => 'custom',
            'sort_order' => 1,
            'is_active' => true,
        ]);

        MenuItem::firstOrCreate(['menu_id' => $headerMenu->id, 'label' => 'Tentang Kami'], [
            'url' => '/tentang-kami',
            'type' => 'page',
            'sort_order' => 2,
            'is_active' => true,
        ]);

        MenuItem::firstOrCreate(['menu_id' => $headerMenu->id, 'label' => 'Berita'], [
            'url' => '/berita',
            'type' => 'category',
            'sort_order' => 3,
            'is_active' => true,
        ]);
    }
}
