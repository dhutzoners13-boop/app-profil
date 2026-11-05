<?php

namespace Tests\Feature;

use App\Filament\Resources\Categories\CategoryResource;
use App\Filament\Resources\Faqs\FaqResource;
use App\Filament\Resources\Media\MediaResource;
use App\Filament\Resources\Pages\PageResource;
use App\Filament\Resources\Posts\PostResource;
use App\Filament\Resources\QuestionTopics\QuestionTopicResource;
use App\Filament\Resources\Slides\SlideResource;
use App\Models\Category;
use App\Models\Faq;
use App\Models\Page;
use App\Models\Post;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\App;
use LaraZeus\SpatieTranslatable\Resources\Concerns\Translatable;
use Tests\TestCase;

class MultilingualTranslatableTest extends TestCase
{
    use RefreshDatabase;

    public function test_category_supports_multilingual_name_and_description(): void
    {
        $category = Category::create([
            'name' => [
                'id' => 'Berita Instansi',
                'en' => 'Agency News',
            ],
            'slug' => 'berita-instansi',
            'description' => [
                'id' => 'Deskripsi bahasa indonesia',
                'en' => 'English description',
            ],
            'is_active' => true,
        ]);

        App::setLocale('id');
        $this->assertEquals('Berita Instansi', $category->name);
        $this->assertEquals('Deskripsi bahasa indonesia', $category->description);

        App::setLocale('en');
        $this->assertEquals('Agency News', $category->name);
        $this->assertEquals('English description', $category->description);

        $this->assertEquals('berita-instansi', $category->slug);
    }

    public function test_post_supports_multilingual_title_summary_and_content(): void
    {
        $post = Post::create([
            'title' => [
                'id' => 'Judul Artikel',
                'en' => 'Article Title',
            ],
            'slug' => 'judul-artikel',
            'summary' => [
                'id' => 'Ringkasan ID',
                'en' => 'Summary EN',
            ],
            'content' => [
                'id' => '<p>Konten ID</p>',
                'en' => '<p>Content EN</p>',
            ],
            'status' => 'published',
        ]);

        App::setLocale('id');
        $this->assertEquals('Judul Artikel', $post->title);
        $this->assertEquals('Ringkasan ID', $post->summary);
        $this->assertEquals('<p>Konten ID</p>', $post->content);

        App::setLocale('en');
        $this->assertEquals('Article Title', $post->title);
        $this->assertEquals('Summary EN', $post->summary);
        $this->assertEquals('<p>Content EN</p>', $post->content);
    }

    public function test_page_and_faq_support_multilingual(): void
    {
        $page = Page::create([
            'title' => [
                'id' => 'Visi Misi',
                'en' => 'Vision and Mission',
            ],
            'slug' => 'visi-misi',
            'content' => [
                'id' => 'Konten visi misi',
                'en' => 'Vision mission content',
            ],
            'status' => 'published',
        ]);

        $faq = Faq::create([
            'question' => [
                'id' => 'Pertanyaan umum?',
                'en' => 'Common question?',
            ],
            'answer' => [
                'id' => 'Jawaban umum.',
                'en' => 'Common answer.',
            ],
        ]);

        App::setLocale('id');
        $this->assertEquals('Visi Misi', $page->title);
        $this->assertEquals('Pertanyaan umum?', $faq->question);

        App::setLocale('en');
        $this->assertEquals('Vision and Mission', $page->title);
        $this->assertEquals('Common question?', $faq->question);
    }

    public function test_filament_resources_use_translatable_trait(): void
    {
        $resources = [
            CategoryResource::class,
            PostResource::class,
            PageResource::class,
            MediaResource::class,
            SlideResource::class,
            QuestionTopicResource::class,
            FaqResource::class,
        ];

        foreach ($resources as $resource) {
            $traits = class_uses_recursive($resource);
            $this->assertArrayHasKey(
                Translatable::class,
                $traits,
                "Resource {$resource} does not use Translatable trait."
            );
        }
    }
}
