<?php

namespace Tests\Feature;

use App\Models\Category;
use App\Models\Faq;
use App\Models\Menu;
use App\Models\MenuItem;
use App\Models\Page;
use App\Models\Post;
use App\Models\QuestionTopic;
use App\Models\Setting;
use App\Models\Slide;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class ApiEndpointsTest extends TestCase
{
    use RefreshDatabase;

    public function test_can_list_posts(): void
    {
        $user = User::factory()->create();
        $category = Category::factory()->create();

        Post::factory()->create([
            'user_id' => $user->id,
            'category_id' => $category->id,
            'status' => 'published',
            'published_at' => now()->subDay(),
        ]);

        $response = $this->getJson('/api/v1/posts');

        $response->assertStatus(200)
            ->assertJsonStructure([
                'data' => [
                    '*' => ['id', 'title', 'slug', 'status'],
                ],
            ]);
    }

    public function test_can_get_single_post_and_increment_view(): void
    {
        $user = User::factory()->create();
        $category = Category::factory()->create();

        $post = Post::factory()->create([
            'user_id' => $user->id,
            'category_id' => $category->id,
            'status' => 'published',
            'published_at' => now()->subDay(),
            'view_count' => 0,
        ]);

        $response = $this->getJson('/api/v1/posts/'.$post->slug);

        $response->assertStatus(200)
            ->assertJsonPath('data.slug', $post->slug);

        $this->assertEquals(1, $post->fresh()->view_count);
    }

    public function test_can_list_categories(): void
    {
        Category::factory()->create(['is_active' => true]);

        $response = $this->getJson('/api/v1/categories');

        $response->assertStatus(200)
            ->assertJsonStructure([
                'data' => [
                    '*' => ['id', 'name', 'slug'],
                ],
            ]);
    }

    public function test_can_get_pages(): void
    {
        $page = Page::create([
            'title' => 'Visi Misi',
            'slug' => 'visi-misi',
            'content' => '<p>Visi dan Misi kami</p>',
            'status' => 'published',
            'sort_order' => 1,
            'show_in_menu' => true,
        ]);

        $response = $this->getJson('/api/v1/pages/'.$page->slug);

        $response->assertStatus(200)
            ->assertJsonPath('data.title', 'Visi Misi');
    }

    public function test_can_get_slides(): void
    {
        Slide::create([
            'title' => 'Banner Pelayanan',
            'image' => 'slides/test.jpg',
            'is_active' => true,
            'sort_order' => 1,
        ]);

        $response = $this->getJson('/api/v1/slides');

        $response->assertStatus(200)
            ->assertJsonStructure([
                'data' => [
                    '*' => ['id', 'title'],
                ],
            ]);
    }

    public function test_can_get_menus_by_location(): void
    {
        $menu = Menu::create([
            'name' => 'Header Nav',
            'location' => 'header',
            'is_active' => true,
        ]);

        MenuItem::create([
            'menu_id' => $menu->id,
            'label' => 'Home',
            'url' => '/',
            'is_active' => true,
            'sort_order' => 1,
        ]);

        $response = $this->getJson('/api/v1/menus/header');

        $response->assertStatus(200)
            ->assertJsonPath('data.location', 'header');
    }

    public function test_can_get_settings(): void
    {
        Setting::create([
            'group' => 'general',
            'key' => 'site_name',
            'value' => 'Dinas Kominfo',
            'type' => 'text',
        ]);

        $response = $this->getJson('/api/v1/settings');

        $response->assertStatus(200)
            ->assertJsonPath('data.site_name', 'Dinas Kominfo');
    }

    public function test_can_get_faqs(): void
    {
        $topic = QuestionTopic::create([
            'name' => 'Umum',
            'slug' => 'umum',
            'is_active' => true,
        ]);

        Faq::create([
            'topic_id' => $topic->id,
            'question' => 'Bagaimana cara bertanya?',
            'answer' => 'Gunakan formulir online.',
            'is_active' => true,
            'sort_order' => 1,
        ]);

        $response = $this->getJson('/api/v1/faqs');

        $response->assertStatus(200)
            ->assertJsonStructure([
                'data' => [
                    '*' => ['id', 'question', 'answer'],
                ],
            ]);
    }

    public function test_can_submit_question(): void
    {
        $topic = QuestionTopic::create([
            'name' => 'Layanan Kependudukan',
            'slug' => 'layanan-kependudukan',
            'is_active' => true,
        ]);

        $payload = [
            'topic_id' => $topic->id,
            'name' => 'Budi Santoso',
            'email' => 'budi@example.com',
            'phone' => '08123456789',
            'subject' => 'Pertanyaan mengenai syarat pengajuan KTP baru',
            'body' => 'Mohon informasinya mengenai berkas apa saja yang wajib dilampirkan.',
        ];

        $response = $this->postJson('/api/v1/questions', $payload);

        $response->assertStatus(201)
            ->assertJsonPath('data.subject', $payload['subject']);

        $this->assertDatabaseHas('questions', [
            'email' => 'budi@example.com',
            'status' => 'pending',
        ]);
    }
}
