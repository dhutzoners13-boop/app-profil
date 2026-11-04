<?php

namespace App\Filament\Resources\QuestionTopics\Pages;

use App\Filament\Resources\QuestionTopics\QuestionTopicResource;
use Filament\Actions\DeleteAction;
use Filament\Resources\Pages\EditRecord;

class EditQuestionTopic extends EditRecord
{
    protected static string $resource = QuestionTopicResource::class;

    protected function getHeaderActions(): array
    {
        return [
            DeleteAction::make(),
        ];
    }
}
