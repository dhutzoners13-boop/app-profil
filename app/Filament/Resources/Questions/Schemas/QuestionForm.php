<?php

namespace App\Filament\Resources\Questions\Schemas;

use Filament\Forms\Components\Select;
use Filament\Forms\Components\Textarea;
use Filament\Forms\Components\TextInput;
use Filament\Schemas\Components\Grid;
use Filament\Schemas\Components\Section;
use Filament\Schemas\Schema;

class QuestionForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Section::make(__('Questioner Identity'))
                    ->schema([
                        Grid::make(3)->schema([
                            TextInput::make('name')
                                ->label(__('Full Name'))
                                ->required()
                                ->maxLength(255),
                            TextInput::make('email')
                                ->label(__('Email'))
                                ->email()
                                ->required()
                                ->maxLength(255),
                            TextInput::make('phone')
                                ->label(__('Phone / WhatsApp'))
                                ->tel()
                                ->maxLength(50),
                        ]),
                    ]),

                Section::make(__('Question Details'))
                    ->schema([
                        Grid::make(2)->schema([
                            Select::make('topic_id')
                                ->label(__('Topic / Category'))
                                ->relationship('topic', 'name')
                                ->searchable()
                                ->preload()
                                ->required(),
                            Select::make('status')
                                ->label(__('Question Status'))
                                ->options([
                                    'pending' => __('Awaiting Response'),
                                    'answered' => __('Answered'),
                                    'rejected' => __('Rejected / Irrelevant'),
                                ])
                                ->default('pending')
                                ->required(),
                        ]),
                        TextInput::make('subject')
                            ->label(__('Title / Subject'))
                            ->required()
                            ->maxLength(255),
                        Textarea::make('body')
                            ->label(__('Question Body'))
                            ->rows(5)
                            ->required()
                            ->columnSpanFull(),
                        TextInput::make('ip_address')
                            ->label(__('IP Address'))
                            ->disabled()
                            ->dehydrated(false),
                    ]),
            ]);
    }
}
