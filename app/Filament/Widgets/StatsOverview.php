<?php

namespace App\Filament\Widgets;

use App\Models\Category;
use App\Models\Faq;
use App\Models\Post;
use App\Models\Question;
use Filament\Widgets\StatsOverviewWidget;
use Filament\Widgets\StatsOverviewWidget\Stat;

class StatsOverview extends StatsOverviewWidget
{
    protected function getStats(): array
    {
        $postsCount = Post::count();
        $categoriesCount = Category::count();
        $pendingQuestions = Question::where('status', 'pending')->count();
        $faqsCount = Faq::count();

        return [
            Stat::make('Total Artikel', $postsCount)
                ->description('Artikel & Berita terbit')
                ->descriptionIcon('heroicon-m-document-text')
                ->color('success'),
            Stat::make('Kategori', $categoriesCount)
                ->description('Kategori konten aktif')
                ->descriptionIcon('heroicon-m-folder')
                ->color('info'),
            Stat::make('Pertanyaan Masuk', $pendingQuestions)
                ->description('Menunggu tanggapan')
                ->descriptionIcon('heroicon-m-clock')
                ->color($pendingQuestions > 0 ? 'warning' : 'gray'),
            Stat::make('FAQ Publik', $faqsCount)
                ->description('Tanya jawab tersimpan')
                ->descriptionIcon('heroicon-m-light-bulb')
                ->color('primary'),
        ];
    }
}
