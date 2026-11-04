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
            Stat::make(__('Total Articles'), $postsCount)
                ->description(__('Published articles & news'))
                ->descriptionIcon('heroicon-m-document-text')
                ->color('success'),
            Stat::make(__('Categories'), $categoriesCount)
                ->description(__('Active content categories'))
                ->descriptionIcon('heroicon-m-folder')
                ->color('info'),
            Stat::make(__('Incoming Questions'), $pendingQuestions)
                ->description(__('Awaiting response'))
                ->descriptionIcon('heroicon-m-clock')
                ->color($pendingQuestions > 0 ? 'warning' : 'gray'),
            Stat::make(__('Public FAQs'), $faqsCount)
                ->description(__('Saved questions & answers'))
                ->descriptionIcon('heroicon-m-light-bulb')
                ->color('primary'),
        ];
    }
}
