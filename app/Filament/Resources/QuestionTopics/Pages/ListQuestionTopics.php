<?php

namespace App\Filament\Resources\QuestionTopics\Pages;

use App\Filament\Resources\QuestionTopics\QuestionTopicResource;
use Filament\Actions\CreateAction;
use Filament\Resources\Pages\ListRecords;

class ListQuestionTopics extends ListRecords
{
    protected static string $resource = QuestionTopicResource::class;

    protected function getHeaderActions(): array
    {
        return [
            CreateAction::make(),
        ];
    }
}
