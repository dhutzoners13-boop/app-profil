<?php

namespace App\Filament\Resources\QuestionTopics\Schemas;

use Filament\Forms\Components\Textarea;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Toggle;
use Filament\Schemas\Components\Grid;
use Filament\Schemas\Components\Section;
use Filament\Schemas\Components\Utilities\Set;
use Filament\Schemas\Schema;
use Illuminate\Support\Str;

class QuestionTopicForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Section::make(__('Topic Information'))
                    ->schema([
                        Grid::make(2)->schema([
                            TextInput::make('name')
                                ->label(__('Topic Name'))
                                ->required()
                                ->maxLength(255)
                                ->live(onBlur: true)
                                ->afterStateUpdated(fn (Set $set, ?string $state) => $set('slug', Str::slug($state ?? ''))),
                            TextInput::make('slug')
                                ->label(__('Slug'))
                                ->required()
                                ->maxLength(255)
                                ->unique(ignoreRecord: true),
                        ]),
                        Textarea::make('description')
                            ->label(__('Topic Description'))
                            ->rows(3)
                            ->columnSpanFull(),
                        Grid::make(3)->schema([
                            TextInput::make('icon')
                                ->label(__('Icon (Heroicon)'))
                                ->placeholder('heroicon-o-chat-bubble-left'),
                            TextInput::make('sort_order')
                                ->label(__('Order'))
                                ->numeric()
                                ->default(0),
                            Toggle::make('is_active')
                                ->label(__('Active Status'))
                                ->default(true),
                        ]),
                    ]),
            ]);
    }
}
