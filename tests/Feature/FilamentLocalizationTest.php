<?php

namespace Tests\Feature;

use App\Filament\Resources\Categories\CategoryResource;
use App\Filament\Resources\Faqs\FaqResource;
use App\Filament\Resources\Media\MediaResource;
use App\Filament\Resources\Menus\MenuResource;
use App\Filament\Resources\Pages\PageResource;
use App\Filament\Resources\Posts\PostResource;
use App\Filament\Resources\Questions\QuestionResource;
use App\Filament\Resources\QuestionTopics\QuestionTopicResource;
use App\Filament\Resources\Settings\SettingResource;
use App\Filament\Resources\Slides\SlideResource;
use Illuminate\Support\Facades\App;
use Tests\TestCase;

class FilamentLocalizationTest extends TestCase
{
    public function test_filament_resources_labels_in_indonesian(): void
    {
        App::setLocale('id');

        $this->assertEquals('Kategori', CategoryResource::getModelLabel());
        $this->assertEquals('Kategori', CategoryResource::getPluralModelLabel());
        $this->assertEquals('CMS', CategoryResource::getNavigationGroup());

        $this->assertEquals('Artikel', PostResource::getModelLabel());
        $this->assertEquals('Artikel', PostResource::getPluralModelLabel());
        $this->assertEquals('CMS', PostResource::getNavigationGroup());

        $this->assertEquals('Halaman Statis', PageResource::getModelLabel());
        $this->assertEquals('Halaman Statis', PageResource::getPluralModelLabel());

        $this->assertEquals('Media', MediaResource::getModelLabel());
        $this->assertEquals('Pustaka Media', MediaResource::getPluralModelLabel());

        $this->assertEquals('Menu', MenuResource::getModelLabel());
        $this->assertEquals('Menu Navigasi', MenuResource::getPluralModelLabel());

        $this->assertEquals('Slide Banner', SlideResource::getModelLabel());
        $this->assertEquals('Slide Banner', SlideResource::getPluralModelLabel());

        $this->assertEquals('Pertanyaan Masuk', QuestionResource::getModelLabel());
        $this->assertEquals('Pertanyaan Masyarakat', QuestionResource::getPluralModelLabel());
        $this->assertEquals('Pertanyaan Masyarakat', QuestionResource::getNavigationGroup());

        $this->assertEquals('Topik Pertanyaan', QuestionTopicResource::getModelLabel());
        $this->assertEquals('Topik Pertanyaan', QuestionTopicResource::getPluralModelLabel());

        $this->assertEquals('FAQ', FaqResource::getModelLabel());
        $this->assertEquals('FAQ', FaqResource::getPluralModelLabel());

        $this->assertEquals('Pengaturan', SettingResource::getModelLabel());
        $this->assertEquals('Pengaturan Situs', SettingResource::getPluralModelLabel());
        $this->assertEquals('Pengaturan', SettingResource::getNavigationGroup());
    }

    public function test_filament_resources_labels_in_english(): void
    {
        App::setLocale('en');

        $this->assertEquals('Category', CategoryResource::getModelLabel());
        $this->assertEquals('Categories', CategoryResource::getPluralModelLabel());
        $this->assertEquals('CMS', CategoryResource::getNavigationGroup());

        $this->assertEquals('Article', PostResource::getModelLabel());
        $this->assertEquals('Articles', PostResource::getPluralModelLabel());
        $this->assertEquals('CMS', PostResource::getNavigationGroup());

        $this->assertEquals('Static Page', PageResource::getModelLabel());
        $this->assertEquals('Static Pages', PageResource::getPluralModelLabel());

        $this->assertEquals('Media', MediaResource::getModelLabel());
        $this->assertEquals('Media Library', MediaResource::getPluralModelLabel());

        $this->assertEquals('Menu', MenuResource::getModelLabel());
        $this->assertEquals('Navigation Menus', MenuResource::getPluralModelLabel());

        $this->assertEquals('Slide Banner', SlideResource::getModelLabel());
        $this->assertEquals('Slide Banners', SlideResource::getPluralModelLabel());

        $this->assertEquals('Incoming Question', QuestionResource::getModelLabel());
        $this->assertEquals('Public Inquiries', QuestionResource::getPluralModelLabel());
        $this->assertEquals('Public Inquiries', QuestionResource::getNavigationGroup());

        $this->assertEquals('Question Topic', QuestionTopicResource::getModelLabel());
        $this->assertEquals('Question Topics', QuestionTopicResource::getPluralModelLabel());

        $this->assertEquals('FAQ', FaqResource::getModelLabel());
        $this->assertEquals('FAQs', FaqResource::getPluralModelLabel());

        $this->assertEquals('Setting', SettingResource::getModelLabel());
        $this->assertEquals('Site Settings', SettingResource::getPluralModelLabel());
        $this->assertEquals('Settings', SettingResource::getNavigationGroup());
    }

    public function test_form_and_table_keys_exist_in_language_files(): void
    {
        $idJson = json_decode(file_get_contents(base_path('lang/id.json')), true);
        $enJson = json_decode(file_get_contents(base_path('lang/en.json')), true);

        $keys = [
            'Category Name',
            'Order',
            'Active Status',
            'Total Posts',
            'FAQ Topic',
            'Alternative Text (Alt Text)',
            'Placement Location',
            'Publication Date',
            'Questioner Identity',
            'Full Name',
            'Official Answers',
            'Responding Officer',
            'Configuration Settings',
            'Slide Information',
            'Total Articles',
        ];

        foreach ($keys as $key) {
            $this->assertArrayHasKey($key, $idJson, "Missing key in id.json: {$key}");
            $this->assertArrayHasKey($key, $enJson, "Missing key in en.json: {$key}");
        }
    }
}

